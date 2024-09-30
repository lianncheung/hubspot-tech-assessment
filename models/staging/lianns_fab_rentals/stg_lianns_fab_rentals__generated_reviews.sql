with

source as (

    select * from {{ source('lianns_fab_rentals', 'generated_reviews') }}

),

renamed as (

    select

        id,
        listing_id,
        review_score,
        review_date::date as review_date

    from source

)

select * from renamed
