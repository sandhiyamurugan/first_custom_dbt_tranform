{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('table_two_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        adapter.quote('name'),
        'updated_at',
    ]) }} as _airbyte_table_two_hashid,
    tmp.*
from {{ ref('table_two_ab2') }} tmp
-- table_two
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

