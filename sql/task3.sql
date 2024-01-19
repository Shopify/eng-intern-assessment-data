-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales_amount
from Categories c
join Products p on c.category_id = p.category_id
join Order_Items oi on p.product_id = oi.product_id
join Orders o on oi.order_id = o.order_id
-- aggregate the sum of each category
group by c.category_id, c.category_name
-- choose the top 3 highest sums
order by total_sales_amount desc
limit 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select u.user_id, u.username
from Users u
where not exists (
    select p.product_id
    from Products p
    -- find products whose category_name is 'Toys & Games'
    where p.category_id = (select category_id from Categories where category_name = 'Toys & Games')
    and not exists (
        select oi.product_id
        from Order_Items oi
        join Orders o on oi.order_id = o.order_id
        where oi.product_id = p.product_id and o.user_id = u.user_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

with RankedProducts as (
    -- each product assigned a rank based on price
  select p.product_id, p.product_name, p.category_id, p.price,
    rank() over (partition by p.category_id order by p.price desc) as price_rank
  from Products p
)
select
  rp.product_id,
  rp.product_name,
  rp.category_id,
  rp.price
from RankedProducts rp
-- highest price
where rp.price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- has order dates with prev_order_date
with OrderedDates as (
  select 
    u.user_id,
    u.username,
    o.order_date,
    -- checks the difference in order dates (how far are 2 order dates apart)
    lag(o.order_date) over (partition by u.user_id order by o.order_date) as prev_order_date
  from Users u
  join Orders o on u.user_id = o.user_id
),
-- table contains all orders that are separated by one day (consecutive): line 84
ConsecutiveOrders as (
  select 
    user_id,
    username,
    order_date,
    prev_order_date,
    case 
      when datediff(order_date, prev_order_date) = 1 then 1
      else 0
    end as is_consecutive
  from OrderedDates
),
-- table that groups users by the number of total consecutive orders in the last 3 days. 
--   for each row, it checks the previous 2 rows to confirm if an order was placed earlier by the same user: line 95
ConsecutiveGroups as (
  select 
    user_id,
    username,
    sum(is_consecutive) over (partition by user_id order by order_date rows between 2 preceding and CURRENT row) as consecutive_days
  from ConsecutiveOrders
)
-- selects the users with consecutive orders in the last 3 days (including current row): previous 2 rows + current row = 3 rows
select distinct
  user_id,
  username
from ConsecutiveGroups
where consecutive_days >= 2;
