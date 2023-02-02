

  create  table "my_new_database".public."poke_pokemon__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public._airbyte_raw_poke_pokemon
select
    jsonb_extract_path_text(_airbyte_data, 'id') as "id",
    jsonb_extract_path_text(_airbyte_data, 'name') as "name",
    jsonb_extract_path(_airbyte_data, 'forms') as forms,
    jsonb_extract_path(_airbyte_data, 'moves') as moves,
    jsonb_extract_path_text(_airbyte_data, 'order') as "order",
    jsonb_extract_path(_airbyte_data, 'stats') as stats,
    jsonb_extract_path(_airbyte_data, 'types') as "types",
    jsonb_extract_path_text(_airbyte_data, 'height') as height,
    jsonb_extract_path_text(_airbyte_data, 'weight') as weight,
    
        jsonb_extract_path(table_alias._airbyte_data, 'species')
     as species,
    
        jsonb_extract_path(table_alias._airbyte_data, 'sprites')
     as sprites,
    jsonb_extract_path(_airbyte_data, 'abilities') as abilities,
    jsonb_extract_path(_airbyte_data, 'held_items') as held_items,
    jsonb_extract_path_text(_airbyte_data, 'is_default ') as "is_default ",
    jsonb_extract_path(_airbyte_data, 'game_indices') as game_indices,
    jsonb_extract_path_text(_airbyte_data, 'base_experience') as base_experience,
    jsonb_extract_path_text(_airbyte_data, 'location_area_encounters') as location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public._airbyte_raw_poke_pokemon as table_alias
-- poke_pokemon
where 1 = 1
),  __dbt__cte__poke_pokemon_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_ab1
select
    cast("id" as 
    bigint
) as "id",
    cast("name" as text) as "name",
    forms,
    moves,
    cast("order" as 
    bigint
) as "order",
    stats,
    "types",
    cast(height as 
    bigint
) as height,
    cast(weight as 
    bigint
) as weight,
    cast(species as 
    jsonb
) as species,
    cast(sprites as 
    jsonb
) as sprites,
    abilities,
    held_items,
    cast("is_default " as boolean) as "is_default ",
    game_indices,
    cast(base_experience as 
    bigint
) as base_experience,
    cast(location_area_encounters as text) as location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_ab1
-- poke_pokemon
where 1 = 1
),  __dbt__cte__poke_pokemon_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_ab2
select
    md5(cast(coalesce(cast("id" as text), '') || '-' || coalesce(cast("name" as text), '') || '-' || coalesce(cast(forms as text), '') || '-' || coalesce(cast(moves as text), '') || '-' || coalesce(cast("order" as text), '') || '-' || coalesce(cast(stats as text), '') || '-' || coalesce(cast("types" as text), '') || '-' || coalesce(cast(height as text), '') || '-' || coalesce(cast(weight as text), '') || '-' || coalesce(cast(species as text), '') || '-' || coalesce(cast(sprites as text), '') || '-' || coalesce(cast(abilities as text), '') || '-' || coalesce(cast(held_items as text), '') || '-' || coalesce(cast("is_default " as text), '') || '-' || coalesce(cast(game_indices as text), '') || '-' || coalesce(cast(base_experience as text), '') || '-' || coalesce(cast(location_area_encounters as text), '') as text)) as _airbyte_poke_pokemon_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_ab2 tmp
-- poke_pokemon
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_ab3
select
    "id",
    "name",
    forms,
    moves,
    "order",
    stats,
    "types",
    height,
    weight,
    species,
    sprites,
    abilities,
    held_items,
    "is_default ",
    game_indices,
    base_experience,
    location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_poke_pokemon_hashid
from __dbt__cte__poke_pokemon_ab3
-- poke_pokemon from "my_new_database".public._airbyte_raw_poke_pokemon
where 1 = 1
  );