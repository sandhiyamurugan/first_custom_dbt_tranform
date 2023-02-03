

  create  table "my_new_database".public."poke_pokemon_moves_move__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_moves_move_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon_moves"
select
    _airbyte_moves_hashid,
    jsonb_extract_path_text("move", 'url') as url,
    jsonb_extract_path_text("move", 'name') as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon_moves" as table_alias
-- move at poke_pokemon/moves/move
where 1 = 1
and "move" is not null
),  __dbt__cte__poke_pokemon_moves_move_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_moves_move_ab1
select
    _airbyte_moves_hashid,
    cast(url as text) as url,
    cast("name" as text) as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_moves_move_ab1
-- move at poke_pokemon/moves/move
where 1 = 1
),  __dbt__cte__poke_pokemon_moves_move_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_moves_move_ab2
select
    md5(cast(coalesce(cast(_airbyte_moves_hashid as text), '') || '-' || coalesce(cast(url as text), '') || '-' || coalesce(cast("name" as text), '') as text)) as _airbyte_move_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_moves_move_ab2 tmp
-- move at poke_pokemon/moves/move
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_moves_move_ab3
select
    _airbyte_moves_hashid,
    url,
    "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_move_hashid
from __dbt__cte__poke_pokemon_moves_move_ab3
-- move at poke_pokemon/moves/move from "my_new_database".public."poke_pokemon_moves"
where 1 = 1
  );