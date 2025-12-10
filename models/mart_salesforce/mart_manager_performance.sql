with 

owner_performance as (
    select * from {{ ref('mart_owner_performance') }}
),

users as (
    select * from {{ ref('stg_salesforce__user') }}
    where is_deleted = false
),

-- Get manager details
managers as (
    select
        user_id as manager_id,
        full_name as manager_name,
        email as manager_email,
        title as manager_title,
        department as manager_department
    from users
    where is_active = true
),

-- Roll up performance to manager level
manager_performance as (
    select
        -- Manager dimensions
        op.manager_id,
        m.manager_name,
        m.manager_email,
        m.manager_title,
        m.manager_department,
        
        -- Team size
        count(distinct op.owner_id) as team_size,
        
        -- Opportunity counts
        sum(op.total_opportunities) as total_opportunities,
        sum(op.closed_opportunities) as closed_opportunities,
        sum(op.won_opportunities) as won_opportunities,
        sum(op.lost_opportunities) as lost_opportunities,
        sum(op.open_opportunities) as open_opportunities,
        
        -- Opportunity amounts
        sum(op.total_amount) as total_amount,
        sum(op.closed_amount) as closed_amount,
        sum(op.won_amount) as won_amount,
        sum(op.lost_amount) as lost_amount,
        sum(op.open_amount) as open_amount,
        
        -- Pipeline by stage
        sum(op.prospecting_amount) as prospecting_amount,
        sum(op.qualification_amount) as qualification_amount,
        sum(op.needs_analysis_amount) as needs_analysis_amount,
        sum(op.value_proposition_amount) as value_proposition_amount,
        sum(op.id_decision_makers_amount) as id_decision_makers_amount,
        sum(op.perception_analysis_amount) as perception_analysis_amount,
        sum(op.proposal_amount) as proposal_amount,
        sum(op.negotiation_amount) as negotiation_amount,
        
        -- Weighted pipeline
        sum(op.weighted_pipeline) as weighted_pipeline,
        
        -- Performance metrics
        case 
            when sum(op.closed_opportunities) > 0 
            then sum(op.won_opportunities) / sum(op.closed_opportunities)::float 
            else 0 
        end as win_rate,
        
        case 
            when sum(op.closed_amount) > 0 
            then sum(op.won_amount) / sum(op.closed_amount)::float 
            else 0 
        end as win_rate_by_amount,
        
        -- Average deal size
        case 
            when sum(op.won_opportunities) > 0 
            then sum(op.won_amount) / sum(op.won_opportunities)::float 
            else 0 
        end as average_deal_size,
        
        -- Average per rep metrics
        case 
            when count(distinct op.owner_id) > 0 
            then sum(op.won_amount) / count(distinct op.owner_id)::float 
            else 0 
        end as average_won_amount_per_rep,
        
        case 
            when count(distinct op.owner_id) > 0 
            then sum(op.open_amount) / count(distinct op.owner_id)::float 
            else 0 
        end as average_pipeline_per_rep,
        
        -- Current date for reference
        current_date() as report_date
    from owner_performance op
    left join managers m on op.manager_id = m.manager_id
    where op.manager_id is not null
    group by 1, 2, 3, 4, 5
)

select * from manager_performance