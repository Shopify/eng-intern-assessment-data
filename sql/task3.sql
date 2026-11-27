-- Problem 9: Retrieve the top 3 categories with the highest total sales amount

-- This command returns the top 3 categories with the highest total sales amount, with the category_id, category_name, and total_sales_amount
SELECT categories.category_id, categories.category_name, SUM(order_items.quantity * order_items.unit_price) AS total_sales_amount
FROM categories
JOIN products ON categories.category_id = products.category_id
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY categories.category_id, categories.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;



-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games

-- This command returns the users who have placed orders for all products in the Toys & Games category, with their user_id and username
SELECT users.user_id, users.username
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
WHERE products.category_id = 5
GROUP BY users.user_id, users.username
HAVING COUNT(DISTINCT products.product_id) = (SELECT COUNT(*) FROM products WHERE products.category_id = 5);



-- Problem 11: Retrieve the products that have the highest price within each category

-- This command returns the products that have the highest price within each category, with the product_id, product_name, category_id, and price
WITH HighestPrice AS (
    SELECT products.product_id, products.product_name, products.category_id, products.price, ROW_NUMBER() OVER (PARTITION BY products.category_id ORDER BY products.price DESC) AS row_num
    FROM products
)
SELECT HighestPrice.product_id, HighestPrice.product_name, HighestPrice.category_id, HighestPrice.price
FROM HighestPrice
WHERE HighestPrice.row_num = 1;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days

-- This command retrieves, for all users that have placed a command for at least 3 consecutive days, the user_id, the username, and the number of consecutive days that the user has placed orders
WITH ConsecutiveOrders AS (
    SELECT orders.user_id, orders.order_date, LAG(orders.order_date) OVER (PARTITION BY orders.user_id ORDER BY orders.order_date) AS previous_order_date
    FROM orders
)
SELECT users.user_id, users.username, COUNT(*) + 1 AS num_consecutive_days
FROM users
JOIN ConsecutiveOrders ON users.user_id = ConsecutiveOrders.user_id
WHERE ConsecutiveOrders.order_date = ConsecutiveOrders.previous_order_date + INTERVAL '1 day'
GROUP BY users.user_id, users.username
HAVING COUNT(*) >= 2
ORDER BY num_consecutive_days DESC;
