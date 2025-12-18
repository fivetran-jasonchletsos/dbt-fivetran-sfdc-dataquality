-- Test to ensure opportunity stages are valid
-- Returns records with invalid stage names

{% set valid_stages = [
    '0 - Created',
    '0 - Introduction',
    '1 - Need',
    '1 - Need - Why Change?',
    '2 - Education',
    '3 - Why Change',
    '4 - Selected',
    '5 - Contract',
    'Prospecting',
    'Qualification',
    'Needs Analysis',
    'Value Proposition',
    'Id. Decision Makers',
    'Perception Analysis',
    'Proposal/Price Quote',
    'Negotiation/Review',
    'Closed Won',
    'Closed Lost'
] %}

with opportunities as (
    select * from {{ ref('stg_salesforce__opportunity') }}
)

select
    opportunity_id,
    opportunity_name,
    stage_name
from opportunities
where stage_name is not null
  and stage_name not in (
    {% for stage in valid_stages %}
        '{{ stage }}'{% if not loop.last %},{% endif %}
    {% endfor %}
  )