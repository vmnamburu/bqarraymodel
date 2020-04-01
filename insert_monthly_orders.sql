insert into `orders_ds.orders`
(order_id,customer_id,order_date,order_lines)
with order_transactions as
(
    -- Populate an array with timestamps stepping through every 5 seconds
    select generate_timestamp_array(@StartTimeStamp,@EndTimeStamp,interval 5 second) transation_timestatmps
),
orders as
(
    select UNIX_MILLIS(transaction_timestamp) order_id   --Generate a unique order ID
    ,cast(rand()*100 as INT64) customer_id  -- Generate a customer_id between 1 and 100
    ,generate_array(1,1+cast(rand()*5 as int64)) order_items --Generate 1-5 Order lines for each order
    ,date(transaction_timestamp) order_date
    from order_transactions, unnest(transation_timestatmps) transaction_timestamp
),
items as
( 
    -- Inline table representing Items
    select [struct(1 as item_id,'Soccer Ball CR7' as item_name,20 as item_price)
       ,struct(2 as item_id,'Soccer Ball MS10' as item_name,18 as item_price) 
       ,struct(3 as item_id,'Soccer Ball NMR' as item_name,15 as item_price)
       ,struct(4 as item_id,'Ankle Sock Shin Guards' as item_name,25 as item_price)
       ,struct(5 as item_id,'Striker Shin Guards' as item_name,15 as item_price)
       ,struct(6 as item_id,'Goal Keeping Gloves' as item_name,40 as item_price)] item_list
)
, orders_w_line_items as
(
    --Assign order lines to each order
    select 
    order_id
    ,customer_id
    ,order_date
    ,1+line_no order_line_no
    ,item_list[safe_ordinal(1+cast(rand()*5 as int64))] order_item  --Lookup a random item for each line 
    ,1+cast(rand()*3 as int64) as order_quantity
    from orders, unnest(order_items) as ord_items with offset as line_no, items
)
select order_id
,customer_id
,order_date
,array_agg(struct(order_line_no as line_no
                ,order_item.item_id as item_id
                ,order_item.item_name as item_name
                ,order_item.item_price as item_price
                ,order_quantity as item_quantity) order by order_line_no) order_lines
from orders_w_line_items
group by 1,2,3
