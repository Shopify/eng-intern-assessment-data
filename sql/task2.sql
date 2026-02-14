/* Shopify Data Engineer Intern Assessment - Joseph (Jihyung) Lee */

-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

/*  Comment: Process is as follows:
        1. Retrieve WHAT is the highest average review rating. 
        2. Then, we'll query which products have that avg. rating value
        3. Those products are the ones with the highest avg. rating */
SELECT
    p.product_id,   -- Product ID
    p.product_name, -- Product Name
    -- For neat presentation, average rating is shown using 2 decimal places.
    ROUND(subq.avg_rating, 2) AS average_rating -- Average Rating
FROM
    Products AS p
    -- Calculate the average rating for all products.
    -- Use the JOIN command to link the avg_rating column with Products table.
    JOIN(
        SELECT
            r.product_id,
            AVG(r.rating) as avg_rating
        FROM
            Reviews as r
        GROUP BY
            r.product_id
    ) AS subq ON p.product_id = subq.product_id
WHERE   -- WHERE products have the highest avg. rating
    subq.avg_rating = (
        -- 
        SELECT
            MAX(avg_rating)
        FROM
            (
                SELECT AVG(r.rating) as avg_rating
                FROM Reviews as r
                GROUP BY r.product_id
            )
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

/*  Comment: Process is as follows:
        1. Calculate the total amount of categories that exist. 
        2. Use the DISTINCT() function on the num of categories the user's product purchases belong to. 
        3. If that num = total num of categories, we know ser has made at least one order in each category. */
SELECT
    subq.user_id,   -- User ID
    subq.username   -- Username
FROM
    (
        -- Display User ID, Username, and The # of unique categories each user ordered
        SELECT
            u.user_id,
            u.username,
            SUM(DISTINCT(p.category_id)) AS ordered_categories
        FROM
            Order_Items AS oi
            JOIN Orders AS o ON oi.order_id = o.order_id        -- JOIN with Orders table to retrieve Orders data
            JOIN Products AS p ON oi.product_id = p.product_id  -- JOIN with Products table to retrieve Category data
            JOIN Users AS u ON o.user_id = u.user_id            -- JOIN with Users table to retrieve User data  
        -- Group by User ID and retrieve the total # of categories purchased for each user
        GROUP BY
            o.user_id
    ) AS subq
-- Calculate the total # of distinct product categories.
WHERE subq.ordered_categories = 
(
    SELECT COUNT(DISTINCT(c.category_id))
    FROM Categories AS c
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    p.product_id,   -- Product ID
    p.product_name  -- Product Name
FROM
    Products as p
WHERE
    -- Use NOT IN operator to retrieve products WITHOUT reviews
    p.product_id NOT IN
    -- We can obtain the list of products that HAVE reviews, by using DISTINCT() on product_id.
    (
        SELECT
            DISTINCT(r.product_id) 
        FROM
            Reviews AS r
    );


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- DISTINCT() function is added to ensure a single user_id/username appears only once.
-- Decided to apply DISTINCT() on u.user_id, as there could be multiple users with the same name, but no multiple users with the same user ID.
SELECT
    DISTINCT(u.user_id),    -- User ID
    u.username              -- Username 
FROM
    Users AS u
    JOIN Orders AS o ON u.user_id = o.user_id

-- As we have the date for each row, check if the next date exists in Orders, but with the same user ID
-- If consecutive date exists, it is displayed in the query.
-- DATE() function is used to achieve this.
WHERE
    DATE(o.order_date, '+1 Day') IN
    (
        SELECT o.order_date
        FROM Orders AS o
        WHERE o.user_id = u.user_id
    )
-- For presentation, query is set to show users in ascending ID.
ORDER BY u.user_id ASC;