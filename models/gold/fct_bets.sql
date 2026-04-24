{{ config(materialized='table') }}

with prediction as (
    select * from {{ ref('silver_prediction') }}
),

actuals as (
    select * from {{ ref('silver_actuals') }}
),

final as (
    select
        p.*,
        a.winner_label,
        
        -- Did the Home Team win?
        case when a.winner_label = p.home_team then true else false end as home_won,
        
        -- ROI Calculation (Assuming a $100 bet on the home team)
        -- If they won, payout is (100 * decimal_odds) - 100 profit. 
        -- If they lost, payout is -100.
        case 
            when a.winner_label = p.home_team then (100 * p.home_odds) - 100
            else -100 
        end as home_bet_roi_dollars

    from prediction p
    left join actuals a on p.game_id = a.game_id
)

select * from final