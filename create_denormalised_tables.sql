create table `orders_ds.orders_and_lines` partition by order_date as
select order_id,customer_id,order_date,lines.line_no,lines.item_id,lines.item_name,lines.item_price,lines.item_quantity
from `orders_ds.orders`, unnest(order_lines) lines
