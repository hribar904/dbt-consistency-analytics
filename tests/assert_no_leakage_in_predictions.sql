-- This test checks the information_schema to ensure no winner-related 
-- columns exist in the silver_prediction view.
select 
    column_name
from information_schema.columns
where table_name = 'silver_prediction'
  and (column_name ilike '%winner%' 
       or column_name ilike '%score%' 
       or column_name ilike '%actual%')