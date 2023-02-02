

  create  table "my_new_database".public."poke_pokemon_moves_version_group_details__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_moves_version_group_details_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon_moves"

select
    _airbyte_moves_hashid,
    
        jsonb_extract_path(_airbyte_nested_data, 'version_group')
     as version_group,
    jsonb_extract_path_text(_airbyte_nested_data, 'level_learned_at') as level_learned_at,
    
        jsonb_extract_path(_airbyte_nested_data, 'move_learn_method')
     as move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon_moves" as table_alias
-- version_group_details at poke_pokemon/moves/version_group_details
cross join jsonb_array_elements(
        case jsonb_typeof(version_group_details)
        when 'array' then version_group_details
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and version_group_details is not null
),  __dbt__cte__poke_pokemon_moves_version_group_details_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_moves_version_group_details_ab1
select
    _airbyte_moves_hashid,
    cast(version_group as 
    jsonb
) as version_group,
    cast(level_learned_at as 
    bigint
) as level_learned_at,
    cast(move_learn_method as 
    jsonb
) as move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_moves_version_group_details_ab1
-- version_group_details at poke_pokemon/moves/version_group_details
where 1 = 1
),  __dbt__cte__poke_pokemon_moves_version_group_details_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_moves_version_group_details_ab2
select
    md5(cast(coalesce(cast(_airbyte_moves_hashid as text), '') || '-' || coalesce(cast(version_group as text), '') || '-' || coalesce(cast(level_learned_at as text), '') || '-' || coalesce(cast(move_learn_method as text), '') as text)) as _airbyte_version_group_details_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_moves_version_group_details_ab2 tmp
-- version_group_details at poke_pokemon/moves/version_group_details
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_moves_version_group_details_ab3
select
    _airbyte_moves_hashid,
    version_group,
    level_learned_at,
    move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_version_group_details_hashid
from __dbt__cte__poke_pokemon_moves_version_group_details_ab3
-- version_group_details at poke_pokemon/moves/version_group_details from "my_new_database".public."poke_pokemon_moves"
where 1 = 1
  );