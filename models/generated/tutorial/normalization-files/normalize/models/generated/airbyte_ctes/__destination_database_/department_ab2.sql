{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('department_ab1') }}
select
    cast({{ adapter.quote('ID') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('ID') }},
    cast(dept as {{ dbt_utils.type_string() }}) as dept,
    cast(emp_id as {{ dbt_utils.type_bigint() }}) as emp_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('department_ab1') }}
-- department
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

