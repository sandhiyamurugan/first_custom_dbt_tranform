

  create  table "my_new_database".public."poke_pokemon_forms__dbt_tmp"
  as (
    
with __dbt__cte__poke_pokemon_forms_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "my_new_database".public."poke_pokemon"

select
    _airbyte_poke_pokemon_hashid,
    jsonb_extract_path_text(_airbyte_nested_data, 'url') as url,
    jsonb_extract_path_text(_airbyte_nested_data, 'name') as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "my_new_database".public."poke_pokemon" as table_alias
-- forms at poke_pokemon/forms
cross join jsonb_array_elements(
        case jsonb_typeof(forms)
        when 'array' then forms
        else '[]' end
    ) as _airbyte_nested_data
where 1 = 1
and forms is not null
),  __dbt__cte__poke_pokemon_forms_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__poke_pokemon_forms_ab1
select
    _airbyte_poke_pokemon_hashid,
    cast(url as text) as url,
    cast("name" as text) as "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__poke_pokemon_forms_ab1
-- forms at poke_pokemon/forms
where 1 = 1
),  __dbt__cte__poke_pokemon_forms_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__poke_pokemon_forms_ab2
select
    md5(cast(coalesce(cast(_airbyte_poke_pokemon_hashid as text), '') || '-' || coalesce(cast(url as text), '') || '-' || coalesce(cast("name" as text), '') as text)) as _airbyte_forms_hashid,
    tmp.*
from __dbt__cte__poke_pokemon_forms_ab2 tmp
-- forms at poke_pokemon/forms
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__poke_pokemon_forms_ab3
select
    _airbyte_poke_pokemon_hashid,
    url,
    "name",
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_forms_hashid
from __dbt__cte__poke_pokemon_forms_ab3
-- forms at poke_pokemon/forms from "my_new_database".public."poke_pokemon"
where 1 = 1
  );