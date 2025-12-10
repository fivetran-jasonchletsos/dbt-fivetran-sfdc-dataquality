with 

opportunities as (
    select * from {{ ref('stg_salesforce__opportunity') }}
),

accounts as (
    select * from {{ ref('stg_salesforce__account') }}
),

users as (
    select * from {{ ref('stg_salesforce__user') }}
),

opportunity_enhanced as (
    select
        -- Opportunity fields
        o.opportunity_id,
        o.opportunity_name,
        o.opportunity_type,
        o.stage_name,
        o.amount,
        o.expected_revenue,
        o.probability,
        o.close_date,
        o.created_at as opportunity_created_at,
        o.is_closed,
        o.is_won,
        
        -- Account fields
        o.account_id,
        a.account_name,
        a.account_type,
        a.industry,
        a.annual_revenue as account_annual_revenue,
        a.number_of_employees,
        a.billing_country,
        
        -- Owner fields
        o.owner_id,
        u.full_name as owner_name,
        u.email as owner_email,
        u.title as owner_title,
        u.manager_id as owner_manager_id,
        u.department as owner_department,
        u.is_active as is_owner_active,
        
        -- Derived fields
        case 
            when o.is_won then o.amount
            else 0 
        end as won_amount,
        
        case 
            when o.is_closed and not o.is_won then o.amount
            else 0 
        end as lost_amount,
        
        case 
            when not o.is_closed then o.amount
            else 0 
        end as open_amount,
        
        case 
            when o.is_won then 1
            else 0 
        end as is_won_count,
        
        case 
            when o.is_closed and not o.is_won then 1
            else 0 
        end as is_lost_count,
        
        -- Metadata
        o.synced_at
    from opportunities o
    left join accounts a on o.account_id = a.account_id
    left join users u on o.owner_id = u.user_id
    where o.is_deleted = false
)

select * from opportunity_enhanced