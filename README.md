# dbt Fivetran Salesforce Data Quality

A dbt project for transforming Salesforce data from Fivetran with integrated data quality tests using Great Expectations. cool

## Project Overview

This project provides a modular approach to transform raw Salesforce data from Fivetran into analytics-ready models with built-in data quality validation. It follows a multi-layered architecture:

```
models/
├── src_salesforce/       # Source definitions and tests
├── stg_salesforce/       # Staging models and tests
├── int_salesforce/       # Intermediate models and tests
└── mart_salesforce/      # Mart models and tests
```

## Key Features

- Modular Architecture: Follows dbt best practices with staging, intermediate, and mart layers
- Data Quality Testing: Integrates Great Expectations tests via metaplane/dbt_expectations
- Salesforce-Specific Logic: Handles Salesforce data nuances from Fivetran connector
- Performance Optimization: Materialization strategy optimized for Snowflake

## Dependencies

- dbt Core v1.11.0+
- dbt-snowflake v1.10.0+
- dbt-utils v1.0.0-b2
- metaplane/dbt_expectations v0.10.0

## Getting Started

### Prerequisites

- Python 3.8+
- Snowflake account with appropriate permissions
- Fivetran Salesforce connector configured

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/fivetran-jasonchletsos/dbt-fivetran-sfdc-dataquality.git
   cd dbt-fivetran-sfdc-dataquality
   ```

2. Install dbt and dependencies:
   ```bash
   pip install dbt-snowflake==1.10.4
   dbt deps
   ```

3. Configure your profile:
   - Copy `profiles.yml.template` to `~/.dbt/profiles.yml`
   - Update with your Snowflake credentials

4. Test your setup:
   ```bash
   dbt debug
   dbt compile
   ```

## Usage

### Running the Models

```bash
# Run all models
dbt run

# Run specific model layers
dbt run --select stg_salesforce
dbt run --select int_salesforce
dbt run --select mart_salesforce

# Run and test
dbt build
```

### Data Quality Tests

This project uses metaplane/dbt_expectations (a maintained fork of calogica/dbt_expectations) to implement Great Expectations tests:

```bash
# Run all tests
dbt test

# Run tests for specific models
dbt test --select stg_salesforce
```

## Data Quality Checks

The project implements multiple layers of data quality validation:

### Structural Tests
- Primary Key Validation: Uniqueness and not-null tests on all ID fields
- Referential Integrity: Foreign key relationship tests between models (e.g., opportunity → account)
- Schema Validation: Column type checking and consistency validation

### Data Tests
- Null Value Detection: Critical fields are tested for completeness
- Value Range Validation: Numeric fields are tested for sensible ranges
- Date Range Validation: Date fields are tested for appropriate time periods

### Business Logic Tests
- Pipeline Consistency: Tests to ensure pipeline metrics are consistent across models
- Aggregation Validation: Tests to verify rollups match detailed data
- Hierarchical Integrity: Tests to validate manager-rep relationship

### Implementation Details

Data quality tests are implemented at each layer of the model hierarchy:

1. Source Tests (`src_salesforce`):
   - Basic data integrity tests on raw Fivetran data
   - Freshness tests to ensure data is current

2. Staging Tests (`stg_salesforce`):
   - Column-level tests for data type validation
   - Not-null tests on required fields
   - Uniqueness tests on primary keys

3. Intermediate Tests (`int_salesforce`):
   - Relationship tests between joined models
   - Business logic validation tests
   - Calculated field validation

4. Mart Tests (`mart_salesforce`):
   - Aggregation consistency tests
   - End-to-end data validation
   - Business metric validation

### Great Expectations Integration

This project leverages Great Expectations through the `metaplane/dbt_expectations` package in the following ways:

1. **YAML-based Test Definitions**: Great Expectations tests are defined in the YAML files:
   - `models/stg_salesforce/stg_salesforce.yml`
   - `models/int_salesforce/int_salesforce.yml`
   - `models/mart_salesforce/mart_salesforce.yml`

2. **Test Types Used**:
   - `expect_column_values_to_not_be_null`: Ensures critical fields contain values
   - `expect_column_values_to_be_in_type_list`: Validates data types
   - `expect_column_values_to_be_between`: Checks numeric values fall within expected ranges
   - `expect_column_values_to_be_unique`: Verifies uniqueness constraints
   - `expect_column_pair_values_to_be_equal`: Ensures consistency between related fields

3. **Custom Expectations**: The project includes custom expectations for Salesforce-specific validation:
   - Opportunity stage progression validation
   - Sales cycle time reasonability checks
   - Account hierarchy validation

Great Expectations provides a robust framework for expressing complex data quality expectations and generating detailed test results that can be shared with stakeholders.

## Project Structure

- Staging Models: Clean, typed, and renamed columns from raw Salesforce data
- Intermediate Models: Business logic and relationship modeling
- Mart Models: Dimensional models for reporting and analysis
- Tests: Data quality validation using Great Expectations

## Snowflake Configuration

This project uses the following Snowflake objects:

- Source Database: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_SANDBOX`
- Staging Schema: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_STG`
- Mart/FCT Schema: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_FCT`

## Recent Fixes

- Updated from `calogica/dbt_expectations` to `metaplane/dbt_expectations` (v0.10.0)
- Fixed column references in staging models to match actual Fivetran Salesforce schema:
  - Changed `type` → `company_type_c` in Account model
  - Changed `product2_id` → `product_2_id as product2_id` in Opportunity Line Item model
  - Removed non-existent columns from various models
- Fixed syntax in `int_pipeline_daily_snapshot.sql` (single quotes for datepart parameter)
- Simplified Great Expectations tests for better compatibility

## Troubleshooting

If you encounter issues:

1. Schema Mismatches: Verify column names in Snowflake source tables
2. dbt Execution Hanging: Try using dbt Cloud instead of local execution
3. Package Compatibility: Ensure you're using metaplane/dbt_expectations v0.10.0

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

This project is licensed under the terms specified in [LICENSE](LICENSE).

## Additional Resources

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Changelog](CHANGELOG.md) - Version history and changes
