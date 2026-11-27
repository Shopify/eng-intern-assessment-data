-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    C.category_id,
    C.category_name,
    SUM(OI.quantity * OI.unit_price) AS total_sales_amount
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Toys & Games'
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT OI.product_id) = (
    SELECT COUNT(*)
    FROM Products
    WHERE category_id = C.category_id
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM Products
)

SELECT
    product_id,
    product_name,
    category_id,
    price
FROM RankedProducts
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH UserOrderDates AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)

SELECT DISTINCT UOD.user_id, U.username
FROM UserOrderDates UOD
JOIN Users U ON UOD.user_id = U.user_id
WHERE DATEDIFF(UOD.order_date, UOD.prev_order_date) = 2
   AND UOD.prev_order_date IS NOT NULL
GROUP BY UOD.user_id, U.username;
