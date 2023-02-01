{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte___destination_database_",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('department_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('ID'),
        'dept',
        'emp_id',
    ]) }} as _airbyte_department_hashid,
    tmp.*
from {{ ref('department_ab2') }} tmp
-- department
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

