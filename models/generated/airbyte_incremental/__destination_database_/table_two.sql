
      
    delete from "my_new_database".__destination_database_."table_two"
    where (_airbyte_ab_id) in (
        select (_airbyte_ab_id)
        from "table_two__dbt_tmp070118695609"
    );
    

    insert into "my_new_database".__destination_database_."table_two" ("id", "name", "updated_at", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_table_two_hashid")
    (
        select "id", "name", "updated_at", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_table_two_hashid"
        from "table_two__dbt_tmp070118695609"
    )
  