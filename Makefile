.PHONY: build deps seed run test docs clean init-db

# Default target
all: build

# Initialize databases
init-db:
	@echo "Creating required databases..."
	@echo "You'll need to run the script in scripts/init_databases.sql using your database client"

# Install dependencies
deps:
	dbt deps

# Seed data
seed:
	dbt seed

# Run models
run:
	dbt run

# Test models
test:
	dbt test

# Generate documentation
docs:
	dbt docs generate

# Clean target directory
clean:
	dbt clean

# Full build process
build: deps seed run test docs
	@echo "Build completed successfully!"

# Run specific models
run-staging:
	dbt run --models stg_salesforce

run-intermediate:
	dbt run --models int_salesforce

run-marts:
	dbt run --models mart_salesforce

# Run specific tests
test-staging:
	dbt test --models stg_salesforce

test-intermediate:
	dbt test --models int_salesforce

test-marts:
	dbt test --models mart_salesforce