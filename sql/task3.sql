-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


WITH CategorySales AS (
    SELECT products.category_id, SUM(order_details.quantity * products.price) AS total_sales
    FROM order_details
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY products.category_id
)
SELECT categories.category_id, categories.category_name, COALESCE(total_sales, 0) AS total_sales
FROM categories
LEFT JOIN CategorySales ON categories.category_id = CategorySales.category_id
ORDER BY total_sales DESC
LIMIT 3;

SELECT users.user_id, users.username
FROM users
WHERE users.user_id IN (
    SELECT DISTINCT users.user_id
    FROM users
    JOIN orders ON users.user_id = orders.user_id
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    WHERE products.category = 'Toys & Games'
    GROUP BY users.user_id
    HAVING COUNT(DISTINCT products.product_id) = (
        SELECT COUNT(DISTINCT product_id) FROM products WHERE category = 'Toys & Games'
    )
);

WITH MaxPricePerCategory AS (
    SELECT products.product_id, products.product_name, products.category_id, products.price,
           ROW_NUMBER() OVER(PARTITION BY products.category_id ORDER BY products.price DESC) AS rn
    FROM products
)
SELECT product_id, product_name, category_id, price
FROM MaxPricePerCategory
WHERE rn = 1;

WITH UserOrdersWithDates AS (
    SELECT orders.user_id, orders.order_date, LAG(orders.order_date) OVER (PARTITION BY orders.user_id ORDER BY orders.order_date) AS prev_order_date
    FROM orders
)
SELECT DISTINCT user_id, username
FROM users
JOIN UserOrdersWithDates ON users.user_id = UserOrdersWithDates.user_id
WHERE DATEDIFF(order_date, prev_order_date) = 1
AND user_id IN (
    SELECT DISTINCT user_id
    FROM UserOrdersWithDates
    WHERE DATEDIFF(order_date, prev_order_date) = 1
    AND user_id IN (
        SELECT DISTINCT user_id
        FROM UserOrdersWithDates
        WHERE DATEDIFF(order_date, prev_order_date) = 1
    )
);

