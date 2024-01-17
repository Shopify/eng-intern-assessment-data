-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales
from Categories c
join Products p on c.category_id = p.category_id
join Order_Items oi on p.product_id = oi.product_id
group by c.category_id
order by total_sales desc
limit 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select u.user_id, u.username
from Users u
where not exists (
    select 1
    from Products p
    join Categories c on p.category_id = c.category_id
    where c.category_name = 'Toys & Games'
      and not exists (
          select 1
          from Orders o
          join Order_Items oi on o.order_id = oi.order_id
          where u.user_id = o.user_id and oi.product_id = p.product_id
      )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

with ranked_products as (
    select p.product_id, p.product_name, p.category_id, p.price,
           rank() over (partition by p.category_id order by p.price desc) as rank
    from Products p
)
select product_id, product_name, category_id, price
from ranked_products
where rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

with ordered_dates as (
    select user_id, order_date,
        lag(order_date, 1) over (partition by user_id order by order_date) as prev_order_date,
        lead(order_date, 1) over (partition by user_id order by order_date) as next_order_date
    from Orders
)
select distinct u.user_id, u.username
from Users u
join ordered_dates o on u.user_id = o.user_id
where ABS(JULIANDAY(o.order_date) - JULIANDAY(o.prev_order_date)) = 1
  and ABS(JULIANDAY(o.order_date) - JULIANDAY(o.next_order_date)) = 1;
