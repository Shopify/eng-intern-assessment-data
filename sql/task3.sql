/* Shopify Data Engineer Intern Assessment - Joseph (Jihyung) Lee */

-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

/*  Comment: Assumed 'total sales' is calculated by multiplying the sold quantity by the unit price. */
SELECT
    c.category_id,      -- Category ID 
    c.category_name,    -- Category Name
    -- Compute total sales, label this column as 'total_sales'
    SUM(oi.quantity*unit_price) AS total_sales  -- Total sales amount
FROM
    Order_Items AS oi
    JOIN Products AS p ON oi.product_id = p.product_id      -- Join Products table to retrieve Products data
    JOIN Categories AS c ON p.category_id = c.category_id   -- Join Categories table to retrieve Categories data
-- Group by Category ID, allowing us to use aggregate function (SUM)
GROUP BY c.category_id
-- Combination of DESC and LIMIT 3 to display the top 3 categories
ORDER BY total_sales DESC LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

/*  Comment: To check if a user has placed orders for all products in the Toys & Games category, 
    we can calculate the total amount of DISTINCT products in the Toys & Games category.
    Then, we can query the amount of distinct Toys & Games products each user has bought.
    Finally, if the queried value is equal to the num of all Toys & Games products, 
    We can conclude that the user has placed orders for all products in the Toys & Games category. */

-- Display user ID and username
SELECT
    subq.user_id,   -- User ID
    subq.username   -- Username
FROM
(
    -- "count" is the number of products pertaining to 'Toys & Games' bought by each user.
    -- A combination of COUNT+DISTINCT is applied to get the # of distinct 'Toys & Games' products the user has bought.
    SELECT
        u.user_id, u.username,
        COUNT(DISTINCT(oi.product_id)) as count
    -- Use JOIN statements to align Order_Items, Orders, and Users without using subqueries
    FROM
        Order_Items AS oi
        JOIN Orders AS o ON oi.order_id = o.order_id
        JOIN Users AS u ON o.user_id = u.user_id
    -- Remove all users that didn't buy Toys and Games
    WHERE oi.product_id IN
    (
        SELECT product_id
        FROM 
            Products AS p,
            Categories AS c
        WHERE p.category_id = c.category_id
        AND c.category_name = 'Toys & Games'
    )
    GROUP BY u.user_id) AS subq
-- Count the actual # of products pertaining to 'Toys & Games' available.
WHERE subq.count =
(
    SELECT COUNT(p.product_id)
    FROM
        Products AS p,
        Categories AS c
    WHERE p.category_id = c.category_id
    AND c.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

/*  Comment: Here, it is assumed that if there is more than one product with the same price (that is also the
    highest price within the category), all of those products will be displayed in the query. */
SELECT
    p.product_id,   -- Product ID
    p.product_name, -- Product Name
    p.category_id,  -- Category ID
    p.price         -- Price
FROM
    Products AS p
    JOIN (
        -- Calculate Maximum price for each category ID, using GROUP BY and MAX
        SELECT
            p.category_id,
            MAX(p.price) AS max_price
        FROM
            Products AS p
        GROUP BY p.category_id)
        AS subq ON p.category_id = subq.category_id
-- Ensure only the products with the HIGHEST price are shown.
WHERE p.price = subq.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

/*  Comment: The solution to this problem is an addition to the solution for Problem 8. 
    The DATE() function is used to check if in the list of order dates, there exists an order from the same
    person with the next date. The function is invoked again to check if there exists an order from the same
    person, with the date a day after that. */
SELECT
    DISTINCT(u.user_id),    -- User ID
    u.username              -- Username
FROM
    Users AS u
    JOIN Orders AS o ON u.user_id = o.user_id
WHERE
    DATE(o.order_date, '+1 Day') IN
    (
        SELECT o.order_date
        FROM Orders AS o
        WHERE o.user_id = u.user_id
    )
AND DATE(o.order_date, '+2 Day') IN
    (
        SELECT o.order_date
        FROM Orders AS o
        WHERE o.user_id = u.user_id
    )
-- For presentation, query is set to show users in ascending ID.
ORDER BY u.user_id ASC;