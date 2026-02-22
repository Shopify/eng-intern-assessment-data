-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- This query calculates the average rating for each product using a CTE,
-- then selects the product(s) that have the highest average rating across all products.

with AverageRatings as (
    select 
        pd.product_id, 
        pd.product_name, 
        AVG(r.rating) as avg_rating
    from 
        product_data pd
    join 
        review_data r on pd.product_id = r.product_id
    group by 
        pd.product_id, pd.product_name
)

select 
    product_id, 
    product_name, 
    avg_rating
from
    AverageRatings
where 
    avg_rating = (select max(avg_rating) from AverageRatings);



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- This query joins several tables to trace the categories of products ordered by each user.
-- By counting if the number of distinct categories each user has placed an order in matches the number of categories in
-- the categories table, it filters for users who have a order history covering all product categories.

select 
    u.user_id, 
    u.username
from 
    users u
join 
    orders od on u.user_id = od.user_id
join 
    order_items oid on od.order_id = oid.order_id
join 
    products pd on oid.product_id = pd.product_id
group by 
    u.user_id, 
    u.username
having 
    count(distinct pd.category_id) = (select count(*) from categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Utilizes a LEFT JOIN to combine products with their reviews and identifies those lacking reviews.
select
	products.product_id,
    products.product_name
from 
	products
left join 
	reviews on products.product_id = reviews.product_id
where
	reviews.product_id 	is NULL;
	

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- This query uses a CTE to calculate the day difference between each order and the next order for the same user,
-- and then selects users with a one-day difference, indicating consecutive day orders.
with OrderedOrders as (
    select 
        user_id, 
        order_date,
        datediff(lead(order_date) over (partition by user_id order by order_date), order_date) as diff
    from 
        orders
)
select 
    o.user_id, 
    u.username
from 
    OrderedOrders o
join 
    users u on o.user_id = u.user_id
where 
    o.diff = 1;
