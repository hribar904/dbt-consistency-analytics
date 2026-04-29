{{ config(materialized='table') }}

with bets as (
    select * from {{ ref('fct_bets') }}
),

roi_calc as (
    select
        *,
        -- Assume a standard stake of 100 units if not in data
        100 as stake,
        case 
            when is_win = true then (100 * home_odds) - 100
            else -100 
        end as net_profit
    from bets
)

select
    is_home_consistency_metric,
    count(*) as total_bets,
    sum(net_profit) as total_profit,
    (sum(net_profit) / sum(stake)) * 100 as roi_percentage
from roi_calc
group by 1