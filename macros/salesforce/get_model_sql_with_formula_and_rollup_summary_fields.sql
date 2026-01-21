{%- macro sfdc_get_model_sql_with_formula_and_rollup_summary_fields(salesforce_database,salesforce_schema,salesforce_table_name) -%}
    -- this macro returns the model sql with formula and rollup summary fields included
    -- it looks up the model from the fivetran_formula_model table
    -- if no model is found, it raises a compiler error
    -- args:
    --   salesforce_database: the salesforce database name where the tables are located synced by fivetran
    --   salesforce_schema: the salesforce schema name where the tables are located synced by fivetran
    --   salesforce_table_name: the salesforce table name (object) to get the model for
    {% set result = none %}
    {% if execute %}
        {{ log('salesforce formula toolkit: in execute block of sfdc_get_model_sql_with_formula_and_rollup_summary_fields',info=True) }}
        {%- set model_results = run_query("select MODEL from  " ~ salesforce_database ~ "." ~ salesforce_schema ~ ".fivetran_formula_model where lower(object) = lower('" ~ salesforce_table_name ~ "') ") -%}
        {% set result = model_results.columns[0].values()[0] %}
    {% endif %}
    {% if result is none %}
        {{ exceptions.raise_compiler_error("No model found for object: " ~ salesforce_table_name) }}
    {% else %}
        {{ result }}
    {% endif %}

{%- endmacro -%}