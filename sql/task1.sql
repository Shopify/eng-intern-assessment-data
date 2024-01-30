-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Here we will select the product_name after joining categories and products
SELECT product_name 
from categories c, 
products p 
where c.category_id = p.category_id 
and category_name like '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- note that everyone has only one order from the test data set
SELECT u.user_id, u.username, count(u.user_id) as num_orders --count the number of orders 
from users u, orders c 
where u.user_id = c.user_id 
group by u.user_id; --group by the user id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Here i've gotten the average rating after joining the products and reviews
SELECT prod.product_id, prod.product_name, avg(rating) as avg_rating 
from products prod, reviews rev 
where prod.product_id = rev.product_id --join without bad data 
group by prod.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Join orders and users and then limit to 5 responses.
SELECT usrs.user_id, usrs.username, sum(total_amount) as total_spent 
from orders ord, users usrs 
where ord.user_id=usrs.user_id --verify joins
group by usrs.user_id  --group by the order id
order by total_spent desc 
LIMIT 5; --limit to 5 responses