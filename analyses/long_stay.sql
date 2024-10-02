with listings_by_day as (

    select * from {{ ref('listings_by_day' )}}

)

select

    listing_id,

    -- find the max duration listing is available if listing meets owner min and max night requirements
    coalesce(
        max(
            case
                when duration_available_if_stay_end_date >= minimum_nights
                    and duration_available_if_stay_end_date <= maximum_nights
                then duration_available_if_stay_end_date
            end
            ), 0) as longest_stay_available

from listings_by_day
{{ dbt_utils.group_by(n=1) }}
order by longest_stay_available desc
