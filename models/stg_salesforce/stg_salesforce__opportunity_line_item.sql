with source as (
    select * from {{ source('salesforce', 'OPPORTUNITY_LINE_ITEM') }}
),

renamed as (
    select
        -- Primary key
        id as opportunity_line_item_id,
        
        -- Foreign keys
        opportunity_id,
        product2_id,
        pricebook_entry_id,
        
        -- Line item details
        name as line_item_name,
        description,
        product_code,
        
        -- Quantities and amounts
        cast(quantity as numeric) as quantity,
        cast(unit_price as numeric) as unit_price,
        cast(list_price as numeric) as list_price,
        cast(total_price as numeric) as total_price,
        cast(discount as numeric) as discount,
        
        -- Dates
        cast(service_date as date) as service_date,
        cast(system_modstamp as timestamp) as system_modstamp,
        cast(created_date as timestamp) as created_at,
        cast(last_modified_date as timestamp) as updated_at,
        
        -- Metadata
        is_deleted,
        _fivetran_synced as synced_at
    from source
)

select * from renamed

{% if is_incremental() %}
    where synced_at > (select max(synced_at) from {{ this }})
{% endif %}