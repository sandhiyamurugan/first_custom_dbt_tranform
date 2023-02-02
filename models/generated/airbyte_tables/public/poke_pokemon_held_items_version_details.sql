

  create  table "my_new_database".public."poke_pokemon_held_items_version_details__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_held_items_version_details_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon_held_items"

select
    _airbyte_held_items_hashid,
    jsonb_extract_path_text(_airbyte_nested_data, 'rarity') as rarity,
    
        jsonb_extract_path(_airbyte_nested_data, 'version')
     as "version",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon_held_items" as table_alias
-- version_details at poke_pokemon/held_items/version_details
cross join jsonb_array_elements(
        case jsonb_typeof(version_details)
        when 'array' then version_details
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and version_details is not null
),  __dbt__cte__poke_pokemon_held_items_version_details_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_held_items_version_details_ab1
select
    _airbyte_held_items_hashid,
    cast(rarity as 
    bigint
) as rarity,
    cast("version" as 
    jsonb
) as "version",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_held_items_version_details_ab1
-- version_details at poke_pokemon/held_items/version_details
where 1 = 1
),  __dbt__cte__poke_pokemon_held_items_version_details_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_held_items_version_details_ab2
select
    md5(cast(coalesce(cast(_airbyte_held_items_hashid as text), '') || '-' || coalesce(cast(rarity as text), '') || '-' || coalesce(cast("version" as text), '') as text)) as _airbyte_version_details_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_held_items_version_details_ab2 tmp
-- version_details at poke_pokemon/held_items/version_details
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_held_items_version_details_ab3
select
    _airbyte_held_items_hashid,
    rarity,
    "version",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_version_details_hashid
from __dbt__cte__poke_pokemon_held_items_version_details_ab3
-- version_details at poke_pokemon/held_items/version_details from "my_new_database".public."poke_pokemon_held_items"
where 1 = 1
  );