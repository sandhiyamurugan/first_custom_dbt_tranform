{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('company_ab1') }}
select
    cast({{ adapter.quote('ID') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('ID') }},
    cast(age as {{ dbt_utils.type_bigint() }}) as age,
    cast({{ adapter.quote('NAME') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('NAME') }},
    cast(salary as {{ dbt_utils.type_float() }}) as salary,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('company_ab1') }}
-- company
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

