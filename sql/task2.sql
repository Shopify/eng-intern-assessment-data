-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT 
    product_id, 
    product_name, 
    COALESCE(AVG(rating), 0) AS average_rating      -- Group by products and use agg functions to get average rating
FROM Products                                       -- COALESCE is used to replace null rating values with 0
    LEFT JOIN Reviews USING (product_id)            -- LEFT JOIN is used to get all products even if they have no reviews
GROUP BY product_id, product_name
ORDER BY average_rating DESC 
LIMIT 5;                                            -- We only want the top 5 products

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Methodology:
-- We can count the distinct categories and the distinct categories a user has bought from
-- Then by comparing these counts we can see if any user has bought from all categories or not
-- Thereby implying that they have made at least one order in each category

WITH
Total_Category_Counts AS (
	SELECT COUNT(DISTINCT category_id) as category_count
  	FROM Categories
),
User_Category_Counts AS (
	SELECT 
        user_id,                                    -- We group by the user and then proceed to count
        username,                                   -- The categories of their orders
        COUNT(DISTINCT category_id) AS user_order_category_count, 
        category_count
  	FROM Users                                      -- Inner join all relevant tables
  		INNER JOIN Orders USING(user_id)            -- Since we need all tables to answer the question
     	INNER JOIN Order_Items USING(order_id)
  		INNER JOIN Products USING(product_id)
  		LEFT JOIN Total_Category_Counts             -- All joins are explicit (i.e., no 'JOIN' to avoid confusion)
  	GROUP BY user_id, username
)
SELECT user_id, username
FROM User_Category_Counts
WHERE category_count == user_order_category_count;  -- We only want users who have bought from all categories

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT product_id, product_name
FROM Products 
    LEFT JOIN Reviews USING (product_id)            -- Left join to get all products even if they have no reviews
WHERE review_id IS NULL;                            -- To get products with no reviews, we check if review_id is null

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Methodology:
-- To get consecutive orders on consecutive days, we can use the LEAD function to store the next
-- order date. By doing so we can compute the difference, which must be a 1 day difference to be
-- considered consecutive.

WITH 
Next_Day_Orders AS (
SELECT 
	user_id, 
    username, 
    order_date,                                     -- LEAD is used to get the next order date using a
    LEAD(order_date)                                -- window function
        OVER (PARTITION BY user_id ORDER BY order_date) 
        AS next_date
FROM Orders                                         -- Select all orders and inner join since we need
    INNER JOIN Users using (user_id)                -- to get which user made the order
)
  
SELECT user_id, username                            -- To ensure the day is consecutive, we check if the
FROM Next_Day_Orders                                -- difference between the next date and the current is 1
where julianday(next_date) - julianday(order_date) = 1;