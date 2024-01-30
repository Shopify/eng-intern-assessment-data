-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- The query calculates the total sales amount for each category by aggregating sales data 
-- from the joined tables: categories, products, order_items, and orders.
-- It multiplies the quantity of each product sold by its unit price in the order_items table, 
-- sums up these amounts per category, and then identifies the top 3 categories based on this total sales value.

select 
    cat.category_id, 
    cat.category_name, 
    sum(oi.quantity * oi.unit_price) as total_sales_amount
from 
    categories as cat
join 
    products as prod on cat.category_id = prod.category_id
join 
    order_items as oi on prod.product_id = oi.product_id
join 
    orders as ord on oi.order_id = ord.order_id
group by 
    cat.category_id, cat.category_name
order by 
    total_sales_amount desc
limit 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- The query operates in several stages using CTEs: First, it identifies all products in the category,
-- then finds all orders that include these products, and finally selects users who have ordered each of these products.

with CategoryProducts as (
    select product_id
    from products
    where category_id = 5
),
UserOrders as (
    select od.user_id, oi.product_id
    from order_items oi
    join orders od on oi.order_id = od.order_id
    join CategoryProducts cp on oi.product_id = cp.product_id
),
EligibleUsers as (
    select user_id
    from UserOrders
    group by user_id
    having count(distinct product_id) = (select count(*) from CategoryProducts)
)
select eu.user_id, u.username
from EligibleUsers eu
join users u on eu.user_id = u.user_id;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- The query operates in two main stages: first it calculates the highest price in each category using a CTE 
-- and then joins this CTE with the products table to find products that match the highest price in the category.

with MaxPrices as (
    select 
        category_id, 
        max(price) as max_price
    from 
        products
    group by 
        category_id
)
select 
    p.product_id,
    p.product_name,
    p.category_id,
    p.price
from 
    products p
inner join 
    MaxPrices mp on p.category_id = mp.category_id and p.price = mp.max_price
order by 
    p.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query identifies users who have placed orders on three consecutive days.
-- It does so by using a subquery to retrieve the user ID and the next three order dates for each user,
-- then joining that subquery with the "Users" table to get the corresponding usernames.
-- Conditions in the WHERE clause ensure that the orders are placed on three consecutive days.

select distinct u.user_id, u.username
from (
    select
        o.user_id,
        o.order_date,
        lead(o.order_date, 1) over (partition by o.user_id order by o.order_date) as next_order_date,
        lead(o.order_date, 2) over (partition by o.user_id order by o.order_date) as next_next_order_date
    from
        orders o
) as sub_query
join 
    users u on sub_query.user_id = u.user_id
where 
    date_add(sub_query.order_date, interval 1 day) = sub_query.next_order_date
and 
    date_add(sub_query.order_date, interval 2 day) = sub_query.next_next_order_date;

