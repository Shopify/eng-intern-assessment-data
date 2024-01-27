-- Shopify Data Technical Challenge, part 2 of 3

-- The following commented-out line sets the schema to the 'shopify' schema created for this task.
-- USE shopify;

-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

/* We will find the products with the highest average rating by joining the products and reviews tables and comparing the
average rating for each product with the maximum average rating for all products. */ 
SELECT
	reviews.product_id,
    products.product_name,
    AVG(reviews.rating) AS 'average_rating'
FROM reviews INNER JOIN products ON products.product_id = reviews.product_id
GROUP BY products.product_name, reviews.product_id
HAVING average_rating = (SELECT MAX(t.average_rating) FROM (SELECT AVG(rating) AS average_rating FROM reviews GROUP BY product_id) AS t);

/* As in the previous task, we see that the products with the highest rating of 5 are:
	- Smartphone X
    - Smart TV
    - Coffee Maker
	- Yoga Mat
    - Mountain Bike
Note: we could have used our knowledge from the previous task to filter for rows with an average rating of 5 (which
we knew to be the highest average rating). But we are aiming for a general solution which would work with new data
where we don't know the highest average rating in advance. */

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

/* There are (at least) two ways of interpreting this problem: as asking for the users who ordered items from
every category or as asking, of each category, which users ordered at least one item from that category. First, let's
see if any users ordered items from every category. */

-- To start, we'll see how many distinct categories there are.
SELECT COUNT(*) FROM categories;

-- There are 50 categories. Next, let's see how many distinct products there are in our order_items table.
SELECT COUNT(DISTINCT product_id) FROM order_items;

/* We see that only 30 distinct product IDs appear in our order_items table. The maximum number of categories that could
be represented in the order data is 30 (and it will be less than 30 if there are cases of multiple products ordered
from the same category). We can conclude that no customer has ordered a product from every one of the 50 categories.

Let's interpret the question in the second way: for each category, which users have ordered at least one product in
that category? We'll do this by joining the orders and order items tables to see which users have ordered each products,
and then join the resulting table with the category data.
*/
WITH user_categories AS
	(SELECT
		t.user_id,
		products.category_id
	FROM products JOIN
		(SELECT
			orders.user_id,
			order_items.product_id
		FROM orders JOIN order_items ON orders.order_id = order_items.order_id) AS t
	ON products.product_id = t.product_id)
SELECT
	categories.category_name,
    categories.category_id,
	user_categories.user_id,
    users.username
FROM user_categories JOIN categories ON user_categories.category_id = categories.category_id
JOIN users ON user_categories.user_id = users.user_id;

/* We see orders from just eight of the 50 categories, and for each of those eight we see just one user who
has ordered a product from that category (although each user has ordered exactly two products from that category):

- Electronics (johndoe)
- Books (janesmith)
- Clothing (maryjones)
- Home & Kitchen (robertbrown)
- Toys & Games (sarahwilson)
- Beauty & Personal Care (michaellee)
- Health & Household (lisawilliams)
- Sports & Outdoors (chrisharris)
*/

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

/* We'll look at the reviews data and look at the product IDs for all reviewed products. Then, we'll compare the data from this table
with the data from the products table, and look for any product IDs from the products table that didn't show up in the reviews table.
*/
WITH reviewed_products AS
	(SELECT
		product_id,
		COUNT(product_id) AS review_count
	FROM reviews
	GROUP BY product_id
	HAVING review_count > 0)
SELECT
	products.product_name,
    products.product_id
FROM products JOIN reviewed_products ON products.product_id = reviewed_products.product_id
WHERE products.product_id NOT IN (SELECT product_id FROM reviewed_products);

-- We see that there are no products from the products table that have received 0 reviews.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

/* We know from our previous exploration of the data that each order in the orders table has a unique user_id, and
so (assuming that no user has multiple user_ids), no user has made orders on consecutive days. But we can construct
a query that would return any users who had made orders on consecutive days. We'll use the DATEDIFF function and the LAG
window function to calculate the number of days between orders, and partition by user_id.
*/
WITH days_between_orders AS
	(SELECT 
		user_id,
		order_date,
		DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date)) AS date_diff
	FROM orders)
SELECT
	DISTINCT(users.username),
    users.user_id
FROM users JOIN days_between_orders ON users.user_id = days_between_orders.user_id
WHERE days_between_orders.date_diff = 1;

-- As expected, we see no users who have consecutive orders on consecutive days.