
      
    delete from "my_new_database".__destination_database_."department"
    where (_airbyte_ab_id) in (
        select (_airbyte_ab_id)
        from "department__dbt_tmp070118629564"
    );
    

    insert into "my_new_database".__destination_database_."department" ("ID", "dept", "emp_id", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_department_hashid")
    (
        select "ID", "dept", "emp_id", "_airbyte_ab_id", "_airbyte_emitted_at", "_airbyte_normalized_at", "_airbyte_department_hashid"
        from "department__dbt_tmp070118629564"
    )
  