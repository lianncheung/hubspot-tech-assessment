with

source as (

    select * from {{ source('lianns_fab_rentals', 'listings') }}

),

renamed as (

    select

        id,
        name as listing_name,

        -- host info
        host_id,
        host_name,
        host_since::date as host_since_date,
        host_location,
        parse_json(host_verifications) as host_verifications,

        -- property info
        neighborhood,
        property_type,
        room_type,
        accommodates,
        bathrooms_text,
        regexp_substr(bathrooms_text,'\\d*\\.?\\d+') as bathrooms,
        bedrooms,
        beds,
        parse_json(amenities) as amenities,
        cast(replace(price, '$', '') as float) as price_at_calendar_start,

        -- review info
        number_of_reviews,
        first_review::date as first_review_date,
        last_review::date as last_review_date,
        review_scores_rating as avg_review_score

    from source

)

select * from renamed
