-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Create a CTE to calculate the average rating for each product
-- Create a CTE to rank the products by average rating
WITH ProductRatings AS (
    SELECT
        product_id,
        AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)


, RankedProducts AS ( 
            
    SELECT
        p.product_id,
        p.product_name,
        pr.average_rating,
        RANK() OVER (ORDER BY pr.average_rating DESC) AS rating_rank
    FROM Products AS p
    JOIN ProductRatings AS pr ON p.product_id = pr.product_id
)


SELECT -- Retrieve the products with the highest average rating
    product_id,
    product_name,
    average_rating
FROM RankedProducts
WHERE rating_rank = 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Select users who have ordered from all categories
SELECT 
    u.user_id, 
    u.username
FROM 
    Users AS u
WHERE 
    -- Count the distinct categories from which the user has ordered
    (SELECT COUNT(DISTINCT p.category_id)
     FROM Orders AS o
     JOIN Order_Items AS oi ON o.order_id = oi.order_id
     JOIN Products AS p ON oi.product_id = p.product_id
     WHERE o.user_id = u.user_id) =
    -- Compare to the total number of categories available
    (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Select products that have not received any reviews
SELECT p.product_id, p.product_name
FROM Products AS p
LEFT JOIN Reviews AS r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Create a CTE to retrieve the users who have made orders on consecutive days
WITH OrderedUsers AS ( 
    SELECT
        u.user_id,
        u.username,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS previous_order_date
    FROM
        Orders AS o
    JOIN Users AS u ON o.user_id = u.user_id
)
 
SELECT DISTINCT -- Select users who have made consecutive orders on consecutive days
    user_id,
    username
FROM
    OrderedUsers
WHERE
    order_date = DATE(previous_order_date, '+1 day');


