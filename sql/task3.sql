-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) as total_sales -- We want the total sales amount, so multiply the quantity and unit price
    FROM categories c JOIN products p ON c.category_id == p.category_id
    JOIN order_items oi ON p.product_id == oi.product_id
    GROUP BY c.category_id
    ORDER BY total_sales DESC
    LIMIT 3;
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    SELECT u.user_id, u.username
    FROM users u JOIN orders o ON u.user_id == o.user_id
    JOIN order_items oi ON o.order_id == oi.order_id
    JOIN products p ON oi.product_id == p.product_id
    JOIN categories c ON p.category_id == c.category_id
    WHERE c.category_name == 'Toys & Games'
    GROUP BY u.user_id -- This contains all the associated product categories for all of each users orders
    HAVING COUNT(DISTINCT p.product_id) == ( -- This keeps only users who have ordered all products from Toys & Games
        SELECT COUNT(*)
        FROM products
        WHERE category_id == (SELECT category_id FROM categories WHERE category_name == 'Toys & Games') -- counts products in Toys & Games
    );
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    SELECT p.product_id, p.product_name, p.category_id, p.price
    FROM products p
    WHERE p.price == (
        SELECT MAX(price) FROM products WHERE category_id == p.category_id -- Get the associated max price for the category, so we can match it with the product
    );
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    SELECT DISTINCT u.user_id, u.username
    FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    JOIN orders o2 ON u.user_id == o2.user_id
    JOIN orders o3 ON u.user_id == o3.user_id -- These generate all the date combinations of size 3 from orders. This includes combinations that have 3 consecutive dates.
    WHERE ABS(julianday(o2.order_date) - julianday(o1.order_date)) == 1 AND ABS(julianday(o3.order_date) - julianday(o2.order_date) == 1); -- If the date combination has a difference of 1 when comparing o1,o2 and o2,o3, there are 3 consecutive dates.

    -- Initial approach
    -- SELECT DISTINCT u.user_id, u.username
    -- FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    -- JOIN orders o2 ON u.user_id == o2.user_id
    -- JOIN orders o3 ON u.user_id == o3.user_id -- These generate all the date combinations from orders
    -- WHERE
    --     (julianday(o2.order_date) - julianday(o1.order_date) == 1 AND julianday(o3.order_date) - julianday(o2.order_date) == 1)
    --     OR
    --     (julianday(o2.order_date) - julianday(o1.order_date) == -1 AND julianday(o3.order_date) - julianday(o2.order_date) == -1);

    -- Secondary approach
    -- SELECT DISTINCT u.user_id, u.username
    -- FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    -- JOIN orders o2 ON u.user_id == o2.user_id
    -- JOIN orders o3 ON u.user_id == o3.user_id
    -- WHERE
    --     (o1.order_date == DATE(o2.order_date, '+1 day') AND o1.order_date == DATE(o3.order_date, '+2 days'))
    --     OR
    --     (o1.order_date == DATE(o2.order_date, '-1 day') AND o1.order_date == DATE(o3.order_date, '-2 days'));

    -- Investigating how julianday() displays
    -- SELECT DISTINCT u.user_id, u.username, julianday(o2.order_date) - julianday(o1.order_date), julianday(o3.order_date) - julianday(o2.order_date)
    -- FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    -- JOIN orders o2 ON u.user_id == o2.user_id
    -- JOIN orders o3 ON u.user_id == o3.user_id

    -- Viewing how different dates combine
    -- SELECT DISTINCT u.user_id, u.username, o1.order_date, o2.order_date, o3.order_date
    -- FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    -- JOIN orders o2 ON u.user_id == o2.user_id
    -- JOIN orders o3 ON u.user_id == o3.user_id