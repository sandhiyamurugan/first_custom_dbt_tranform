

  create  table "my_new_database".public."poke_pokemon_types_type__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_types_type_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon_types"
select
    _airbyte_types_hashid,
    jsonb_extract_path_text("type", 'url') as url,
    jsonb_extract_path_text("type", 'name') as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon_types" as table_alias
-- type at poke_pokemon/types/type
where 1 = 1
and "type" is not null
),  __dbt__cte__poke_pokemon_types_type_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_types_type_ab1
select
    _airbyte_types_hashid,
    cast(url as text) as url,
    cast("name" as text) as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_types_type_ab1
-- type at poke_pokemon/types/type
where 1 = 1
),  __dbt__cte__poke_pokemon_types_type_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_types_type_ab2
select
    md5(cast(coalesce(cast(_airbyte_types_hashid as text), '') || '-' || coalesce(cast(url as text), '') || '-' || coalesce(cast("name" as text), '') as text)) as _airbyte_type_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_types_type_ab2 tmp
-- type at poke_pokemon/types/type
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_types_type_ab3
select
    _airbyte_types_hashid,
    url,
    "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_type_hashid
from __dbt__cte__poke_pokemon_types_type_ab3
-- type at poke_pokemon/types/type from "my_new_database".public."poke_pokemon_types"
where 1 = 1
  );