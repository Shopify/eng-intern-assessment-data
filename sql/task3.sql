-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Categories.category_id, Categories.category_name, SUM(quantity*unit_price) AS 'total_sales_amount'  -- compute total sales amount per category
FROM Categories
JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY Categories.category_id
ORDER BY total_sales_amount DESC -- sort by total sales amount from highest to lowest
LIMIT 3 -- select top 3 categories with highest total sales amount
;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Users.user_id, username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_id = 5 -- category_id = 5 corresponds to 'Toys & Games'
GROUP BY Users.user_id
HAVING COUNT(DISTINCT Products.product_id) = (SELECT COUNT(DISTINCT product_id) FROM Products WHERE category_id = 5) -- select only users who have ordered all products in 'Toys & Games' category
;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT Products.product_id, product_name, Categories.category_id, MAX(price) AS 'highest_price' -- compute highest price per product
FROM Products
RIGHT JOIN Categories ON Products.category_id = Categories.category_id -- use RIGHT JOIN to include all categories even though with no product data
GROUP BY Categories.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT user_id, username
FROM
(
    SELECT 
    Users.user_id, 
    Users.username, 
    Orders.order_date, 
    DATEDIFF
    (
        Orders.order_date, 
        LAG(Orders.order_date, 1) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) -- compute previous order date using LAG() window function
    ) AS 'days_since_lagged_order_1', -- compute date difference between current order date and previous order date
    DATEDIFF
    (
        Orders.order_date, 
        LAG(Orders.order_date, 2) OVER (PARTITION BY Users.user_id ORDER BY Orders.order_date) -- compute previous order date with a lag of 2 using LAG() window function
    ) AS 'days_since_lagged_order_2' -- compute date difference between current order date and previous order date with a lag of 2
    FROM Users
    JOIN Orders ON Users.user_id = Orders.user_id
) AS subquery
GROUP BY user_id
HAVING 'days_since_lagged_order_1' = 1 AND 'days_since_lagged_order_2' = 2 -- select only users who have ordered on consecutive days for at least 3 days (date difference = 1 and 2)
;
