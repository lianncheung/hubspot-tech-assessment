with

source as (

    select * from {{ source('lianns_fab_rentals', 'calendar') }}

),

renamed as (

    select 

        listing_id,
        date::date as calendar_date,

        -- convert to boolean
        case
            when available = 't' then true
            else false
        end as is_available,

        reservation_id,
        cast(price as float) as price_usd,

        -- when listing is booked, then price should equal revenue for that date
        case
            when reservation_id is not null then cast(price as float)
            else 0
        end as revenue_usd,

        minimum_nights,
        maximum_nights

    from source

)

select * from renamed
