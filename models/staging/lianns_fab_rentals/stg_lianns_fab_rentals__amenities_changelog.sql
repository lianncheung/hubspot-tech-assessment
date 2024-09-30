with

source as (

    select * from {{ source('lianns_fab_rentals', 'amenities_changelog') }}

),

renamed as (

    select

        listing_id,
        change_at::timestamp_ntz as change_at_timestamp,
        change_at::date as change_date,
        parse_json(amenities) as amenities

    from source

)

select * from renamed
