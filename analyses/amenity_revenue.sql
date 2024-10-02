with listings_by_day as (

    select * from {{ ref('listings_by_day' )}}

)

select

    date_trunc('month', calendar_date) as revenue_month,

    -- with air conditioning
    sum(case
            when ARRAY_CONTAINS('Air conditioning'::variant, amenities) = true then revenue_usd
        else 0 end) as revenue_air_conditioning,
    sum(case
            when ARRAY_CONTAINS('Air conditioning'::variant, amenities) = true then revenue_usd
        else 0 end)
    / sum(revenue_usd) * 100 as revenue_air_conditioning_pct,

    -- no air conditioning
    sum(case
            when ARRAY_CONTAINS('Air conditioning'::variant, amenities) = false then revenue_usd
        else 0 end) as revenue_no_air_conditioning,
    sum(case
            when ARRAY_CONTAINS('Air conditioning'::variant, amenities) = false then revenue_usd
        else 0 end)
    / sum(revenue_usd) * 100  as revenue_no_air_conditioning_pct,

    sum(revenue_usd) as total_revenue

from listings_by_day
{{ dbt_utils.group_by(n=1) }}
order by revenue_month
