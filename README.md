# dbt Fivetran Salesforce Data Quality

A dbt project for transforming Salesforce data from Fivetran with integrated data quality tests using Great Expectations.

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

- **Modular Architecture**: Follows dbt best practices with staging, intermediate, and mart layers
- **Data Quality Testing**: Integrates Great Expectations tests via metaplane/dbt_expectations
- **Salesforce-Specific Logic**: Handles Salesforce data nuances from Fivetran connector
- **Performance Optimization**: Materialization strategy optimized for Snowflake

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

## Project Structure

- **Staging Models**: Clean, typed, and renamed columns from raw Salesforce data
- **Intermediate Models**: Business logic and relationship modeling
- **Mart Models**: Dimensional models for reporting and analysis
- **Tests**: Data quality validation using Great Expectations

## Snowflake Configuration

This project uses the following Snowflake objects:

- **Source Database**: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_SANDBOX`
- **Staging Schema**: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_STG`
- **Mart/FCT Schema**: `JASON_CHLETSOS.JASON_CHLETSOS_SALESFORCE_FCT`

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

1. **Schema Mismatches**: Verify column names in Snowflake source tables
2. **dbt Execution Hanging**: Try using dbt Cloud instead of local execution
3. **Package Compatibility**: Ensure you're using metaplane/dbt_expectations v0.10.0

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

This project is licensed under the terms specified in [LICENSE](LICENSE).

## Additional Resources

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Changelog](CHANGELOG.md) - Version history and changes