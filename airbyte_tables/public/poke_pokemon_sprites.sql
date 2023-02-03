

  create  table "my_new_database".public."poke_pokemon_sprites__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_sprites_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon"
select
    _airbyte_poke_pokemon_hashid,
    jsonb_extract_path_text(sprites, 'back_shiny') as back_shiny,
    jsonb_extract_path_text(sprites, 'back_female') as back_female,
    jsonb_extract_path_text(sprites, 'front_shiny') as front_shiny,
    jsonb_extract_path_text(sprites, 'back_default') as back_default,
    jsonb_extract_path_text(sprites, 'front_female') as front_female,
    jsonb_extract_path_text(sprites, 'front_default') as front_default,
    jsonb_extract_path_text(sprites, 'back_shiny_female') as back_shiny_female,
    jsonb_extract_path_text(sprites, 'front_shiny_female') as front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon" as table_alias
-- sprites at poke_pokemon/sprites
where 1 = 1
and sprites is not null
),  __dbt__cte__poke_pokemon_sprites_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_sprites_ab1
select
    _airbyte_poke_pokemon_hashid,
    cast(back_shiny as text) as back_shiny,
    cast(back_female as text) as back_female,
    cast(front_shiny as text) as front_shiny,
    cast(back_default as text) as back_default,
    cast(front_female as text) as front_female,
    cast(front_default as text) as front_default,
    cast(back_shiny_female as text) as back_shiny_female,
    cast(front_shiny_female as text) as front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_sprites_ab1
-- sprites at poke_pokemon/sprites
where 1 = 1
),  __dbt__cte__poke_pokemon_sprites_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_sprites_ab2
select
    md5(cast(coalesce(cast(_airbyte_poke_pokemon_hashid as text), '') || '-' || coalesce(cast(back_shiny as text), '') || '-' || coalesce(cast(back_female as text), '') || '-' || coalesce(cast(front_shiny as text), '') || '-' || coalesce(cast(back_default as text), '') || '-' || coalesce(cast(front_female as text), '') || '-' || coalesce(cast(front_default as text), '') || '-' || coalesce(cast(back_shiny_female as text), '') || '-' || coalesce(cast(front_shiny_female as text), '') as text)) as _airbyte_sprites_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_sprites_ab2 tmp
-- sprites at poke_pokemon/sprites
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_sprites_ab3
select
    _airbyte_poke_pokemon_hashid,
    back_shiny,
    back_female,
    front_shiny,
    back_default,
    front_female,
    front_default,
    back_shiny_female,
    front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_sprites_hashid
from __dbt__cte__poke_pokemon_sprites_ab3
-- sprites at poke_pokemon/sprites from "my_new_database".public."poke_pokemon"
where 1 = 1
  );