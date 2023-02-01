{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "__destination_database_",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('table_two_ab3') }}
select
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_table_two_hashid
from {{ ref('table_two_ab3') }}
-- table_two from {{ source('__destination_database_', '_airbyte_raw_table_two') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

