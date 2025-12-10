with 

opportunities as (
    select * from {{ ref('stg_salesforce__opportunity') }}
    where is_deleted = false
),

-- Generate a date spine for the snapshot
date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('2020-01-01', 'YYYY-MM-DD')",
        end_date="current_date"
    ) }}
),

-- Format dates from the spine
dates as (
    select 
        date_day as snapshot_date
    from date_spine
),

-- Join opportunities to dates to create daily snapshots
opportunity_dates as (
    select
        d.snapshot_date,
        o.opportunity_id,
        o.opportunity_name,
        o.stage_name,
        o.amount,
        o.probability,
        o.close_date,
        o.owner_id,
        o.account_id,
        o.is_closed,
        o.is_won
    from dates d
    cross join opportunities o
    where d.snapshot_date >= date_trunc('day', o.created_at)
      and (
          -- Either the opportunity is still open at this snapshot date
          (not o.is_closed and d.snapshot_date <= current_date())
          -- Or the opportunity was closed before or on this snapshot date
          or (o.is_closed and d.snapshot_date <= date_trunc('day', o.updated_at))
      )
),

-- Calculate pipeline metrics for each day and opportunity
pipeline_daily as (
    select
        snapshot_date,
        opportunity_id,
        opportunity_name,
        stage_name,
        amount,
        probability,
        close_date,
        owner_id,
        account_id,
        is_closed,
        is_won,
        
        -- Weighted pipeline
        amount * probability / 100 as weighted_amount,
        
        -- Pipeline categorization
        case
            when is_won then 'Won'
            when is_closed and not is_won then 'Lost'
            when date_diff('day', snapshot_date, close_date) <= 30 then 'Closing This Month'
            when date_diff('day', snapshot_date, close_date) <= 90 then 'Closing Next Quarter'
            else 'Future Pipeline'
        end as pipeline_category
    from opportunity_dates
)

select * from pipeline_daily