with

generated_reviews as (

    select * from {{ ref('stg_lianns_fab_rentals__generated_reviews' )}}

),

reviews_rolling_aggregates as (

    select
        
        id,
        listing_id,
        review_date,
        review_score,

        -- rolling aggregates as of each review date
        avg(review_score) over (partition by listing_id order by review_date rows between unbounded preceding and current row) as rolling_avg_review_score,
        count(id) over (partition by listing_id order by review_date rows between unbounded preceding and current row) as rolling_total_reviews,
        min(review_date) over (partition by listing_id order by review_date rows between unbounded preceding and current row) as first_review_date,
        max(review_date) over (partition by listing_id order by review_date rows between unbounded preceding and current row) as last_review_date,

        -- dates for which the rolling average was valid
        review_date as review_aggregates_start_date,
        -- if no next review date, then end date will be null
        dateadd('day', -1, lead(review_date) over (partition by listing_id order by review_date)) as review_aggregates_end_date

    from generated_reviews

)

select * from reviews_rolling_aggregates
