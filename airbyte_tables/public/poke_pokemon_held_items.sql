

  create  table "my_new_database".public."poke_pokemon_held_items__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_held_items_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon"

select
    _airbyte_poke_pokemon_hashid,
    
        jsonb_extract_path(_airbyte_nested_data, 'item')
     as item,
    jsonb_extract_path(_airbyte_nested_data, 'version_details') as version_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon" as table_alias
-- held_items at poke_pokemon/held_items
cross join jsonb_array_elements(
        case jsonb_typeof(held_items)
        when 'array' then held_items
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and held_items is not null
),  __dbt__cte__poke_pokemon_held_items_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_held_items_ab1
select
    _airbyte_poke_pokemon_hashid,
    cast(item as 
    jsonb
) as item,
    version_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_held_items_ab1
-- held_items at poke_pokemon/held_items
where 1 = 1
),  __dbt__cte__poke_pokemon_held_items_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_held_items_ab2
select
    md5(cast(coalesce(cast(_airbyte_poke_pokemon_hashid as text), '') || '-' || coalesce(cast(item as text), '') || '-' || coalesce(cast(version_details as text), '') as text)) as _airbyte_held_items_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_held_items_ab2 tmp
-- held_items at poke_pokemon/held_items
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_held_items_ab3
select
    _airbyte_poke_pokemon_hashid,
    item,
    version_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_held_items_hashid
from __dbt__cte__poke_pokemon_held_items_ab3
-- held_items at poke_pokemon/held_items from "my_new_database".public."poke_pokemon"
where 1 = 1
  );