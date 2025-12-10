with 

enhanced_opportunities as (
    select * from {{ ref('int_opportunity_enhanced') }}
),

users as (
    select * from {{ ref('stg_salesforce__user') }}
    where is_deleted = false
),

-- Calculate performance metrics by owner
owner_performance as (
    select
        -- Owner dimensions
        o.owner_id,
        u.full_name as owner_name,
        u.email as owner_email,
        u.title as owner_title,
        u.department as owner_department,
        u.manager_id,
        
        -- Opportunity counts
        count(distinct o.opportunity_id) as total_opportunities,
        sum(case when o.is_closed then 1 else 0 end) as closed_opportunities,
        sum(o.is_won_count) as won_opportunities,
        sum(o.is_lost_count) as lost_opportunities,
        count(distinct case when not o.is_closed then o.opportunity_id else null end) as open_opportunities,
        
        -- Opportunity amounts
        sum(o.amount) as total_amount,
        sum(case when o.is_closed then o.amount else 0 end) as closed_amount,
        sum(o.won_amount) as won_amount,
        sum(o.lost_amount) as lost_amount,
        sum(o.open_amount) as open_amount,
        
        -- Pipeline by stage
        sum(case when not o.is_closed and o.stage_name = 'Prospecting' then o.amount else 0 end) as prospecting_amount,
        sum(case when not o.is_closed and o.stage_name = 'Qualification' then o.amount else 0 end) as qualification_amount,
        sum(case when not o.is_closed and o.stage_name = 'Needs Analysis' then o.amount else 0 end) as needs_analysis_amount,
        sum(case when not o.is_closed and o.stage_name = 'Value Proposition' then o.amount else 0 end) as value_proposition_amount,
        sum(case when not o.is_closed and o.stage_name = 'Id. Decision Makers' then o.amount else 0 end) as id_decision_makers_amount,
        sum(case when not o.is_closed and o.stage_name = 'Perception Analysis' then o.amount else 0 end) as perception_analysis_amount,
        sum(case when not o.is_closed and o.stage_name = 'Proposal/Price Quote' then o.amount else 0 end) as proposal_amount,
        sum(case when not o.is_closed and o.stage_name = 'Negotiation/Review' then o.amount else 0 end) as negotiation_amount,
        
        -- Weighted pipeline
        sum(case when not o.is_closed then o.amount * o.probability / 100 else 0 end) as weighted_pipeline,
        
        -- Performance metrics
        case 
            when sum(case when o.is_closed then 1 else 0 end) > 0 
            then sum(o.is_won_count) / sum(case when o.is_closed then 1 else 0 end)::float 
            else 0 
        end as win_rate,
        
        case 
            when sum(case when o.is_closed then o.amount else 0 end) > 0 
            then sum(o.won_amount) / sum(case when o.is_closed then o.amount else 0 end)::float 
            else 0 
        end as win_rate_by_amount,
        
        -- Average deal size
        case 
            when sum(o.is_won_count) > 0 
            then sum(o.won_amount) / sum(o.is_won_count)::float 
            else 0 
        end as average_deal_size,
        
        -- Current date for reference
        current_date() as report_date
    from enhanced_opportunities o
    left join users u on o.owner_id = u.user_id
    where u.is_active = true
    group by 1, 2, 3, 4, 5, 6
)

select * from owner_performance