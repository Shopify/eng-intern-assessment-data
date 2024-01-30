-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT 
    product_id, 
    product_name, 
    AVG(rating) AS average_rating
FROM Products 
    LEFT JOIN Reviews USING (product_id)
GROUP BY product_id, product_name
ORDER BY average_rating DESC 
LIMIT 5;



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Method: We can count total categories and all the categories a user buys from
-- By comparing this, we can see if the user has at min purchases from each cat or not

WITH
Categories_count AS (
	SELECT COUNT(DISTINCT category_id) as category_count
  	FROM Categories
),
user_order_counts AS (
	SELECT user_id, username, COUNT(DISTINCT category_id) AS tmp, category_count
  	FROM Users
  		LEFT JOIN Orders USING(user_id)
     	LEFT JOIN Order_Items USING(order_id)
  		LEFT JOIN Products USING(product_id)
  		LEFT JOIN Categories_count
  	GROUP BY user_id, username
)

SELECT *
FROM user_order_counts
WHERE category_count == tmp;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT product_id, product_name
FROM Products LEFT JOIN Reviews USING (product_id) --We get all product
WHERE review_id IS NULL ;-- After left join, if the review_id is null it has no review

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- needs more work
WITH 
tmp AS (
SELECT 
	user_id, 
    username, 
    order_date,
    LEAD(order_date) OVER (PARTITION BY user_id 
                           ORDER BY order_date) AS next_date
FROM Orders LEFT JOIN Users using (user_id)
  )
  
SELECT user_id, username
FROM tmp
where julianday(next_date) - julianday(order_date) = 1;