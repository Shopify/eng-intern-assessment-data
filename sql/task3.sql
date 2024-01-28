-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales
FROM Order_Items oi NATURAL JOIN Products p NATURAL JOIN Categories c
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH User_Purchases AS (
    SELECT u.user_id, oi.product_id
    FROM Users u JOIN Orders o on u.user_id = o.user_id
    JOIN Order_Items oi on o.order_id = oi.order_id
)

SELECT user_id, username
FROM Users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p JOIN Categories c on p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
    EXCEPT 
    SELECT up.product_id
    FROM User_Purchases up
    WHERE up.user_id = u.user_id
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH Max_Prices AS (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
)

SELECT product_id, product_name, category_id, price
FROM Products p NATURAL JOIN Max_Prices
WHERE p.price = max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT u.user_id, u.username
FROM Orders o1 JOIN Orders o2 on o1.user_id = o2.user_id
JOIN Orders o3 on o1.user_id = o3.user_id
JOIN Users u on o1.user_id = u.user_id
WHERE o1.order_date + 1 = o2.order_date AND
    o2.order_date + 1 = o3.order_date;
