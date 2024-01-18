-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    Ctg.category_id,
    Ctg.category_name,
    SUM(Odr.total_amount) AS total_sales_amount
FROM Categories Ctg
JOIN Products Prdt ON Ctg.category_id = Prdt.category_id
JOIN Order_Items OdrItm ON Prdt.product_id = OdrItm.product_id
JOIN Orders Odr ON OdrItm.order_id = Odr.order_id
GROUP BY Ctg.category_id, Ctg.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;
-- Join above It associates products with their respective categories and then links those products to order items and orders to calculate the total sales amount.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    Usr.user_id,
    Usr.username
FROM Users Usr
JOIN Orders Odr ON Usr.user_id = Odr.user_id
JOIN Order_Items OdrItm ON Odr.order_id = OdrItm.order_id
JOIN Products Prdt ON OdrItm.product_id = Prdt.product_id
JOIN Categories Ctg ON Prdt.category_id = Ctg.category_id
WHERE Ctg.category_name = 'Toys & Games'
GROUP BY Usr.user_id, Usr.username
HAVING COUNT(DISTINCT Prdt.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'));
---- Joins above filters the results to only include orders related to products in the 'Toys & Games' category.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH MaxPriceEachCategory AS (
    SELECT 
        P.product_id,
        P.product_name,
        P.category_id,
        P.price,
        ROW_NUMBER() OVER (PARTITION BY P.category_id ORDER BY P.price DESC) AS rank
    FROM Products P
)
-- The ROW_NUMBER() window function is used with the PARTITION BY clause to assign a rank to each product within its category based on the descending order of prices.
SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM MaxPriceEachCategory
WHERE rank = 1;
--The WHERE clause filters the results to include only those rows where the rank is equal to 1.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH ConsecutiveOrderThreeDays AS (
    SELECT 
        user_id,
        order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
-- ConsecutiveOrderThreeDays will generate a result set that includes information about each order's date, the next order's date (next_order_date), and the previous order's date (prev_order_date) for each user.
--The LEAD and LAG window functions are used to access data from subsequent and preceding rows, respectively. In this case, they are used to get the next and previous order dates for each order, based on the order date's ordering within each user's set of orders.
SELECT DISTINCT 
    Usr.user_id,
    Usr.username
FROM Users Usr
JOIN ConsecutiveOrderThreeDays COTD ON Usr.user_id = COTD.user_id
WHERE (next_order_date = order_date + INTERVAL '1 day' AND order_date = prev_order_date + INTERVAL '1 day')
   OR (next_order_date = order_date + INTERVAL '1 day' AND next_order_date = prev_order_date + INTERVAL '2 day')
   OR (next_order_date = order_date + INTERVAL '2 day' AND order_date = prev_order_date + INTERVAL '1 day');
--The WHERE clause filters the results based on three conditions:
--Consecutive days (next day and previous day): next_order_date = order_date + INTERVAL '1 day' AND order_date = prev_order_date + INTERVAL '1 day'
--Alternate consecutive days (next day and day after next): next_order_date = order_date + INTERVAL '1 day' AND next_order_date = prev_order_date + INTERVAL '2 day'
--Alternate consecutive days (day after next and previous day): next_order_date = order_date + INTERVAL '2 day' AND order_date = prev_order_date + INTERVAL '1 day'
