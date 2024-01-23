-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
    SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating
    FROM products p INNER JOIN reviews r -- Inner join because I didn't want to include product_name/average_rating that didnt exist
    ON p.product_id == r.product_id
    GROUP BY r.product_id
    ORDER BY average_rating DESC
    LIMIT 5;
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
    SELECT u.user_id, u.username
    FROM users u JOIN orders o ON u.user_id == o.user_id
    JOIN order_items oi ON o.order_id == oi.order_id
    JOIN products p ON oi.product_id == p.product_id
    JOIN categories c ON p.category_id == c.category_id
    GROUP BY u.user_id
    HAVING COUNT(DISTINCT c.category_id) == (SELECT COUNT(*) FROM categories); -- Make sure the user has purchased the same amount of products in distinct categories as there are in the categories table
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
    SELECT p.product_id, p.product_name
    FROM products p LEFT JOIN reviews r -- Include all products, including ones without reviews
    ON p.product_id == r.product_id
    WHERE r.rating IS NULL; -- We only include products that don't have reviews
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
    SELECT DISTINCT u.user_id, u.username
    FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    JOIN orders o2 ON u.user_id == o2.user_id
    WHERE o1.order_date == DATE(o2.order_date, '+1 day') -- this is a sqlite3 function that adds 1 day to the o2 date 
    OR o1.order_date == DATE(o2.order_date, '-1 day'); -- had to account for +/- 1 day

    -- Alternate approach after doing problem 12 in task3
    -- SELECT DISTINCT u.user_id, u.username
    -- FROM users u JOIN orders o1 ON u.user_id == o1.user_id
    -- JOIN orders o2 ON u.user_id == o2.user_id
    -- WHERE ABS(julianday(o2.order_date) - julianday(o1.order_date)) == 1