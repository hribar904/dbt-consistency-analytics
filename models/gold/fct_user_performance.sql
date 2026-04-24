{{ config(materialized='table') }}

with bets as (
    select * from {{ ref('fct_bets') }}
),

user_simulation as (
    select
        -- Simulate 100 different users based on the Game ID
        abs(hash(game_id)) % 100 as user_id,
        *
    from bets
),

user_agg as (
    select
        user_id,
        count(*) as total_bets,
        sum(case when home_won then 1 else 0 end) as total_wins,
        round(avg(home_bet_roi_dollars), 2) as avg_roi_per_bet,
        sum(home_bet_roi_dollars) as cumulative_profit_loss
    from user_simulation
    group by 1
)

select * from user_agg