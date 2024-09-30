with

generated_reviews as (

    select * from {{ ref('stg_lianns_fab_rentals__generated_reviews' )}}

),

reviews_aggregated as (

    select
        
        listing_id,
        count(distinct id) as total_reviews,
        min(review_date) as first_review_date,
        max(review_date) as last_review_date

    from generated_reviews

    {{ dbt_utils.group_by(n=1) }}

),

reviews_rolling_avg as (

    select
        
        id,
        listing_id,
        review_date,
        review_score,

        -- rolling average of scores as of each review date
        avg(review_score) over (partition by listing_id order by review_date rows between unbounded preceding and current row) as rolling_avg_review_score,

        -- dates for which the rolling average was valid
        review_date as review_rolling_avg_start_date,
        -- if no next review date, then end date will be null
        dateadd('day', -1, lead(review_date) over (partition by listing_id order by review_date)) as review_rolling_avg_end_date

    from generated_reviews

),

reviews_joined as (

    select

        reviews_rolling_avg.id,
        reviews_rolling_avg.listing_id,
        reviews_rolling_avg.review_date,
        reviews_rolling_avg.review_score,
        reviews_rolling_avg.rolling_avg_review_score,
        reviews_rolling_avg.review_rolling_avg_start_date,
        reviews_rolling_avg.review_rolling_avg_end_date,
        reviews_aggregated.total_reviews,
        reviews_aggregated.first_review_date,
        reviews_aggregated.last_review_date
    
    from reviews_rolling_avg

    left join reviews_aggregated
        on reviews_aggregated.listing_id = reviews_rolling_avg.listing_id
)

select * from reviews_joined
