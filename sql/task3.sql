-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Calculates total sales amount for each category and then selects the top 3 categories
SELECT C.category_id, C.category_name, SUM(O.total_amount) AS total_sales_amount
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
JOIN Orders O ON OI.order_id = O.order_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH ToysAndGamesProducts AS (
  SELECT DISTINCT p.product_id
  FROM Products p
  JOIN Categories c ON p.category_id = c.category_id
  WHERE c.category_name = 'Toys & Games'
)
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o on o.user_id = u.user_id
JOIN Order_Items oi on oi.order_id = o.order_id
JOIN Products p on p.product_id = oi.product_id
JOIN Categories c on c.category_id = p.category_id
JOIN ToysAndGamesProducts tg ON p.product_id = tg.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) =  (SELECT COUNT(*) FROM ToysAndGamesProducts);





-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.



-- This gives the max_price within each category
WITH MaxPrice AS (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
)

SELECT p.product_id, p.product_name, mp.category_id, p.price
FROM Products p 
JOIN MaxPrice mp on p.category_id = mp.category_id AND p.price = mp.max_price;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Calculates two new column 'order_date2' and 'order_date3' for each order
WITH ThreeDaysOrders AS (
  SELECT
    o.user_id, o.order_date,
    LAG(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS order_date2,
    LAG(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS order_date3
  FROM Orders o
)
-- Only retrieve users for whom the current order date is one day after the second-order date and two days after the third-order date
SELECT u.user_id, u.username
FROM Users u
JOIN ThreeDaysOrders o ON u.user_id = o.user_id
WHERE o.order_date2 = DATE_SUB(o.order_date, INTERVAL 1 DAY)
  AND o.order_date3 = DATE_SUB(o.order_date, INTERVAL 2 DAY);



