{{ config(materialized='view') }}

-- Pass-through model: no logic allowed here per Phase 1 rules.
select * from {{ source('external_source', 'raw_bets') }}