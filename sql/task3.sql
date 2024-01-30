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




-- Query 1: Calculate Total Sales for the Top 3 Categories
-- This query calculates the total sales for the top 3 categories based on the sum of 'total_amount' from the 'Orders' table.
-- It joins multiple tables, starting with 'Categories' and then linking through 'Products', 'Order_Items', and 'Orders'.
-- The results are grouped by category_id and category_name, and total sales are computed as 'total_sales'.
-- The results are then ordered in descending order by 'total_sales' and limited to the top 3 categories.
SELECT Categories.category_id, Categories.category_name, SUM(Orders.total_amount) AS total_sales
FROM Categories 
JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
JOIN Orders ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Query 2: Find Users Who Purchased All Products from Category 5
-- This query identifies users who have purchased all products from category 5.
-- It joins 'Users', 'Orders', 'Order_Items', 'Products', and 'Categories' tables to track user purchases.
-- The results are filtered to include only users who purchased from category 5.
-- Users are grouped by user_id and username, and the HAVING clause ensures that they bought all products in that category.
SELECT Users.user_id, Users.username
FROM Users 
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_id = 5
GROUP BY Users.user_id, Users.username
HAVING
    COUNT(DISTINCT Products.product_id) = (
        SELECT COUNT(*)
        FROM Products
        WHERE category_id = 5
    );

-- Query 3: Find the Most Expensive Product in Each Category
-- This query ranks products within each category by price in descending order.
-- It uses a common table expression (CTE) called 'RankedProducts' to calculate the rank of each product by category based on price.
-- The result is filtered to select products with a rank of 1 within each category.
WITH RankedProducts AS (
    SELECT Products.product_id, Products.product_name, Products.category_id, Products.price,
        RANK() OVER (PARTITION BY Products.category_id ORDER BY Products.price DESC) AS price_rank
    FROM Products
)
SELECT RankedProducts.product_id, RankedProducts.product_name, RankedProducts.category_id, RankedProducts.price
FROM RankedProducts
WHERE RankedProducts.price_rank = 1;

-- Query 4: Find Users with Three or More Consecutive Orders
-- This query identifies users who have placed three or more consecutive orders.
-- It uses two common table expressions (CTEs): 'ConsDays' to track consecutive order dates for each user and 'ConsCount' to count consecutive orders.
-- The results are filtered to include only users with 'num_consecutive_date' greater than or equal to 3.
WITH ConsDays AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as prev_order_date
    FROM orders
),
ConsCount AS (
    SELECT users.user_id, username, COUNT(order_date) as num_consecutive_date
    FROM users
    JOIN ConsDays
    ON users.user_id = ConsDays.user_id
    WHERE order_date = prev_order_date + 1
    GROUP BY users.user_id, username
)
SELECT user_id, username
FROM ConsCount
WHERE num_consecutive_date >= 3;
