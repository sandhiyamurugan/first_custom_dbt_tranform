

  create  table
    __destination_schema_.`table_two__dbt_tmp`
  as (
    
with __dbt__cte__table_two_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: __destination_schema_._airbyte_raw_table_two
select
    json_value(_airbyte_data, 
    '$."id"' RETURNING CHAR) as id,
    json_value(_airbyte_data, 
    '$."name"' RETURNING CHAR) as `name`,
    json_value(_airbyte_data, 
    '$."updated_at"' RETURNING CHAR) as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    
    CURRENT_TIMESTAMP
 as _airbyte_normalized_at
from __destination_schema_._airbyte_raw_table_two as table_alias
-- table_two
where 1 = 1
),  __dbt__cte__table_two_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__table_two_ab1
select
    cast(id as 
    signed
) as id,
    cast(`name` as char(1024)) as `name`,
        case when updated_at regexp '\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.*' THEN STR_TO_DATE(SUBSTR(updated_at, 1, 19), '%Y-%m-%dT%H:%i:%S')
        else cast(if(updated_at = '', NULL, updated_at) as datetime)
        end as updated_at
        ,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    
    CURRENT_TIMESTAMP
 as _airbyte_normalized_at
from __dbt__cte__table_two_ab1
-- table_two
where 1 = 1
),  __dbt__cte__table_two_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__table_two_ab2
select
    md5(cast(concat(coalesce(cast(id as char), ''), '-', coalesce(cast(`name` as char), ''), '-', coalesce(cast(updated_at as char), '')) as char)) as _airbyte_table_two_hashid,
    tmp.*
from __dbt__cte__table_two_ab2 tmp
-- table_two
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__table_two_ab3
select
    id,
    `name`,
    updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    
    CURRENT_TIMESTAMP
 as _airbyte_normalized_at,
    _airbyte_table_two_hashid
from __dbt__cte__table_two_ab3
-- table_two from __destination_schema_._airbyte_raw_table_two
where 1 = 1
  )
