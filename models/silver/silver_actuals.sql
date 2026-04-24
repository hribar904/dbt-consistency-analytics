{{ config(materialized='view') }}

with source as (
    select * from {{ ref('stg_sports_betting_predictive_analysis') }}
),

renamed as (
    select
        Match_ID as game_id,
        Actual_Winner as winner_label
    from source
    -- Add this to stay in sync with silver_prediction
    where Home_Team_Odds is not null 
      and Away_Team_Odds is not null
)

select * from renamed