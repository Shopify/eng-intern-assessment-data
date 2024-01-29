/*
Problem 5: Retrieve the products with the highest average rating
This SQL query retrieves products with the highest average rating.
The output includes the product ID, product name, and the average rating.
A Common Table Expression (CTE) is used to calculate the average ratings first.
*/

-- Create a CTE named Ratings to calculate average ratings for each product
WITH Ratings AS (
    SELECT 
        p.product_id,
        p.product_name,
        ROUND(AVG(r.rating), 2) AS average_rating
    FROM 
        products p
    LEFT JOIN 
        reviews r ON p.product_id = r.product_id
    GROUP BY 
        p.product_id,
        p.product_name
)

-- Main query to select the products with the highest average rating
SELECT 
    product_id,
    product_name,
    average_rating
FROM 
   Ratings
WHERE 
    average_rating = (                           -- Filter to include only products with the highest average rating
		SELECT MAX(average_rating) FROM Ratings  -- Subquery to find the maximum average rating across all products
    );
	


/*
Problem 6: Retrieve the users who have made at least one order in each category
This SQL query identifies users who have placed at least one order in every product category.
The result includes the user ID and username.
The query involves multiple joins and a subquery in the HAVING clause to ensure the user has ordered in all categories.
*/

SELECT 
    u.user_id,
    u.username
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
JOIN 
    order_Items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    u.user_id,
    u.username
-- Filter to include only those users who have ordered in every category	
HAVING 
    -- Count the distinct categories each user has ordered in
    COUNT(DISTINCT p.category_id) = (
	-- The subquery gets the total number of distinct categories
	SELECT COUNT(DISTINCT category_id) FROM categories
	);


/*
Problem 7: Retrieve the products that have not received any reviews
This SQL query identifies products that have not been reviewed yet.
The result includes the product ID and product name.
A LEFT JOIN is used with the reviews table to find products without any matching reviews.
*/

-- Select product ID and product name from the products table
SELECT 
    p.product_id,
    p.product_name
FROM 
    products p
-- Left join with the reviews table on product ID	
LEFT JOIN 
    reviews r ON p.product_id = r.product_id
-- Filter the results to include only those products that have no reviews
WHERE
    r.review_id IS NULL;
     
/*
Problem 8: Retrieve the users who have made consecutive orders on consecutive days
This SQL query identifies users who have placed orders on consecutive days.
The result includes the user ID and username.
The query uses a subquery with a window function to compare each order date with the previous order date for the same user.
*/

-- Use a DISTINCT selection to ensure each user is listed only once
SELECT DISTINCT
    u.user_id,          
    u.username          
FROM 
    -- Create a subquery 'sq' to calculate the previous order date for each order
    (SELECT 
        o.user_id,                                 
        o.order_date,                              
        -- Use LAG window function to get the date of the previous order by the same user
        LAG(o.order_date) OVER (
            PARTITION BY o.user_id        -- Partition by user ID to apply the function within each user's data
            ORDER BY o.order_date                  
        ) as prev_order_date                       
     FROM 
        orders o) as sq                           
-- Join the subquery 'sq' with the users table on user ID
JOIN 
    users u ON sq.user_id = u.user_id
-- Filter to include only records where the order date is exactly one day after the previous order date
WHERE 
    sq.order_date = sq.prev_order_date + INTERVAL '1 day';
