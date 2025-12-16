with source as (
    select * from {{ source('salesforce', 'OPPORTUNITY') }}
),

renamed as (
    select
        -- Primary key
        id as opportunity_id,
        
        -- Foreign keys
        account_id,
        owner_id,
        campaign_id,
        
        -- Opportunity details
        name as opportunity_name,
        type as opportunity_type, -- This is correct, TYPE exists in the OPPORTUNITY table
        stage_name,
        lead_source,
        
        -- Amounts
        cast(amount as numeric) as amount,
        cast(expected_revenue as numeric) as expected_revenue,
        probability,
        
        -- Dates
        cast(close_date as date) as close_date,
        cast(created_date as timestamp) as created_at,
        cast(last_modified_date as timestamp) as updated_at,
        cast(last_activity_date as date) as last_activity_date,
        
        -- Fiscal periods
        fiscal_year,
        fiscal_quarter,
        
        -- Status fields
        is_closed,
        is_won,
        
        -- Metadata
        is_deleted,
        _fivetran_synced as synced_at
    from source
)

select * from renamed

{% if is_incremental() %}
    where synced_at > (select max(synced_at) from {{ this }})
{% endif %}