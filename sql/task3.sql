-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
with orders_and_cat as (
    select 
        Order_Items.order_id,
        Categories.category_id,
        Categories.category_name
    from Products
    join Order_Items on Products.product_id = Order_Items.product_id
    join Categories on Products.category_id = Categories.category_id
)

select 
    orders_and_cat.category_id,
    order_and_cat.category_name,
    sum(Orders.total_amount) as total_sales_amt
from orders_and_cat
join Orders on orders_and_cat.order_id = Orders.order_id
group by 1,2
order by sum(Orders.total_amount) desc
limit 3
;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
with user_ids as (
    select 
        Orders.user_id,
        count(distinct Order_Items.product_id)
    from Order_Items
    join Orders on Orders.order_id = Order_Items.order_id
    join Products on Products.order_id = Order_Items.order_id
    where category_id = 5
    group by 1
    having count(distinct Order_Items.product_id) = (select count(Products.product_id) from Products where category_id = 5)
)

select 
    Users.user_id,
    Users.username
from user_ids
join Users on user_ids.user_id = Users.user_id
;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with highest_price_by_categ as (
    select 
        product_id,
        product_name,
        category_id,
        price,
        row_number() over (partition by category_id order by price desc) AS rank
    from Products
)

select distinct
    product_id,
    product_name,
    category_id,
    price,
from highest_price_by_categ
where rank = 1
;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with consec_user_ids as (
    select distinct
        o1.user_id,
    from Orders o1
    join Orders o2 on o1.user_id = o2.user_id and o1.order_date = date_add(o2.order_date, interval -1 day)
    join Orders o3 on o1.user_id = o3.user_id and o1.order_date = date_add(o3.order_date, interval -2 day)
)

select
    consec_user_ids.user_id,
    Users.username
from consec_user_ids
join Users on consec_user_ids.user_id = Users.user_id
;