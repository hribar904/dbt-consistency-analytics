{% macro moneyline_to_prob(column_name) %}
    -- For Decimal Odds, probability is 1 divided by the odds
    case 
        when {{ column_name }} > 0 then (1 / {{ column_name }})
        else null 
    end
{% endmacro %}