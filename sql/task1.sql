-- Shopify Data Technical Challenge, part 1 of 3

-- The following commented-out line sets the schema to the 'shopify' schema created for this task.
-- USE shopify;

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- First, we will search for the category id for 'Sports' in the categories table.
SELECT * FROM categories;

-- We see that 'Sports & Outdoors' has category_id 8. There is no category for just 'Sports,' so we will use this one.

-- Next, we'll retrieve all products where category_id is 8.
Select * FROM products
WHERE category_id = 8;

-- We see two products in the 'Sports & Outdoors' category: a mountain bike and a tennis racket.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- We'll find the count of orders by each user by joining the orders and users tables.
SELECT
	COUNT(orders.order_id) AS 'order_count',
    orders.user_id, 
    users.username 
FROM orders INNER JOIN users ON orders.user_id = users.user_id
GROUP BY orders.user_id, users.username;

/* We see that each user has exactly one order. We'll keep this in mind for later questions where we are asked to form queries
assuming that there are multiple orders per user.
*/

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- We will find the average rating for each product by joining the products and reviews tables.
SELECT
	reviews.product_id,
    products.product_name,
    AVG(reviews.rating) AS 'average_rating'
FROM reviews INNER JOIN products ON products.product_id = reviews.product_id
GROUP BY products.product_name, reviews.product_id
ORDER BY average_rating DESC;

/* We see that five products are tied for the highest average rating, 5.0: 
	Smartphone X, 
    Smart TV, 
    Coffee Maker,
    Yoga Mat
    
    The lowest average rating is the Board Game Collection, with an average rating of 1.0.
    */
    
-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- We'll find the highest spending users by joining the orders and users tables and summing the total amount spent, grouped by each user.
SELECT
	users.username,
	orders.user_id,
    SUM(orders.total_amount) AS total_spent
FROM orders JOIN users ON orders.user_id = users.user_id
GROUP BY orders.user_id, users.username
ORDER BY total_spent DESC
LIMIT 5;

/* We see that the top five users by total amount spent are:
	1. jasonrrodriguqez, (user_id 12) who spent 160
	2. robertbrown, (user_id 4) who spent 155
    3. jamesrogers, (user_id 24) who spent 150
    4. chrisharris, (user_id 8) who spent 150
    5. olivialopez, (user_id 17) who spent 145
    */