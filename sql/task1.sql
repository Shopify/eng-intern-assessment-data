-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select * 
from Products p join Categories c on p.category_id = c.category_id 
where c.category_name = 'Sports & Outdoors';   -- Want to find the product that belongs to sports & outdoors category

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

select u.user_id, u.username, count(u.user_id) as order_total -- count the number of order for each users
from Users u left Join Orders o on u.user_id = o.user_id
group by u.user_id, u.username; 

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

select p.product_id, p.product_name, avg(r.rating) as average_rating   -- Averaging the rating for each product 
from Products p join Reviews r on p.product_id = r.product_id
group by p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

select u.user_id, u.username, sum(o.total_amount)  -- Summing the total amount spent on orders
from Users u join Orders o on u.user_id = o.user_id
group by u.user_id
order by sum(o.total_amount) desc
limit 5; -- only want the top 5 users 