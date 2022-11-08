{{ config(
    materialized='table',
    format='delta'
    )
}}

{{ generate_information_schema(var('schemas-to-include')) }}