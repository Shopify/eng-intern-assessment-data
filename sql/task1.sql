-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.product_id, p.product_name, p.description, p.price FROM products AS p JOIN categories AS c ON p.category_id = c.category_id WHERE category_name Like '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
select u.user_id,u.username, Count(order_id) as total_orders from shopify.orders as o, shopify.users as u where o.user_id = u.user_id group by o.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select p.product_id, p.product_name, avg(r.rating) as average_rating from shopify.products as p, shopify.reviews as r where p.product_id = r.product_id group by r.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
select u.user_id,u.username,ta as total_amount_spent  from shopify.users as u, (select user_id,sum(total_amount) as ta from shopify.orders group by user_id order by ta DESC LIMIT 5) as t where u.user_id=t.user_id;