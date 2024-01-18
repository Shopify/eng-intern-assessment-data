-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Unit price from Order_Items conflicts with product prices in the Product table.
-- Order_Items unit price is used.

-- Get total sales for each category
WITH Category_Sales AS (
    SELECT p.category_id, SUM(oi.quantity*oi.unit_price) AS total_sales FROM
    Order_Items oi LEFT JOIN Products p ON oi.product_id = p.product_id
    GROUP BY category_id
)
-- Get names for each category, then sort by total sales and get the top 3
SELECT c.category_id, c.category_name, cs.total_sales FROM
Category_Sales cs LEFT JOIN Categories c ON cs.category_id = c.category_id
ORDER BY cs.total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Filter out products corresponding to the target category
WITH Target_Category_Products AS (
    SELECT * FROM Products WHERE category_id = (
        -- Retrieve category id to make query usable for other categories
        SELECT category_id FROM Categories WHERE category_name='Toys & Games'
    )
)
SELECT u.user_id, u.username FROM
Order_Items oi
-- Use RIGHT JOIN to only consider item orders for toy products
RIGHT JOIN Target_Category_Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Users u ON o.user_id = u.user_id
GROUP BY u.user_id
-- Get users that have bought the same number of distinct products as there are toy products
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(product_id) FROM Target_Category_Products);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Get position of each item within its category ranked by price
WITH Ordered_Within_Category AS (
    SELECT product_id, product_name, category_id, price, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS position
    FROM Products
)
-- Only get items that are position 1 (highest price)
SELECT product_id, product_name, category_id, price
FROM Ordered_Within_Category
WHERE position = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- With similar code as problem 8, we just need to check the gap between the previous date
-- The main caveat is that we must have distinct dates per order per customer
-- or else the previous previous date could be the same as the previous date.
WITH Order_Gaps AS (
    -- Removing orders with the same date and customer
    WITH Distinct_Date_Orders AS (
        SELECT DISTINCT user_id, order_date
        FROM Orders
    )
    -- Determining gaps between the current order and the last and last last orders
    SELECT user_id,
           order_date - LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS gap,
           order_date - LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS gap2
    FROM Distinct_Date_Orders
)
-- Choose users that have an order with a gap of 1 and 2 days, respectively.
-- DISTINCT ensures each user is counted once even if there are multiple consecutive order triplets
SELECT DISTINCT og.user_id, u.username FROM
Order_Gaps og JOIN Users u ON og.user_id = u.user_id
WHERE og.gap = 1 AND og.gap2 = 2;