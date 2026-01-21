{{
    config(
        materialized='view',
    )
}}
{{ dbt_salesforce_formula_toolkit.get_salesforce_object_model_sql(
    '<source_database>', '<source_schema>', 
    'account', 
    '<destination_database>', 
    '<destination_schema>'
    ) 
}}
