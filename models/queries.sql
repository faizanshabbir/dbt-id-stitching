WITH columns AS (
    SELECT
        column_name AS cn,
        table_schema || '.' || table_name AS tn
    FROM {{ref('dbt_information_schema')}}
    WHERE
        LOWER(column_name) IN {{ var('id-columns') }}
        {% if var('schemas-to-include') != '()' %}
        AND LOWER(table_schema) IN {{ var('schemas-to-include') }}
        {% endif %}
        {% if var('schemas-to-exclude') != '()' %}
        AND NOT LOWER(table_schema) IN {{ var('schemas-to-exclude') }}
        {% endif %}
        {% if var('tables-to-include') != '()' %}
        AND LOWER(table_name) IN {{ var('tables-to-include') }}
        {% endif %}
        {% if var('tables-to-exclude') != '()' %}
        AND NOT LOWER(table_name) IN {{ var('tables-to-exclude') }}
        {% endif %}
        AND NOT LOWER(table_name) LIKE 'snapshot_%'
        AND NOT LOWER(table_name) LIKE 'sync_data_%'
        AND NOT LOWER(table_name) LIKE 'failed_records_%'
)

SELECT 'SELECT DISTINCT ' || a.cn || '::STRING AS edge_a, \'' || a.cn || '\' AS edge_a_label, ' || b.cn || '::STRING AS edge_b, \'' || b.cn || '\' AS edge_b_label FROM ' || a.tn || ' WHERE COALESCE(' || a.cn || '::STRING, \'\') != \'\' AND COALESCE(' || b.cn || '::STRING, \'\') != \'\'' AS sql_to_run
FROM columns AS a
INNER JOIN columns AS b
    ON a.tn = b.tn
        AND a.cn > b.cn
