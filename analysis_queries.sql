-- Normalised Data Model
-- 1.1 Customer Total
select customer_id
,sum(line.item_quantity * line.item_price) customer_total
from `orders_ds.order_header` hdr 
join `orders_ds.order_lines` line on (hdr.order_id = line.order_id and hdr.order_date = line.order_date)
group by 1

-- 1.2 Monthly Total
select date_trunc(hdr.order_date,MONTH) month
,sum(line.item_quantity * line.item_price) monthly_total
from `orders_ds.order_header` hdr 
join `orders_ds.order_lines` line on (hdr.order_id = line.order_id and hdr.order_date = line.order_date)
group by 1

-- 1.3 Item Total
-- Join is actually not required, but included to represent the model requires join
select line.item_name
,sum(line.item_quantity * line.item_price) monthly_total
from `orders_ds.order_header` hdr 
join `orders_ds.order_lines` line on (hdr.order_id = line.order_id and hdr.order_date = line.order_date)
group by 1

-- 2. De-Normalised Data Model
-- 2.1 Customer Total
# Customer Total
select customer_id,sum(item_quantity * item_price) customer_total
from `orders_ds.orders_and_lines` 
group by 1

-- 2.2 Monthly Total
select date_trunc(order_date,MONTH) order_month,sum(item_quantity * item_price) monthly_total
from `orders_ds.orders_and_lines` 
group by 1

-- 2.3 Item Total
select line.item_name ,sum(item_quantity * item_price) item_total
from `orders_ds.orders_and_lines` 
group by 1


-- 3. De-Normalised Data Model with BigQuery Arrays
-- 3.1 Customer Total
select customer_id,sum(line.item_quantity * line.item_price) customer_total
from `orders_ds.orders` ord, unnest(order_lines) line
group by 1

-- 3.2 Monthly Total
select date_trunc(order_date,MONTH) order_month,sum(line.item_quantity * line.item_price) monthly_total
from `orders_ds.orders` ord, unnest(order_lines) line
group by 1

-- 3.3 Item Total
select line.item_name ,sum(line.item_quantity * line.item_price) item_total
from `orders_ds.orders` ord, unnest(order_lines) line
group by 1
