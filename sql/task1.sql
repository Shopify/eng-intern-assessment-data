-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Join the products table with the categories table to match each product with its respective category.
-- Filter the products to include only those in the 'Sports' category,
select 
	p.product_id,
    p.product_name,
    p.description,
    p.price
from 
	products p 
join
	categories c on p.category_id = c.category_id
where
	c.category_name = 'Sports & Outdoors';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- This query joins the 'users' and 'orders' tables to associate each order with the corresponding user,
-- and then groups the results by user to count the number of orders per user.
select 
	users.user_id, users.username, COUNT(orders.order_id) as total_orders
from 
	users
join 
	orders on orders.user_id = users.user_id
group by 
	users.user_id, users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- The query joins the 'reviews' and 'products' tables to correlate each review with its product,
-- then computes the average rating for each product and groups the results by product ID and name.

select 
	reviews.product_id,
    products.product_name,
	avg(reviews.rating) as average_rating
from
	reviews
inner join
	products on reviews.product_id = products.product_id
group by
	reviews.product_id, products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- The query joins the 'orders' table with the 'users' table to include usernames and orders the result 
-- to list the top spenders by total amount spent in descending order.
-- This query uses SUM to aggregate total spending per user. Although the current dataset has only one order per user,
-- using SUM is a scalable approach, making the query suitable for larger datasets with multiple orders per user.
select
	orders.user_id,
    users.username,
    sum(orders.total_amount) as total_spent
from
	orders
inner join
	users on orders.user_id = users.user_id
order by
	total_spent desc
limit 
	5;