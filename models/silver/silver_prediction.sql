{{ config(materialized='view') }}

with source as (
    select * from {{ ref('stg_sports_betting_predictive_analysis') }}
),

renamed as (
    select
        Match_ID as game_id,
        Date as game_date,
        Sport as sport,
        Home_Team as home_team,
        Away_Team as away_team,
        
        -- DECIMAL ODDS
        Home_Team_Odds as home_odds,
        Away_Team_Odds as away_odds,
        
        -- APPLY UPDATED MACRO
        {{ moneyline_to_prob('Home_Team_Odds') }} as implied_prob_home,
        {{ moneyline_to_prob('Away_Team_Odds') }} as implied_prob_away,
        
        -- UNDERDOG FLAG (In Decimal, anything > 2.00 is the underdog)
        case when Home_Team_Odds > Away_Team_Odds then true else false end as is_home_underdog,
        case when Away_Team_Odds > Home_Team_Odds then true else false end as is_away_underdog

    from source
    where Home_Team_Odds is not null 
      and Away_Team_Odds is not null
)

select * from renamed