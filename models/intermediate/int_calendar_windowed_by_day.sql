with

calendar as (

    select * from {{ ref('stg_lianns_fab_rentals__calendar' )}}

),

calendar_window_function_setup as (

    select
    
        -- create "group" for availability change to setup window function in next step to calculate max duration availability
        conditional_change_event(is_available) over (partition by listing_id order by calendar_date) as availability_change_group,

        listing_id,
        calendar_date,
        is_available,
        reservation_id,
        price_usd,
        revenue_usd,
        minimum_nights,
        maximum_nights
    
    from calendar

),

calendar_windowed_by_date as (

    select

        -- if listing is available, take the running duration nights that listing available using rank (with the calendar_date as the stay end date)
        case
            when is_available = true then rank() over (partition by listing_id, availability_change_group order by calendar_date)
        end as duration_available_if_stay_end_date,

        listing_id,
        calendar_date,
        is_available,
        reservation_id,
        price_usd,
        revenue_usd,
        minimum_nights,
        maximum_nights
    
    from calendar_window_function_setup
)

select * from calendar_windowed_by_date
