with source as (
    select * from {{ source('salesforce', 'ACCOUNT') }}
),

renamed as (
    select
        -- Primary key
        id as account_id,
        
        -- Dimensions
        name as account_name,
        company_type_c as account_type, -- Changed from 'type' to 'company_type_c'
        industry,
        -- Removed rating as it doesn't exist in the source
        website,
        phone,
        
        -- Address fields
        billing_street,
        billing_city,
        billing_state,
        billing_postal_code,
        billing_country,
        shipping_street,
        shipping_city,
        shipping_state,
        shipping_postal_code,
        shipping_country,
        
        -- Hierarchy fields
        parent_id,
        
        -- Numeric fields
        cast(annual_revenue as numeric) as annual_revenue,
        cast(number_of_employees as integer) as number_of_employees,
        
        -- Timestamps
        cast(created_date as timestamp) as created_at,
        cast(last_modified_date as timestamp) as updated_at,
        
        -- Metadata
        owner_id,
        is_deleted,
        _fivetran_synced as synced_at
    from source
)

select * from renamed

{% if is_incremental() %}
    where synced_at > (select max(synced_at) from {{ this }})
{% endif %}