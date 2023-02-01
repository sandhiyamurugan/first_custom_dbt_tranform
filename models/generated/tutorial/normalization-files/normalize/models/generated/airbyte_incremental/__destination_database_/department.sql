{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "__destination_database_",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('department_ab3') }}
select
    {{ adapter.quote('ID') }},
    dept,
    emp_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_department_hashid
from {{ ref('department_ab3') }}
-- department from {{ source('__destination_database_', '_airbyte_raw_department') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

