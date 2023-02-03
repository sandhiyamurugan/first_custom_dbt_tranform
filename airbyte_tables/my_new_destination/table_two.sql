

  create  table "my_new_database".my_new_destination."table_two__dbt_tmp"
  as (
    
with __dbt__cte__table_two_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".my_new_destination._airbyte_raw_table_two
select
    jsonb_extract_path_text(_airbyte_data, 'id') as "id",
    jsonb_extract_path_text(_airbyte_data, 'name') as "name",
    jsonb_extract_path_text(_airbyte_data, 'updated_at') as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".my_new_destination._airbyte_raw_table_two as table_alias
-- table_two
where 1 = 1
),  __dbt__cte__table_two_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__table_two_ab1
select
    cast("id" as 
    bigint
) as "id",
    cast("name" as text) as "name",
    cast(nullif(updated_at, '') as 
    timestamp
) as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__table_two_ab1
-- table_two
where 1 = 1
),  __dbt__cte__table_two_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__table_two_ab2
select
    md5(cast(coalesce(cast("id" as text), '') || '-' || coalesce(cast("name" as text), '') || '-' || coalesce(cast(updated_at as text), '') as text)) as _airbyte_table_two_hashid,
    tmp.*
from __dbt__cte__table_two_ab2 tmp
-- table_two
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__table_two_ab3
select
    "id",
    "name",
    updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_table_two_hashid
from __dbt__cte__table_two_ab3
-- table_two from "my_new_database".my_new_destination._airbyte_raw_table_two
where 1 = 1
  );