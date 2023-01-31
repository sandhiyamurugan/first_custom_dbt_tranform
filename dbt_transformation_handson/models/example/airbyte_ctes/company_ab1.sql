{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('__destination_database_', '_airbyte_raw_company') }}
select
    {{ json_extract_scalar('_airbyte_data', ['ID'], ['ID']) }} as {{ adapter.quote('ID') }},
    {{ json_extract_scalar('_airbyte_data', ['AGE'], ['AGE']) }} as age,
    {{ json_extract_scalar('_airbyte_data', ['NAME'], ['NAME']) }} as {{ adapter.quote('NAME') }},
    {{ json_extract_scalar('_airbyte_data', ['SALARY'], ['SALARY']) }} as salary,
    {{ json_extract_scalar('_airbyte_data', ['updated_at'], ['updated_at']) }} as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('__destination_database_', '_airbyte_raw_company') }} as table_alias
-- company
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}
