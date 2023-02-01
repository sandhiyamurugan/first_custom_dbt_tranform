{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('company_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('ID'),
        'age',
        adapter.quote('NAME'),
        'salary',
        'updated_at',
    ]) }} as _airbyte_company_hashid,
    tmp.*
from {{ ref('company_ab2') }} tmp
-- company
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

