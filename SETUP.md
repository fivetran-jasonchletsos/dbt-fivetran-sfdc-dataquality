# Setup Guide for dbt-fivetran-sfdc-dataquality

This guide provides step-by-step instructions for setting up your development environment and configuring the project.

## Prerequisites

- Python 3.8 or higher
- Git
- Snowflake account with appropriate permissions
- Fivetran account with Salesforce connector configured

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/dbt-fivetran-sfdc-dataquality.git
cd dbt-fivetran-sfdc-dataquality
```

### 2. Create a Python Virtual Environment

```bash
# Create virtual environment
python -m venv .venv

# Activate virtual environment
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate
```

### 3. Install dbt and Dependencies

```bash
pip install dbt-snowflake==1.5.0
pip install dbt-utils
```

### 4. Configure dbt Profile

Create or update your `~/.dbt/profiles.yml` file with the following configuration:

```yaml
dbt_fivetran_sfdc_dataquality:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: [your-snowflake-account]
      user: [your-snowflake-username]
      password: [your-snowflake-password]
      role: [your-snowflake-role]
      database: JASON_CHLETSOS_SALESFORCE_FCT
      warehouse: [your-warehouse]
      schema: dbt_[your-name]
      threads: 4
      client_session_keep_alive: True
      query_tag: dbt_fivetran_sfdc_dataquality
```

Alternatively, you can copy the provided `profiles.yml.template` file and modify it with your credentials.

### 5. Initialize Databases

If you have Snowflake admin privileges, run the database initialization script:

```bash
snowsql -f scripts/init_databases.sql
```

If you don't have admin privileges, ask your Snowflake administrator to create the following databases:
- JASON_CHLETSOS_SALESFORCE_STG
- JASON_CHLETSOS_SALESFORCE_FCT

### 6. Install dbt Packages

```bash
dbt deps
```

### 7. Test Your Setup

```bash
# Validate your connection and project configuration
dbt debug

# Compile the models to check for syntax errors
dbt compile
```

## Snowflake Configuration

### Required Permissions

To run this project, you need the following Snowflake permissions:

1. Read access to `JASON_CHLETSOS_SALESFORCE_SANDBOX` database
2. Write access to `JASON_CHLETSOS_SALESFORCE_STG` database
3. Write access to `JASON_CHLETSOS_SALESFORCE_FCT` database
4. Usage rights on the warehouse

### Recommended Warehouse Configuration

For optimal performance:
- Medium-sized warehouse for development
- Large-sized warehouse for production runs
- X-Large warehouse for initial loads or full refreshes

## CI/CD Configuration

### GitHub Actions

To use the included GitHub Actions workflows:

1. Add the following secrets to your GitHub repository:
   - `SNOWFLAKE_ACCOUNT`
   - `SNOWFLAKE_USER`
   - `SNOWFLAKE_PASSWORD`
   - `SNOWFLAKE_ROLE`
   - `SNOWFLAKE_WAREHOUSE`

2. Configure branch protection rules for the main branch:
   - Require pull request reviews
   - Require status checks to pass

## Troubleshooting

### Common Issues

1. **Connection Errors**:
   - Verify your Snowflake account, username, and password
   - Check network connectivity and VPN settings

2. **Permission Errors**:
   - Ensure your Snowflake role has appropriate access to all databases
   - Verify warehouse access permissions

3. **Package Dependency Issues**:
   - Run `dbt clean` followed by `dbt deps`
   - Check for version conflicts in packages.yml

4. **Model Compilation Errors**:
   - Look for syntax errors in SQL files
   - Verify that referenced sources and models exist

For additional help, consult the [dbt documentation](https://docs.getdbt.com/) or create an issue in the repository.