-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
    -- source data from Products and Reviews
    -- similar to problem 3 with order desc
    SELECT product_id, product_name, AVG(rating) AS average_rating FROM Products NATURAL JOIN Reviews GROUP BY product_id ORDER BY average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
    -- source data from Users (user_id, username), Orders (order_id, user_id),
    -- Order_Items (order_id, product_id), Products (category_id)
    SELECT user_id, username FROM (
        -- count the number of distinct categories the user has ordered
        SELECT user_id, username, COUNT(DISTINCT category_id) as ct, total_categories
        -- get the order id, products ordered, their category, and name
        FROM ( USERS NATURAL JOIN (SELECT order_id, user_id FROM Orders) NATURAL JOIN
            (SELECT order_id, product_id FROM Order_Items) NATURAL JOIN
            ( SELECT product_id, category_id FROM Products) NATURAL JOIN
            -- counting the number of tuples within Categories to get their total number
            ( SELECT category_id, category_name, count(category_id) as total_categories FROM Categories)) GROUP BY user_id)
	-- the value below should be equivalent to the total number of records in Categories
    WHERE ct > total_categories



-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
    -- source data from Products, Reviews
    -- similar to Problem 3 except it utilizes an EXCEPT clause, since that query's behaviour
    -- TODO: this may change if items without reviews are included and specifically marked
    SELECT product_id, product_name FROM Products
    -- excludes products without a review
    EXCEPT SELECT product_id, product_name FROM Products NATURAL JOIN Reviews GROUP BY product_id;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
    -- source data from Orders natural joined with User
    SELECT user_id, username FROM
	-- Determine consecutive orders
	(SELECT *, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS consec FROM Orders NATURAL JOIN Users)
    -- checks that conditions are not null and the order_date and previous date differs by 1
    WHERE consec IS NOT NULL and order_date - 1 = consec;