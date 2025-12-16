# dbt-fivetran-sfdc-dataquality

A dbt project for transforming and validating Salesforce data loaded via Fivetran.

## Project Structure

```
dbt-fivetran-sfdc-dataquality/
├── models/
│   ├── src_salesforce/       # Source definitions and tests
│   ├── stg_salesforce/       # Staging models and tests
│   ├── int_salesforce/       # Intermediate models and tests
│   └── mart_salesforce/      # Mart models and tests
├── tests/                    # Custom SQL tests
├── scripts/                  # Utility scripts
├── macros/                   # Custom macros
└── seeds/                    # Seed files (if any)
```

## Overview

This project transforms raw Salesforce data from Fivetran into analytics-ready models. It follows the dbt best practices with a multi-layered approach:

1. **Source Layer (`src_salesforce`)**: Defines the raw Fivetran Salesforce tables
2. **Staging Layer (`stg_salesforce`)**: Cleans and standardizes individual tables
3. **Intermediate Layer (`int_salesforce`)**: Combines and transforms data for business logic
4. **Mart Layer (`mart_salesforce`)**: Creates final dimensional models for reporting

## Data Quality Testing Strategy

This project implements a comprehensive data quality testing framework using both native dbt tests and Great Expectations (via the dbt_expectations package).

### Test Coverage

- **Source Tests**: Validate raw data integrity from Fivetran
- **Staging Tests**: Ensure data type consistency, null handling, and basic formatting
- **Intermediate Tests**: Validate business logic and relationships
- **Mart Tests**: Confirm KPIs and metrics are calculated correctly
- **Custom SQL Tests**: Address complex business rules

### Great Expectations Integration

The project uses the [dbt_expectations](https://github.com/calogica/dbt_expectations) package to implement Great Expectations-style tests within dbt. This provides advanced validation capabilities beyond standard dbt tests.

#### Key Test Types

1. **Column Value Validation**
   - Range validation (min/max values)
   - Regex pattern matching
   - Set validation (allowed values)

2. **Table-Level Validation**
   - Row count expectations
   - Relationship validation
   - Cardinality checks

3. **Data Type Validation**
   - Date format validation
   - Numeric precision checks
   - String length validation

#### Running Great Expectations Tests

To run all tests including Great Expectations validations:

```bash
dbt test
```

To run tests for specific models:

```bash
dbt test --select stg_salesforce__account
```

### Staging Model Tests

All staging models include these validation tests:

- **stg_salesforce__account**
  - Row count validation (0-5M rows)
  - account_name length validation (1-255 chars)
  - billing_country regex validation (ISO country codes)

- **stg_salesforce__contact**
  - Row count validation (0-5M rows)
  - email regex validation (standard email format)

- **stg_salesforce__opportunity**
  - Row count validation (0-5M rows)
  - amount range validation (0-10M)
  - probability range validation (0-100)
  - stage_name set validation (predefined stages)

- **stg_salesforce__opportunity_line_item**
  - Row count validation (0-5M rows)
  - Relationship validation with opportunities

- **stg_salesforce__user**
  - Row count validation (0-5M rows)
  - email regex validation (standard email format)
  - is_active set validation (true/false)

### Mart Model Tests

Mart models include KPI validation tests:

- **mart_owner_performance**
  - Row count validation (0-10K rows)
  - win_rate range validation (0-1)
  - average_deal_size range validation
  - weighted_pipeline range validation

- **mart_manager_performance**
  - Row count validation (0-10K rows)
  - team_size range validation (0-100)
  - team_win_rate range validation (0-1)

- **mart_sales_snapshot**
  - Exact row count validation (1 row per snapshot)
  - snapshot_id set validation
  - snapshot_date type validation
  - total_pipeline_amount range validation

## Getting Started

1. Clone this repository
2. Install dbt dependencies:
   ```
   dbt deps
   ```
3. Run the models:
   ```
   dbt run
   ```
4. Run the tests:
   ```
   dbt test
   ```

## Database Configuration

This project uses three Snowflake databases:
- `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_SANDBOX` (source)
- `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_STG` (staging views)
- `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_FCT` (intermediate views and mart tables)

## Dependencies

This project depends on the following dbt packages:
- [dbt_utils](https://github.com/dbt-labs/dbt-utils) (version 1.0.0-b2)
- [dbt_expectations](https://github.com/calogica/dbt_expectations) (version 0.8.0)
