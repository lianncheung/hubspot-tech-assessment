with calendar as (

    select * from {{ ref('stg_lianns_fab_rentals__calendar' )}}

),

not_available_dates as (

    select

        listing_id,
        calendar_date,
        is_available

    from calendar
    where is_available = false

),

available_dates as (

    select

        listing_id,
        calendar_date,
        is_available,
        dateadd('day', 1, last_value(calendar_date) over (partition by listing_id order by calendar_date)) as last_available_day_plus_one

    from calendar
    where is_available = true

)

, maximum_availability_setup as (
    select

        available_dates.listing_id,
        available_dates.calendar_date,
        available_dates.is_available,
        available_dates.last_available_day_plus_one,
        min(not_available_dates.calendar_date) as first_non_available_date_after_date

    from available_dates
    left join not_available_dates
        on available_dates.listing_id = not_available_dates.listing_id
        and available_dates.calendar_date < not_available_dates.calendar_date
    {{ dbt_utils.group_by(n=4) }}
)

select 

    calendar.listing_id,
    calendar.calendar_date,
    calendar.is_available,
    calendar.reservation_id,
    calendar.price_usd,
    calendar.revenue_usd,
    calendar.minimum_nights,
    calendar.maximum_nights,

    -- if rental is available, take calculate the difference between the current date and next non-available date (either because booked or end date)
    datediff('day', calendar.calendar_date, coalesce(first_non_available_date_after_date, last_available_day_plus_one)) as maximum_availablity_starting_calendar_date

from calendar
left join maximum_availability_setup
    on calendar.listing_id = maximum_availability_setup.listing_id
    and calendar.calendar_date = maximum_availability_setup.calendar_date
