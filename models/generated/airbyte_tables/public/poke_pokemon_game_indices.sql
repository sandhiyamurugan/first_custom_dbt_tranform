

  create  table "my_new_database".public."poke_pokemon_game_indices__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_game_indices_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon"

select
    _airbyte_poke_pokemon_hashid,
    
        jsonb_extract_path(_airbyte_nested_data, 'version')
     as "version",
    jsonb_extract_path_text(_airbyte_nested_data, 'game_index') as game_index,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon" as table_alias
-- game_indices at poke_pokemon/game_indices
cross join jsonb_array_elements(
        case jsonb_typeof(game_indices)
        when 'array' then game_indices
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and game_indices is not null
),  __dbt__cte__poke_pokemon_game_indices_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_game_indices_ab1
select
    _airbyte_poke_pokemon_hashid,
    cast("version" as 
    jsonb
) as "version",
    cast(game_index as 
    bigint
) as game_index,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_game_indices_ab1
-- game_indices at poke_pokemon/game_indices
where 1 = 1
),  __dbt__cte__poke_pokemon_game_indices_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_game_indices_ab2
select
    md5(cast(coalesce(cast(_airbyte_poke_pokemon_hashid as text), '') || '-' || coalesce(cast("version" as text), '') || '-' || coalesce(cast(game_index as text), '') as text)) as _airbyte_game_indices_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_game_indices_ab2 tmp
-- game_indices at poke_pokemon/game_indices
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_game_indices_ab3
select
    _airbyte_poke_pokemon_hashid,
    "version",
    game_index,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_game_indices_hashid
from __dbt__cte__poke_pokemon_game_indices_ab3
-- game_indices at poke_pokemon/game_indices from "my_new_database".public."poke_pokemon"
where 1 = 1
  );