-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- First calculate the total sales amount for each category, and then select the top 3 categories.
SELECT category_id, category_name, SUM(total_amount) AS total_sales_amount
from Categories NATURAL JOIN Products NATURAL JOIN Order_Items NATURAL JOIN Orders
GROUP BY category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Find all the user_is, username, and product_id pairs grouped by user_id,
-- then count the number of distinct products for each user.
SELECT user_id, username
FROM Users NATURAL JOIN Orders NATURAL JOIN Order_Items NATURAL JOIN Products
WHERE category_id = (
    SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
)
GROUP BY user_id
HAVING COUNT(DISTINCT product_id) = (
    SELECT COUNT(*) 
    FROM Products 
    WHERE category_id = (
        SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Find the highest price for each category, and then select the products with the highest price.
-- Assume if there is more than one product with the highest price, all of them should be selected.
WITH Max_Price AS (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
)
SELECT product_id, product_name, category_id, price
FROM Products NATURAL JOIN Max_Price
WHERE price = max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- First calculate the first last and second last order dates for each order by each user.
-- Then select the users who have made 3 consecutive orders on consecutive days 
-- (i.e., the order date is the first last order date + 1 day and second last order date + 2 days).
WITH Previous_Order AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS last_1_order_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS last_2_order_date
    FROM Orders
)
SELECT DISTINCT user_id, username
FROM Users NATURAL JOIN Previous_Order
WHERE order_date = last_1_order_date + INTERVAL '1' DAY and order_date = last_2_order_date + INTERVAL '2' DAY;