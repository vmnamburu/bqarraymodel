create table `orders_ds.order_header` partition by order_date as 
select order_id,customer_id,order_date
from `orders_ds.orders`;

--order_date is included at line level to maintain partitioning  
create table `orders_ds.order_lines` partition by order_date as
select order_id,order_date,line.line_no,line.item_id,line.item_name,line.item_price,line.item_quantity
from `orders_ds.orders`, unnest(order_lines) line;

