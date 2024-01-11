-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS TotalSalesAmount
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY SUM(oi.quantity * oi.unit_price) DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Write an SQL query to retrieve the users who have placed orders for all products in a specific category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.username, p.category_id
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(p.product_id)
    FROM Products p
    WHERE category_id = p.category_id
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p
INNER JOIN (
    SELECT p.category_id, MAX(p.price) AS maxPrice
    FROM Products p
    GROUP BY p.category_id
) AS maxPrices ON p.category_id = maxPrices.category_id AND p.price = maxPrices.maxPrice;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM Users u INNER JOIN Orders o ON u.user_id = o.user_id 
INNER JOIN Orders ord ON u.user_id = ord.user_id AND ord.order_date = o.order_date + 1
INNER JOIN Orders orde ON u.user_id = orde.user_id AND orde.order_date = ord.order_date + 1; 