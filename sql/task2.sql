-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AvgRating AS (
    SELECT 
        products.product_id, 
        products.product_name, 
        AVG(rating) AS product_average_rating
    FROM 
        reviews
    JOIN 
        products ON products.product_id = reviews.product_id
    GROUP BY 
        products.product_id
) -- This block of code creates the CTE

SELECT 
    product_id, 
    product_name, 
    product_average_rating
FROM 
    AvgRating
WHERE 
    product_average_rating = (SELECT MAX(product_average_rating) FROM AvgRating); -- get the max value from AvgRating CTE

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    username
FROM 
    users
WHERE (
    SELECT 
        COUNT(DISTINCT category_id) 
    FROM 
        orders 
    JOIN 
        order_items ON order_items.order_id = orders.order_id 
    JOIN 
        products ON order_items.product_id = products.product_id
    WHERE orders.user_id = users.user_id
    )  = 
    
    (SELECT 
        COUNT(DISTINCT category_id) -- check if the user has made at least one order in each category
     FROM 
        categories); 
        
	-- There are no users that have made at least one order in each category!

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT 
    product_id, product_name
FROM 
    products
WHERE 
    product_id NOT IN (
        SELECT 
            product_id
        FROM 
            reviews
    ); -- Used a subquery to retrieve the products without reviews

-- There are no products without reviews!
    
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT 
	ub.user_id, 
    ub.username
FROM (
	SELECT 
		u.user_id, 
        u.username,
		datediff(o.order_date, LAG(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date)) AS difference
	FROM
		users u, orders o
	WHERE 
		u.user_id = o.user_id 
) ub
WHERE 
	ub.difference is not null and ub.difference = 1 -- return if it was a consecutive day