-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- i understood total sales as the quantity times the unit price per product per category.
-- group on category to find total sales across all products in that category
-- uses sorting and limiting to return top 3.
SELECT c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales
FROM Order_Items oi NATURAL JOIN Products p NATURAL JOIN Categories c
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- finds all purchased products per user. includes user IDs and product IDs.
WITH User_Purchases AS (
    SELECT u.user_id, oi.product_id
    FROM Users u JOIN Orders o on u.user_id = o.user_id
    JOIN Order_Items oi on o.order_id = oi.order_id
)

SELECT user_id, username
FROM Users u

-- selects only the users for which the difference between the products
-- in Toys & Games and the products they have purchased is empty.
-- such a user has purchased all the products in Toys & Games.
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

-- find the products with the largest price in each category
WITH Max_Prices AS (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
)

-- select only the products that have price equal to the maximum price
-- for their category.
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p JOIN Max_Prices mp ON p.category_id = mp.category_id
WHERE p.price = mp.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- i understood consecutive days to mean days that follow one after another.
-- double self join using cartesian product, filtering on rows where
-- user IDs are equivalent to make sure the rows represent only the relevant data.
-- then, filter on users that have order dates one after another for 3 straight days.
SELECT u.user_id, u.username
FROM Orders o1 CROSS JOIN Orders o2 CROSS JOIN Orders o3
LEFT JOIN Users u on o1.user_id = u.user_id
WHERE o1.user_id = o2.user_id AND 
    o1.user_id = o3.user_id AND
    o1.order_date + 1 = o2.order_date AND
    o2.order_date + 1 = o3.order_date;
