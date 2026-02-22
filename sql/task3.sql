-- Shopify Data Technical Challenge, part 2 of 3

-- The following commented-out line sets the schema to the 'shopify' schema created for this task.
-- USE shopify;

-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

/* We will do this by calculating the total for each product on the order_items table by multiplying the quantity by the unit_price.
Then, we will join the results with the categories and products table to sum the product totals for each category.
*/
WITH product_totals AS
	(SELECT
		orders.order_id,
		order_items.product_id,
		quantity * unit_price AS product_total
	FROM orders JOIN order_items ON orders.order_id = order_items.order_id
	ORDER BY order_id)
SELECT
	categories.category_id,
    categories.category_name,
    SUM(product_total) AS category_total
FROM categories JOIN products ON categories.category_id = products.category_id
JOIN product_totals ON product_totals.product_id = products.product_id
GROUP BY categories.category_id, categories.category_name
ORDER BY category_total DESC
LIMIT 3;

/* We see that the top 3 categories by total sales are:
- Sports & Outdoors ($155)
- Home & Kitchen ($145)
- Electronics ($125)
*/

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- First, let's see how many products are in the 'Toys & Games' category.
SELECT *
FROM products JOIN categories ON products.category_id = categories.category_id
WHERE categories.category_name = 'Toys & Games';

/* We see that there are two products in this category: 'Action Camera' and 'Board Game Collection'. We'll now look within the
Toys & Games category for users that appear the same number of times as there are distinct products in that category.
*/
SELECT
	DISTINCT(orders.user_id),
    users.username
FROM orders JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON products.product_id = order_items.product_id
JOIN categories ON products.category_id = categories.category_id
JOIN users ON users.user_id = orders.user_id
GROUP BY orders.user_id, order_items.product_id, categories.category_name, users.username
HAVING categories.category_name = 'Toys & Games'
AND COUNT(orders.user_id) = COUNT(DISTINCT order_items.product_id);

/* We see that there is one user whose user_id appears in product orders in the 'Toys & Games' category the same number of times
as there are products in that category: sarahwilson (user_id 5).
*/

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

/* We will look at the maximum price for each category of products by looking at the maximum prices in the products table while
grouping by category ID. Then, we will join the results with the categories table to see the names for each category.
*/

WITH max_products AS
	(SELECT
		product_id,
        product_name,
		category_id,
		MAX(price) AS max_price
	FROM products
	GROUP BY category_id)
SELECT
	max_products.category_id,
    categories.category_name,
    max_products.product_id,
    max_products.product_name,
    max_products.max_price
FROM categories JOIN max_products ON categories.category_id = max_products.category_id;

/* This returns the highest priced product in each category:
- Electronics: Smartphone X ($500)
- Books: Laptop Pro ($1200)
- Clothing: Running Shoes ($300)
- Home & Kitchen: Coffee Maker ($80)
- Toys & Games: Action Camera ($200)
- Beauty & Personal Care: Yoga Mat ($150)
- Health & Household: Vitamin C Supplement ($100)
- Sports & Outdoors: Mountain Bike ($1000)

It's worth noting that at least one of these products seems to be misclassified: the highest priced item in the 'Books' category is a
laptop, which should be categorized with 'Electronics.' If this were real sales data we likely want to verify the categorization of each
product.
*/

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

/* As in the previous task, we know from exploring the data that each order in the orders table has a unique user_id, and
so (assuming that no user has multiple user_ids), no user has made orders on consecutive days. But again, we can construct a query
that would return any users who had made purchases on three consecutive days. As in the previous task, we'll do this by using the
LAG function to look at the difference between an order date and the previous order date. But we will also look at the date
difference between the order date and that of the order before the previous one (so we're looking at three consecutive orders).
We'll add the condition that the difference in days between the present order and the previous is 1, and that the differnece
between the present order and the one previous to the previous is 2.*/

WITH days_between_orders AS
	(SELECT 
		user_id,
		order_date,
		DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date)) AS date_diff_1,
        DATEDIFF(order_date, LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date)) AS date_diff_2
	FROM orders)
SELECT
	DISTINCT(users.username),
    users.user_id
FROM users JOIN days_between_orders ON users.user_id = days_between_orders.user_id
WHERE days_between_orders.date_diff_1 = 1
AND days_between_orders.date_diff_2 = 2;

/* As expected, there are no rows that meet the conditions we set out, and no customers who had three consecutive orders on three
consecutive days. */