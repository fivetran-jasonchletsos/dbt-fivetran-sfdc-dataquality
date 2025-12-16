with source as (
    select * from {{ source('salesforce', 'CONTACT') }}
),

renamed as (
    select
        -- Primary key
        id as contact_id,
        
        -- Foreign keys
        account_id,
        owner_id,
        reports_to_id,
        
        -- Names
        first_name,
        last_name,
        salutation,
        name as full_name,
        
        -- Contact details
        email,
        phone,
        mobile_phone,
        title,
        department,
        
        -- Address fields
        mailing_street,
        mailing_city,
        mailing_state,
        mailing_postal_code,
        mailing_country,
        
        -- Timestamps
        cast(created_date as timestamp) as created_at,
        cast(last_modified_date as timestamp) as updated_at,
        
        -- Flags
        is_deleted,
        has_opted_out_of_email,
        do_not_call,
        
        -- Metadata
        _fivetran_synced as synced_at
    from source
)

select * from renamed

{% if is_incremental() %}
    where synced_at > (select max(synced_at) from {{ this }})
{% endif %}