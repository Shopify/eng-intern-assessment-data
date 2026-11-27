-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join tables categories, products, and order_items to get all the information for each category
-- Then group by category_id and name, get the sum by calculating quantity * unit_price for total sales amount
-- Then order them and get the top 3 categories
SELECT c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) AS total_amount
FROM categories c 
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi on p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join Tables users, orders, order_items, products, and categories to get all the information on users' orders 
-- Then after filtering the category name to by 'Toys & Games', count the distinct product_id that each user has placed an order for
-- Compare this with a subquery of getting the number of products in category 'Toys & Games'
SELECT DISTINCT u.user_id, u.username
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*)
    FROM products p1
    JOIN categories c1 
    ON p1.category_id = c1.category_id
    WHERE c1.category_name = 'Toys & Games'
)

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Create a CTE to rank the products within each category by their price
-- Use this CTE to get the highest price within each category.
WITH rankedproduct AS
(Select product_id, product_name, category_id, price, 
ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price) as ranks
FROM products)

Select product_id, product_name, category_id, price
FROM rankedproduct
WHERE ranks = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Similar to problem 8, we just have to Join with orders again to get 3 orders from the same unit. 
-- We will then compare that these three orders with different order_id are all 1 day apart from each other.
SELECT DISTINCT u.user_id, u.username
FROM users u 
JOIN orders o on u.user_id = o.user_id
JOIN orders o2 on u.user_id = o2.user_id
JOIN orders o3 on u.user_id = o3.user_id
WHERE o.order_id <> o2.order_id AND o2.order_id <> o3.order_id AND
        DATEDIFF(day, o.order_date, o2.order_date) = 1
        AND DATEDIFF(day, o2.order_date, o3.order_date) = 1;
