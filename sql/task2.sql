-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

--Using outer join since need average rating
WITH avg_rating AS (
    SELECT
        product_id,
        AVG(rating) AS avg_rating
    FROM
        reviews
    GROUP BY
        product_id
)
-- this gives us the average rating for each product
SELECT
    p.product_id,
    p.product_name,
    avg_rating.avg_rating
FROM
    products p
JOIN
    avg_rating ON p.product_id = avg_rating.product_id
WHERE
    avg_rating.avg_rating = (
        -- get maximum average rating to match to the where clause
        SELECT
            MAX(avg_rating)
        FROM
            avg_rating
    );


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- CTE to get total number of categories
WITH total_categories AS (
    SELECT 
        COUNT(DISTINCT category_id) AS total_categories 
    FROM 
        categories
)   

-- Will only return users who have made at least one order in each category as their count of distinct categories will match the total number of categories
-- Need to join with order_items and products to get the category_id for each order
SELECT 
    u.user_id, 
    u.username    
FROM 
    users u    
JOIN 
    orders o ON u.user_id = o.user_id  
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    u.user_id, 
    u.username
HAVING 
    COUNT(DISTINCT p.category_id) = (SELECT total_categories FROM total_categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.


-- DISTINCT to get only unique product IDs
-- CTE was not necessary here but used for readability
WITH reviewed_products AS (
    SELECT DISTINCT product_id
    FROM reviews
)

-- LEFT JOIN is used to get all the products that have not received any reviews
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN reviewed_products rp ON p.product_id = rp.product_id
WHERE rp.product_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


-- CTE to identify consecutive orders for each user
WITH consecutive_orders AS (
    SELECT
        o.user_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS previous_order_date
    FROM
        Orders o
)
-- Retrieve users who have made consecutive orders on consecutive days using datediff

SELECT
    u.user_id,
    u.username
FROM
    Users u
JOIN
    consecutive_orders co ON u.user_id = co.user_id
WHERE
    DATEDIFF(day, co.previous_order_date, co.order_date) = 1
   ;

