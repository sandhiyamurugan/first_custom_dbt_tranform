
      
    delete from "my_new_database".__destination_database_."company"
    where (_airbyte_ab_id) in (
        select (_airbyte_ab_id)
        from "company__dbt_tmp070118672692"
    );
    

    insert into "my_new_database".__destination_database_."company" ("ID", "age", "NAME", "salary", "updated_at", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_company_hashid")
    (
        select "ID", "age", "NAME", "salary", "updated_at", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_company_hashid"
        from "company__dbt_tmp070118672692"
    )
  