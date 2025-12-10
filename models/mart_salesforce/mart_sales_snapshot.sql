with 

opportunities as (
    select * from {{ ref('stg_salesforce__opportunity') }}
    where is_deleted = false
),

-- Current date metrics
sales_snapshot as (
    select
        -- Single row identifier
        1 as snapshot_id,
        
        -- Snapshot date
        current_date() as snapshot_date,
        
        -- Pipeline metrics
        sum(case when not is_closed then amount else 0 end) as open_pipeline,
        count(case when not is_closed then opportunity_id else null end) as open_opportunity_count,
        
        -- Closed won today
        sum(case 
            when is_won 
            and date_trunc('day', updated_at) = current_date() 
            then amount else 0 
        end) as closed_won_today,
        
        count(case 
            when is_won 
            and date_trunc('day', updated_at) = current_date() 
            then opportunity_id else null 
        end) as closed_won_today_count,
        
        -- Closed won this week
        sum(case 
            when is_won 
            and date_trunc('week', updated_at) = date_trunc('week', current_date()) 
            then amount else 0 
        end) as closed_won_this_week,
        
        count(case 
            when is_won 
            and date_trunc('week', updated_at) = date_trunc('week', current_date()) 
            then opportunity_id else null 
        end) as closed_won_this_week_count,
        
        -- Closed won this month
        sum(case 
            when is_won 
            and date_trunc('month', updated_at) = date_trunc('month', current_date()) 
            then amount else 0 
        end) as closed_won_this_month,
        
        count(case 
            when is_won 
            and date_trunc('month', updated_at) = date_trunc('month', current_date()) 
            then opportunity_id else null 
        end) as closed_won_this_month_count,
        
        -- Closed won this quarter
        sum(case 
            when is_won 
            and date_trunc('quarter', updated_at) = date_trunc('quarter', current_date()) 
            then amount else 0 
        end) as closed_won_this_quarter,
        
        count(case 
            when is_won 
            and date_trunc('quarter', updated_at) = date_trunc('quarter', current_date()) 
            then opportunity_id else null 
        end) as closed_won_this_quarter_count,
        
        -- Closed won this year
        sum(case 
            when is_won 
            and date_trunc('year', updated_at) = date_trunc('year', current_date()) 
            then amount else 0 
        end) as closed_won_this_year,
        
        count(case 
            when is_won 
            and date_trunc('year', updated_at) = date_trunc('year', current_date()) 
            then opportunity_id else null 
        end) as closed_won_this_year_count,
        
        -- Closing soon metrics (next 30 days)
        sum(case 
            when not is_closed 
            and close_date between current_date() and dateadd('day', 30, current_date())
            then amount else 0 
        end) as closing_next_30_days,
        
        count(case 
            when not is_closed 
            and close_date between current_date() and dateadd('day', 30, current_date())
            then opportunity_id else null 
        end) as closing_next_30_days_count,
        
        -- Average deal metrics
        case 
            when count(case when is_won then opportunity_id else null end) > 0 
            then sum(case when is_won then amount else 0 end) / count(case when is_won then opportunity_id else null end)::float 
            else 0 
        end as average_deal_size,
        
        -- Win rate metrics
        case 
            when count(case when is_closed then opportunity_id else null end) > 0 
            then count(case when is_won then opportunity_id else null end) / count(case when is_closed then opportunity_id else null end)::float 
            else 0 
        end as overall_win_rate
    from opportunities
)

select * from sales_snapshot