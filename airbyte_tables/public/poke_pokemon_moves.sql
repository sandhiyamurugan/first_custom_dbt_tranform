

  create  table "my_new_database".public."poke_pokemon_moves__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_moves_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon"

select
    _airbyte_poke_pokemon_hashid,
    
        jsonb_extract_path(_airbyte_nested_data, 'move')
     as "move",
    jsonb_extract_path(_airbyte_nested_data, 'version_group_details') as version_group_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon" as table_alias
-- moves at poke_pokemon/moves
cross join jsonb_array_elements(
        case jsonb_typeof(moves)
        when 'array' then moves
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and moves is not null
),  __dbt__cte__poke_pokemon_moves_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_moves_ab1
select
    _airbyte_poke_pokemon_hashid,
    cast("move" as 
    jsonb
) as "move",
    version_group_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_moves_ab1
-- moves at poke_pokemon/moves
where 1 = 1
),  __dbt__cte__poke_pokemon_moves_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_moves_ab2
select
    md5(cast(coalesce(cast(_airbyte_poke_pokemon_hashid as text), '') || '-' || coalesce(cast("move" as text), '') || '-' || coalesce(cast(version_group_details as text), '') as text)) as _airbyte_moves_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_moves_ab2 tmp
-- moves at poke_pokemon/moves
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_moves_ab3
select
    _airbyte_poke_pokemon_hashid,
    "move",
    version_group_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_moves_hashid
from __dbt__cte__poke_pokemon_moves_ab3
-- moves at poke_pokemon/moves from "my_new_database".public."poke_pokemon"
where 1 = 1
  );