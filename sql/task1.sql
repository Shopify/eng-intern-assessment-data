-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

select * from Products
where category_id = 8; -- Since Sports is the 8th category

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

select u.user_id, u.username, count(o.order_id)
from Users u, Orders o
where u.user_id = o.user_id
group by u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

select p.product_id, p.product_name, avg(r.rating)
from Products p, Reviews r
where p.product_id = r.product_id
group by p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

select u.user_id, u.username, sum(o.total_amount)
from Users u, Orders o
where u.user_id = o.user_id
group by u.user_id, u.username
order by sum(o.total_amount) desc
limit 5;