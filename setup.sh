# Create a Dataset
bq mk -d orders_ds
# Create a Table with BQ Arrays (Data Model 3)
bq mk --table  --schema orders_ds.orders.json --time_partitioning_field order_date orders_ds.orders
# Step 1 : Create data for each month in 2019
sh insert_monthly_orders.sh
# Step 2 : Create Normalised tables (Data Model - 1) with data generated in Step 1
cat create_normalised_tables.sql  | bq query --use_legacy_sql=false
# Step 3 : Create De-Normalised table (Data Model - 2 ) with data generated in Step 1  
cat create_denormalised_tables.sql | bq query --use_legacy_sql=false
