{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "__destination_database_",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('company_ab3') }}
select
    {{ adapter.quote('ID') }},
    age,
    {{ adapter.quote('NAME') }},
    salary,
    updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_company_hashid
from {{ ref('company_ab3') }}
-- company from {{ source('__destination_database_', '_airbyte_raw_company') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

