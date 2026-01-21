# dbt Salesforce Formula Toolkit

[![Maintained](https://img.shields.io/badge/maintained%3F-yes-green.svg)](https://github.com/your-org/dbt_salesforce_formula_toolkit)
[![Future Support](https://img.shields.io/badge/future%20support-committed-blue.svg)](https://github.com/your-org/dbt_salesforce_formula_toolkit)

A comprehensive dbt package for easily creating views of Salesforce objects that include formula and rollup summary fields. This toolkit simplifies the process of exposing Salesforce data with computed fields in your data warehouse.


## Motivation

**The Problem:** Fivetran's Salesforce connector does not sync formula fields or rollup summary fields directly to your data warehouse. These computed fields are crucial for accurate reporting and analytics, but users must manually recreate the logic or find workarounds to access them.

**Why This Package?** While the official dbt Salesforce package exists, it currently has several unresolved issues that prevent reliable extraction of formula and rollup summary fields. This toolkit provides a focused, actively maintained solution specifically designed to handle these fields until those issues are resolved in the official package.

**The Solution:** This toolkit automatically generates models that replicate formula fields and rollup summary fields from your Fivetran-synced Salesforce data, making them readily available in your analytics environment without manual formula recreation or complex workarounds.

## Installation

### Step 1: Add the Package to Your dbt Project

Add the package to your `packages.yml` file in your dbt project root:

```yaml
packages:
  - git: "https://github.com/your-org/dbt_salesforce_formula_toolkit.git"
    revision: main
```

### Step 2: Install Dependencies

Run the following command to install the package:

```bash
dbt deps
```

This will download and install the `dbt_salesforce_formula_toolkit` package, making all macros available in your dbt project.

### Step 3: Verify Installation

To verify the package is installed correctly, check the `dbt_packages` folder after running `dbt deps`:

```bash
ls -la dbt_packages/
```

You should see a `dbt_salesforce_formula_toolkit` directory containing the package files and macros.

## Usage

### The `get_salesforce_object_model_sql` Macro

This macro generates SQL that creates a view containing only the formula fields and rollup summary fields from a Salesforce object. This is particularly useful when you want to expose computed fields from Salesforce without duplicating your entire Salesforce data model.

#### Macro Signature

```sql
get_salesforce_object_model_sql(
    salesforce_database,
    salesforce_schema,
    salesforce_table_name
)
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `salesforce_database` | string | The database name where your Salesforce data is synced (typically by Fivetran) |
| `salesforce_schema` | string | The schema name where your Salesforce tables are located |
| `salesforce_table_name` | string | The Salesforce object name (e.g., `account`, `opportunity`, `contact`) |

#### Example Usage

Create a new model file (e.g., `models/salesforce_account_formulas.sql`):

```sql
{{
    config(
        materialized='view',
    )
}}

{{ dbt_salesforce_formula_toolkit.get_salesforce_object_model_sql(
    'raw_data',
    'salesforce',
    'account'
    ) 
}}
```

Then run:

```bash
dbt run --models salesforce_account_formulas
```

This will create a view in the `analytics.marts` schema containing all formula and rollup summary fields from the `raw_data.salesforce.account` table.

## Examples

The `examples/` folder contains reference implementations to help you get started:

### [Salesforce Account Formula View](examples/salesforce_account_formula_view.sql)

This example demonstrates how to create a view for Salesforce Account objects with formula fields:

```sql
{{
    config(
        materialized='view',
    )
}}
{{ dbt_salesforce_formula_toolkit.get_salesforce_object_model_sql(
    '<source_database>', '<source_schema>', 
    'account'
    ) 
}}
```

**To use this example:**

1. Copy the contents to your `models/` directory
2. Replace the placeholder values:
   - `<source_database>`: Your Fivetran Salesforce database name
   - `<source_schema>`: Your Fivetran Salesforce schema name
3. Run `dbt run` to create the view

## How It Works

The `get_salesforce_object_model_sql` macro:

1. Queries Salesforce metadata to identify formula fields and rollup summary fields for the specified object
2. Generates SQL that selects only those computed fields
3. Wraps the SQL in a common table expression (CTE) for use in your model
4. Returns the complete SQL statement ready for view or table creation

## Common Use Cases

- **Reporting Layer**: Create analytics-ready views with computed Salesforce fields
- **Data Mart Creation**: Build fact tables that include Salesforce metrics
- **Formula Replication**: Mirror Salesforce formula calculations in your data warehouse
- **KPI Tracking**: Expose rollup summary fields for executive dashboards

## Troubleshooting

### Macro Not Found

If you receive a "macro not found" error:

1. Ensure `dbt deps` has been run successfully
2. Verify the package is listed in `packages.yml`
3. Check that your dbt version is compatible (requires dbt 1.0 or later)

### Permission Issues

Ensure your Salesforce sync user (Fivetran or similar) has permission to read the Salesforce object metadata.

### Empty Results

If your view is empty or missing fields:

1. Verify the `salesforce_table_name` exactly matches the Salesforce object name
2. Ensure the object exists in your Salesforce database and schema
3. Check that formula and rollup summary fields exist on the Salesforce object

## Supported Salesforce Objects

This toolkit works with any Salesforce object that contains formula fields or rollup summary fields, including:

- Account
- Opportunity
- Contact
- Lead
- Case
- Custom Objects

## Resources

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
- [Fivetran Salesforce Connector Documentation](https://fivetran.com/docs/databases/salesforce)
