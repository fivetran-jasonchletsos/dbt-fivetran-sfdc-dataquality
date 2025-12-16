# dbt-fivetran-sfdc-dataquality

A comprehensive dbt project for Salesforce data quality testing and transformation using Fivetran connectors.

## Overview

This project implements a multi-layered data quality framework for Salesforce data loaded via Fivetran. It includes:

- Source validation tests for raw Salesforce tables
- Staging models with comprehensive data quality tests
- Intermediate models with relationship validation
- Mart models with business rule validation
- Custom data quality tests for specific business requirements

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

## Data Flow Architecture

```
SALESFORCE (Source) → STAGING → INTERMEDIATE → MART
```

- **Source Layer**: Raw Salesforce data loaded by Fivetran
- **Staging Layer**: Cleaned and standardized data
- **Intermediate Layer**: Business logic and relationships
- **Mart Layer**: Analytics-ready models for reporting

## Quick Start

1. Clone the repository:
   ```
   git clone https://github.com/your-org/dbt-fivetran-sfdc-dataquality.git
   cd dbt-fivetran-sfdc-dataquality
   ```

2. Set up your environment (see [SETUP.md](SETUP.md) for details)

3. Initialize the databases:
   ```
   snowsql -f scripts/init_databases.sql
   ```

4. Install dependencies:
   ```
   make deps
   ```

5. Run the project:
   ```
   make build
   ```

## Scripts Reference

### `scripts/init_databases.sql`

**Purpose**: Creates the required databases for the project.

**Usage**:
```
snowsql -f scripts/init_databases.sql
```

**What it does**:
- Creates `JASON_CHLETSOS_SALESFORCE_STG` database for staging models
- Creates `JASON_CHLETSOS_SALESFORCE_FCT` database for fact/mart models
- Contains commented permission grants that can be customized

**Prerequisites**:
- Snowflake admin privileges or ability to create databases
- Assumes `JASON_CHLETSOS_SALESFORCE_SANDBOX` already exists as the source database

### `scripts/verify_setup.sh`

**Purpose**: Validates that your environment is correctly set up.

**Usage**:
```
./scripts/verify_setup.sh
```

**What it does**:
- Checks dbt installation and version
- Verifies profiles.yml configuration
- Validates project structure and required directories
- Confirms presence of essential files
- Runs `dbt debug` to test connectivity

**Prerequisites**:
- Bash shell
- dbt installed
- Execute permission (`chmod +x scripts/verify_setup.sh`)

## Data Quality Testing Strategy

This project implements a multi-layered testing approach:

### 1. Source Tests (`models/src_salesforce/salesforce_sources.yml`)

**Purpose**: Validate raw data integrity from Fivetran.

**Test Coverage**:
- Primary key validation (unique, not_null) for all source tables
- Tests run against raw Salesforce tables in `JASON_CHLETSOS_SALESFORCE_SANDBOX`

**Tables Tested**:
- `ACCOUNT`: ID uniqueness and not null
- `CONTACT`: ID uniqueness and not null
- `OPPORTUNITY`: ID uniqueness and not null
- `OPPORTUNITY_LINE_ITEM`: ID uniqueness and not null
- `USER`: ID uniqueness and not null

### 2. Staging Tests (`models/stg_salesforce/stg_salesforce.yml`)

**Purpose**: Ensure clean, standardized data with proper formatting.

**Test Coverage**:
- Column-level tests using dbt_expectations
- Value format validation
- Range checks
- Row count validation

**Models Tested**:
- `stg_salesforce__account`:
  - Row count validation
  - account_id uniqueness and not null
  - account_name not null

- `stg_salesforce__contact`:
  - Row count validation
  - contact_id uniqueness and not null
  - email format validation (regex)

- `stg_salesforce__opportunity`:
  - Row count validation
  - opportunity_id uniqueness and not null
  - amount range validation (0 to 1B)

- `stg_salesforce__opportunity_line_item`:
  - Row count validation
  - opportunity_line_item_id uniqueness and not null
  - opportunity_id not null

- `stg_salesforce__user`:
  - Row count validation
  - user_id uniqueness and not null

### 3. Intermediate Tests (`models/int_salesforce/int_salesforce.yml`)

**Purpose**: Validate business relationships and transformations.

**Test Coverage**:
- Referential integrity (relationships)
- Business logic validation
- Derived field validation

**Models Tested**:
- `int_opportunity_enhanced`:
  - opportunity_id uniqueness and not null
  - account_id not null and valid reference
  - owner_id valid reference

- `int_pipeline_daily_snapshot`:
  - snapshot_date not null
  - opportunity_id not null and valid reference
  - pipeline_category not null

### 4. Mart Tests (`models/mart_salesforce/mart_salesforce.yml`)

**Purpose**: Ensure analytical accuracy and business rule compliance.

**Test Coverage**:
- KPI validation
- Aggregation validation
- Business rule enforcement

**Models Tested**:
- `mart_owner_performance`:
  - owner_id uniqueness and not null
  - win_rate between 0 and 1
  - average_deal_size between 0 and 10M

- `mart_manager_performance`:
  - manager_id uniqueness and not null
  - team_size between 0 and 100

- `mart_sales_snapshot`:
  - snapshot_id uniqueness, not null, and value validation
  - snapshot_date not null

### 5. Custom SQL Tests (`tests/`)

**Purpose**: Implement complex business rules that can't be expressed in YAML.

**Tests Available**:
- `account_country_valid.sql`: Validates that account countries are valid ISO Alpha-2 codes
- `opportunity_stage_valid.sql`: Ensures opportunity stages match the allowed values list

## Development Workflow

### Using Make Commands

This project includes a Makefile with common operations:

```bash
# Install dependencies
make deps

# Run all models
make run

# Run tests
make test

# Generate documentation
make docs

# Full build process (deps, seed, run, test, docs)
make build

# Run specific model layers
make run-staging
make run-intermediate
make run-marts

# Test specific model layers
make test-staging
make test-intermediate
make test-marts
```

### Manual dbt Commands

```bash
# Run all models
dbt run

# Run specific models
dbt run --models stg_salesforce
dbt run --models int_salesforce
dbt run --models mart_salesforce

# Run tests
dbt test

# Run specific tests
dbt test --models stg_salesforce
dbt test --models int_salesforce
dbt test --models mart_salesforce
```

## Additional Documentation

- [SETUP.md](SETUP.md): Detailed setup instructions
- [CONTRIBUTING.md](CONTRIBUTING.md): Guidelines for contributors
- [CHANGELOG.md](CHANGELOG.md): Version history and changes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.