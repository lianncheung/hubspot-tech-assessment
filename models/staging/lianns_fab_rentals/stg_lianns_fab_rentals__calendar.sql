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
        minimum_nights,
        maximum_nights

    from source

)

select * from renamed
