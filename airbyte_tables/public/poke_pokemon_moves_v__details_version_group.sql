

  create  table "my_new_database".public."poke_pokemon_moves_v__details_version_group__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_moves_v__details_version_group_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon_moves_version_group_details"
select
    _airbyte_version_group_details_hashid,
    jsonb_extract_path_text(version_group, 'url') as url,
    jsonb_extract_path_text(version_group, 'name') as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon_moves_version_group_details" as table_alias
-- version_group at poke_pokemon/moves/version_group_details/version_group
where 1 = 1
and version_group is not null
),  __dbt__cte__poke_pokemon_moves_v__details_version_group_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_moves_v__details_version_group_ab1
select
    _airbyte_version_group_details_hashid,
    cast(url as text) as url,
    cast("name" as text) as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_moves_v__details_version_group_ab1
-- version_group at poke_pokemon/moves/version_group_details/version_group
where 1 = 1
),  __dbt__cte__poke_pokemon_moves_v__details_version_group_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_moves_v__details_version_group_ab2
select
    md5(cast(coalesce(cast(_airbyte_version_group_details_hashid as text), '') || '-' || coalesce(cast(url as text), '') || '-' || coalesce(cast("name" as text), '') as text)) as _airbyte_version_group_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_moves_v__details_version_group_ab2 tmp
-- version_group at poke_pokemon/moves/version_group_details/version_group
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_moves_v__details_version_group_ab3
select
    _airbyte_version_group_details_hashid,
    url,
    "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_version_group_hashid
from __dbt__cte__poke_pokemon_moves_v__details_version_group_ab3
-- version_group at poke_pokemon/moves/version_group_details/version_group from "my_new_database".public."poke_pokemon_moves_version_group_details"
where 1 = 1
  );