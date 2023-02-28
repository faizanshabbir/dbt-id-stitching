{% macro generate_information_schema(input_schemas, input_tables) %}

{% set final_col_list = [] %}

{% set parsed_schemas = input_schemas | replace("(", "") | replace(")", "") | replace("'", "") %}
{% set parsed_tables = input_tables | replace("(", "") | replace(")", "") | replace("'", "") %}

{% if execute %}
    {% set columns = [] %}
    {% for s in parsed_schemas.split(",") %}
       {% set results = run_query('SHOW TABLES IN ' + s) %}
       {% for t in results.columns[1].values() %}
            {% if t in parsed_tables.split(",") %}
                {% set col_result = run_query('SHOW COLUMNS IN '+ s + '.' + t) %}
                {% do columns.append((s, t, col_result.columns[0].values())) %}
            {% endif %}
        {% endfor %}
    {% endfor %}
    {% for res in columns %}
        {% for x in res[2] %}
            {% do final_col_list.append((x, res[0], res[1])) %}
        {% endfor %}
    {% endfor %}
{% endif %}

{% if execute %}
    {% set columns = [] %}
    {% for s in parsed_schemas.split(",") %}
       {% set results = run_query('SHOW VIEWS IN ' + s) %}
       {% for t in results.columns[1].values() %}
            {% if t in parsed_tables.split(",") %}
                {% set col_result = run_query('SHOW COLUMNS IN '+ s + '.' + t) %}
                {% do columns.append((s, t, col_result.columns[0].values())) %}
            {% endif %}
        {% endfor %}
    {% endfor %}
    {% for res in columns %}
        {% for x in res[2] %}
            {% do final_col_list.append((x, res[0], res[1])) %}
        {% endfor %}
    {% endfor %}
{% endif %}

SELECT
{% for item in final_col_list%}
'{{item[0]}}' AS column_name,
'{{item[1]}}' AS table_schema,
'{{item[2]}}' AS table_name
{% if not loop.last %}
UNION ALL
SELECT
{% endif %}
{% endfor %}

{% endmacro %}
