create  table "my_new_database".__destination_database_."company__dbt_tmp"
  as (

with __dbt__cte__company_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".__destination_database_._airbyte_raw_company
select
    jsonb_extract_path_text(_airbyte_data, 'EMP_ID') as "EMP_ID",
    jsonb_extract_path_text(_airbyte_data, 'EMP_AGE') as EMP_AGE,
    jsonb_extract_path_text(_airbyte_data, 'EMP_NAME') as "EMP_NAME",
    jsonb_extract_path_text(_airbyte_data, 'SALARY') as salary,
    jsonb_extract_path_text(_airbyte_data, 'updated_at') as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".__destination_database_._airbyte_raw_company as table_alias
-- company
where 1 = 1
),  __dbt__cte__company_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__company_ab1
select
    cast("EMP_ID" as
    bigint
) as "EMP_ID",
    cast(EMP_AGE as
    bigint
) as EMP_AGE,
    cast("EMP_NAME" as text) as "EMP_NAME",
    cast(salary as
    float
) as salary,
    cast(nullif(updated_at, '') as
    timestamp with time zone
) as updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__company_ab1
-- company
where 1 = 1
),  __dbt__cte__company_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__company_ab2
select
    md5(cast(coalesce(cast("EMP_ID" as text), '') || '-' || coalesce(cast(EMP_AGE as text), '') || '-' || coalesce(cast("EMP_NAME" as text), '') || '-' || coalesce(cast(salary as text), '') || '-' || coalesce(cast(updated_at as text), '') as text)) as _airbyte_company_hashid,
    tmp.*
from __dbt__cte__company_ab2 tmp
-- company
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__company_ab3
select
    "EMP_ID",
    EMP_AGE,
    "EMP_NAME",
    salary,
    updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_company_hashid
from __dbt__cte__company_ab3
-- company from "my_new_database".__destination_database_._airbyte_raw_company
where 1 = 1
  );

