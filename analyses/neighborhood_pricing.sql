with listings_by_day as (

    select * from {{ ref('listings_by_day' )}}

)

select

    neighborhood,
    count(distinct listing_id) as number_of_listings,

    -- prices
    avg(case when calendar_date = date('2021-07-12') then price_usd end) as average_price_start,
    avg(case when calendar_date = date('2022-07-11') then price_usd end) as average_price_end,
    avg(case when calendar_date = date('2022-07-11') then price_usd end)
    - avg(case when calendar_date = date('2021-07-12') then price_usd end) as difference

from listings_by_day
{{ dbt_utils.group_by(n=1) }}
order by neighborhood
