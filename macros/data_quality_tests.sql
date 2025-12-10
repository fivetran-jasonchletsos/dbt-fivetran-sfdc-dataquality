{% macro test_column_values_not_null_rate(model, column_name, threshold=0.95) %}

{# This test validates that a column has a null rate below the threshold #}
{# For example, we might want to ensure that at least 95% of records have a value for a particular field #}

{% set column_name = column_name | trim %}

with validation as (
    select
        sum(case when {{ column_name }} is null then 1 else 0 end) * 1.0 / count(*) as null_rate
    from {{ model }}
),

validation_errors as (
    select null_rate
    from validation
    where null_rate > (1 - {{ threshold }})
)

select *
from validation_errors

{% endmacro %}