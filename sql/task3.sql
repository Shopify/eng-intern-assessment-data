-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CategorySales AS (
    SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS TotalSalesAmount  
    FROM Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items oi ON p.product_id = oi.product_id 
    JOIN Orders o ON oi.order_id = o.order_id  
    GROUP BY c.category_id, c.category_name
)

SELECT cs.category_id, cs.category_name, cs.TotalSalesAmount
FROM CategorySales cs
ORDER BY cs.TotalSalesAmount DESC
LIMIT 3;



-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


WITH ToysGamesProducts AS (
    SELECT product_id
    FROM Products
    WHERE category_id = (
        SELECT category_id
        FROM Categories
        WHERE category_name = 'Toys & Games'
    )
),

UserOrders AS (
    SELECT DISTINCT o.user_id, p.product_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.product_id IN (SELECT product_id FROM ToysGamesProducts)
),

UserOrderCounts AS (
    SELECT user_id, COUNT(DISTINCT product_id) AS products_ordered_count
    FROM UserOrders
    GROUP BY user_id
)


SELECT u.user_id, u.username
FROM Users u
JOIN UserOrderCounts uoc ON u.user_id = uoc.user_id
WHERE uoc.products_ordered_count = (SELECT COUNT(*) FROM ToysGamesProducts);




-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


WITH RankedProducts(
    SELECT p.product_id, p.product_name, p.category_id, p.price, ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as row_number
    FROM Products p

)

SELECT rp.product_id, rp.product_name, rp.category_id, rp.price
FROM RankedProducts rp
WHERE rp.row_number = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


