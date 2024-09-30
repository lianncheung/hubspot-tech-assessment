with

calendar as (

    select * from {{ ref('int_calendar_windowed_by_day' )}}

),

listings as (

    select * from {{ ref('stg_lianns_fab_rentals__listings' )}}

),

amenities as (

    select * from {{ ref('int_amenities_scd' )}}

),

reviews as (

    select * from {{ ref('int_reviews_aggregated' )}}

),

listings_and_calendar_and_amenities_and_reviews_joined as (

    select

        -- listing_id + calendar_date will be our primary key for this table
        calendar.listing_id,
        calendar.calendar_date,
        
        -- listing and host information
        listings.listing_name,
        listings.host_id,
        listings.host_name,
        listings.host_since_date,
        listings.host_location,
        listings.host_verifications,
        listings.neighborhood,
        listings.property_type,
        listings.room_type,
        listings.accommodates,
        listings.bathrooms_text,
        listings.bathrooms,
        listings.bedrooms,
        listings.beds,

        -- get amenities data from int_amenities_scd in case there were changes over the calendar timeframe
        amenities.amenities,

        -- get rolling review score avg from int_reviews_rolling_avg in case there were changes over the calendar timeframe
        reviews.rolling_avg_review_score,
    
        -- get review totals and min/max dates
        reviews.total_reviews,
        reviews.first_review_date,
        reviews.last_review_date,

        -- listing availability and revenue data
        calendar.is_available,
        calendar.reservation_id,
        calendar.price_usd,
        calendar.revenue_usd,
        calendar.minimum_nights,
        calendar.maximum_nights,
        calendar.duration_available_if_stay_end_date

    from calendar

    left join listings
        on calendar.listing_id = listings.id

    left join amenities
        on calendar.listing_id = amenities.listing_id
        and calendar.calendar_date::timestamp between amenities.start_timestamp and coalesce(amenities.end_timestamp, current_timestamp)

    left join reviews
        on calendar.listing_id = reviews.listing_id
        and calendar.calendar_date between reviews.review_rolling_avg_start_date and coalesce(reviews.review_rolling_avg_end_date, current_date)
)

select * from listings_and_calendar_and_amenities_and_reviews_joined
