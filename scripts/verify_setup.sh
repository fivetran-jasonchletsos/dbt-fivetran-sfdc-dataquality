#!/bin/bash
# Verification script for dbt-fivetran-sfdc-dataquality setup

echo "=== dbt-fivetran-sfdc-dataquality Setup Verification ==="
echo

# Check dbt installation
echo "Checking dbt installation..."
if command -v dbt &> /dev/null; then
    dbt_version=$(dbt --version | head -n 1)
    echo "✅ dbt is installed: $dbt_version"
else
    echo "❌ dbt is not installed. Please install dbt-snowflake."
    exit 1
fi

# Check for profiles.yml
echo "Checking dbt profiles..."
if [ -f ~/.dbt/profiles.yml ]; then
    echo "✅ profiles.yml exists"
    
    # Check if our profile exists
    if grep -q "dbt_fivetran_sfdc_dataquality:" ~/.dbt/profiles.yml; then
        echo "✅ dbt_fivetran_sfdc_dataquality profile exists"
    else
        echo "❌ dbt_fivetran_sfdc_dataquality profile not found in profiles.yml"
    fi
else
    echo "❌ profiles.yml not found. Please create ~/.dbt/profiles.yml"
fi

# Check for required packages
echo "Checking dbt packages..."
if [ -d "dbt_packages" ]; then
    echo "✅ dbt packages directory exists"
else
    echo "⚠️ dbt_packages directory not found. Run 'dbt deps' to install packages."
fi

# Validate project structure
echo "Validating project structure..."
required_dirs=("models" "models/src_salesforce" "models/stg_salesforce" "models/int_salesforce" "models/mart_salesforce" "macros" "tests")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir directory exists"
    else
        echo "❌ $dir directory is missing"
    fi
done

# Check for required files
echo "Checking for required files..."
required_files=("dbt_project.yml" "packages.yml" "models/src_salesforce/salesforce_sources.yml")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file is missing"
    fi
done

# Try to run dbt debug
echo "Running dbt debug..."
dbt debug --config-dir

echo
echo "Verification complete. Fix any issues before proceeding."
echo "Run 'make build' to build the project."