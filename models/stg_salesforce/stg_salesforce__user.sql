with source as (
    select * from {{ source('salesforce', 'USER') }}
),

renamed as (
    select
        -- Primary key
        id as user_id,
        
        -- Foreign keys
        manager_id,
        
        -- User details
        username,
        name as full_name,
        first_name,
        last_name,
        email,
        phone,
        title,
        department,
        
        -- Roles and permissions
        user_role_id,
        user_type,
        
        -- Status
        is_active,
        
        -- Timestamps
        cast(created_date as timestamp) as created_at,
        cast(last_modified_date as timestamp) as updated_at,
        cast(last_login_date as timestamp) as last_login_at,
        
        -- Metadata
        _fivetran_deleted as is_deleted,
        _fivetran_synced as synced_at
    from source
)

select * from renamed

{% if is_incremental() %}
    where synced_at > (select max(synced_at) from {{ this }})
{% endif %}