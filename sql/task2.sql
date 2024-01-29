-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT
    P.product_id,
    P.product_name,
    AVG(r.rating) AS average_rating
FROM
    products P
    JOIN reviews R ON P.product_id = R.product_id
GROUP BY
    P.product_id,
    P.product_name
ORDER BY
    average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    P.product_id,
    P.product_name
FROM
    products P
    LEFT JOIN reviews R ON P.product_id = R.product_id
WHERE
    R.product_id IS NULL
    AND P.product_id IS NOT NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.