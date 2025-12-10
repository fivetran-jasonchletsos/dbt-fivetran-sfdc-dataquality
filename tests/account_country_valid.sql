-- Test to ensure account countries are valid ISO Alpha-2 codes
-- Returns records with invalid country codes

{% set valid_country_codes = [
    'US', 'CA', 'MX', 'GB', 'DE', 'FR', 'ES', 'IT', 'NL', 'BE', 'CH', 
    'AT', 'SE', 'NO', 'DK', 'FI', 'PT', 'IE', 'AU', 'NZ', 'JP', 'CN', 
    'IN', 'BR', 'AR', 'CL', 'CO', 'PE', 'ZA', 'SG', 'KR', 'AE', 'SA'
] %}

with accounts as (
    select * from {{ ref('stg_salesforce__account') }}
)

select
    account_id,
    account_name,
    billing_country
from accounts
where billing_country is not null
  and upper(billing_country) not in (
    {% for code in valid_country_codes %}
        '{{ code }}'{% if not loop.last %},{% endif %}
    {% endfor %}
  )
  and length(billing_country) = 2  -- Only check 2-letter codes