-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) as total_sales
FROM category_data c
JOIN product_data p ON c.category_id = p.category_id
JOIN order_items_data oi on p.product_id = oi.product_id
group by c.category_id, c.category_name
order by total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN order_items_data oi ON o.order_id = oi.order_id
JOIN product_data p ON oi.product_id = p.product_id
JOIN category_data c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(DISTINCT p.product_id)
    FROM product_data p
    JOIN category_data c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.product_data.category_id, MAX(p.price) as price 
FROM product_data p
JOIN category_data c
ON p.category_id = c.category_id
GROUP BY p.category_id

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT u.user_id, u.username
FROM user_data u
JOIN order_data u1 on u.user_id = u1.user_id
JOIN order_data u2 ON u1.user_id = u2.user_id AND u2.order_date - u1.order_date = 1
JOIN order_data u3 ON u1.user_id = u3.user_id AND u3.order_date - u2.order_date = 1;