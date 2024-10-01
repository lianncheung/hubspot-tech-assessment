with

amenities_changelog as (

    select * from {{ ref('stg_lianns_fab_rentals__amenities_changelog' )}}

),

amenities_changelog_lag_lead as (

    select

        listing_id,
        change_at_timestamp,
        change_date,
        amenities,
        change_at_timestamp as start_timestamp,
        -- if no next change, then end date will be null
        dateadd('second', -1, lead(change_at_timestamp) over (partition by listing_id order by change_at_timestamp)) as end_timestamp

    from amenities_changelog
)

select * from amenities_changelog_lag_lead
