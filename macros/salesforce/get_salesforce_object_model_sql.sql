{%- macro get_salesforce_object_model_sql(salesforce_database,salesforce_schema,salesforce_table_name,destination_database, destination_schema) -%}
    -- this macro creates a view for the given salesforce object that includes formula and rollup summary fields only
    -- args:
    --   salesforce_database: the salesforce database name where the tables are located synced by fivetran
    --   salesforce_schema: the salesforce schema name where the tables are located synced by fivetran under salesforce_database
    --   salesforce_table_name: the salesforce table name (object) to get the model sql for
    --   destination_database: the database where the view will be created
    --   destination_schema: the schema where the view will be created
    {% if execute %}
        {{ log('salesforce formula toolkit: in execute block of create formula sql', info=True) }}

        {% set model_sql = dbt_salesforce_formula_toolkit.get_model_sql_with_formula_and_rollup_summary_fields(salesforce_database, salesforce_schema, salesforce_table_name) %}
        {% set temp_table_name = salesforce_table_name ~ '_temp_formula_model' %}

        {% set final_sql %}
            WITH {{ temp_table_name }} AS (
                {{ model_sql }}
            )
            SELECT * FROM {{ temp_table_name }}
        {% endset %}

        {{ log(final_sql, info=True) }}
        {{ return(final_sql) }}
    {% endif %}
{%- endmacro -%}