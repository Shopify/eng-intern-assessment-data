-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Sum up all the sales amount of all products in every category and order 
-- by the amount. If there is a tie, order by category_id.
SELECT c.category_id, c.category_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) as total_sales_amount
FROM Categories c
    LEFT JOIN products p on c.category_id = p.category_id
    LEFT JOIN order_items oi on p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount desc, c.category_id
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Find all orders for products in the Toys & Games for every user if such an
-- order exists.
-- If the number of distinct such products is the same as all products in the
-- Toys & Games, the user is included.
SELECT u.user_id, u.username
FROM Users u 
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(DISTINCT p2.product_id)
    FROM Products p2 JOIN Categories c2
        ON p2.category_id = c2.category_id
    WHERE c2.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- For each product, if its price is larger or equal to all prices of products
-- in the same category, then it is the product with the highest price in that
-- category and it is included in the final answer.
-- Note: a category is included if and only if there is at least one product in
-- the category.
SELECT p1.product_id, p1.product_name, p1.category_id, p1.price
FROM Products p1
WHERE p1.price >= ALL (
    SELECT p2.price
    FROM Products p2
    WHERE p2.category_id = p1.category_id
);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Three joins to get all combinations of 3 orders a user made. If any of the
-- order has consecutive dates, include the user. Since all orders are 
-- included, we don't need an absolute value.
SELECT DISTINCT u.user_id, u.username
FROM Users u
    JOIN Orders o1 ON u.user_id = o1.user_id
    JOIN Orders o2 ON u.user_id = o2.user_id
    JOIN Orders o3 ON u.user_id = o3.user_id
WHERE o1.order_date - o2.order_date = 1 AND
      o2.order_date - o3.order_date = 1
ORDER BY u.user_id;
