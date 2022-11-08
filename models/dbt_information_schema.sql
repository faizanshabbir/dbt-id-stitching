{{ config(
    materialized='table',
    format='delta'
    )
}}

--replace hardcode with var('schemas-to-include')
{{ generate_information_schema(['ios_delta']) }}