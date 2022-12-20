{% macro generate_information_schema(input_schemas) %}

{% set final_col_list = [] %}

{% if execute %}
    {% set columns = [] %}
    {% for s in input_schemas %}
       {% set results = run_query('SHOW TABLES IN ' + s) %}
       {% for t in results.columns[1].values() %}
            {% set col_result = run_query('SHOW COLUMNS IN '+ s + '.' + t) %}
            {% do columns.append((s, t, col_result.columns[0].values())) %}
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
    {% for s in input_schemas %}
       {% set results = run_query('SHOW VIEWS IN ' + s) %}
       {% for t in results.columns[1].values() %}
            {% set col_result = run_query('SHOW COLUMNS IN '+ s + '.' + t) %}
            {% do columns.append((s, t, col_result.columns[0].values())) %}
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
