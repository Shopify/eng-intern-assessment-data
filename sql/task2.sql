-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH Product_Avg_Ratings AS (
    SELECT 
        rev.product_id, 
        AVG(rev.rating) AS avg_rating 
    FROM 
        Reviews rev 
    GROUP BY 
        rev.product_id
)
SELECT 
    prd.product_id, 
    prd.product_name, 
    par.avg_rating 
FROM 
    Products prd
JOIN 
    Product_Avg_Ratings par 
ON 
    par.product_id = prd.product_id
WHERE 
    par.avg_rating = (SELECT MAX(avg_rating) FROM Product_Avg_Ratings)
ORDER BY 
    prd.product_id;



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    usr.user_id, 
    usr.username 
FROM 
    Order_Items AS ord_itm
JOIN 
    Products AS prd ON ord_itm.product_id = prd.product_id
JOIN 
    Orders AS ord ON ord_itm.order_id = ord.order_id
JOIN 
    Users AS usr ON ord.user_id = usr.user_id
GROUP BY 
    usr.user_id
HAVING 
    COUNT(DISTINCT prd.category_id) = (
        SELECT 
            COUNT(category_id) 
        FROM 
            Categories
    );



-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT 
    prd.product_id, 
    prd.product_name
FROM 
    Products prd
LEFT JOIN 
    Reviews rev ON prd.product_id = rev.product_id
WHERE 
    rev.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH Order_Intervals AS (
    SELECT 
        usr.user_id,
        ord.order_date - LAG(ord.order_date) OVER (PARTITION BY usr.user_id ORDER BY ord.order_date) AS interval
    FROM 
        Orders ord
    JOIN
        Users usr ON ord.user_id = usr.user_id
)
SELECT DISTINCT 
    oi.user_id, 
    usr.username 
FROM 
    Order_Intervals oi 
JOIN 
    Users usr ON oi.user_id = usr.user_id
WHERE 
    oi.interval = 1;
