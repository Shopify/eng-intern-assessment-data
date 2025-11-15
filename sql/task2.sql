-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Problem 5 --
SELECT DISTINCT review_data.product_id, product_data.product_name, AVG(rating) FROM review_data
INNER JOIN product_data
    ON review_data.product_id = product_data.product_id
GROUP BY review_data.product_id, product_data.product_name -- Group rating by the product
HAVING AVG(rating) = 	(SELECT max(average_rating) FROM (SELECT review_data.product_id, AVG(rating) AS average_rating
						FROM review_data
						GROUP BY review_data.product_id) AS max_rating); -- If there is more than 1 product with the highest rating,
                                                                         -- ensure that all the products with the highest rating are retrieved

-- Problem 6 --
SELECT DISTINCT user_data.user_id, user_data.username FROM user_data
WHERE NOT EXISTS    (SELECT category_id FROM category_data
					WHERE NOT EXISTS (SELECT 1 FROM order_data
                    JOIN order_items_data ON order_data.order_id = order_items_data.order_id
                    JOIN product_data ON order_items_data.product_id = product_data.product_id
					WHERE order_data.user_id = user_data.user_id AND product_data.category_id = category_data.category_id -- Check if user has made one order in every category
                                                                                                                          -- If one category is missing, do not include in the result.
            )
    );

-- Problem 7 --
SELECT product_data.product_id, product_data.product_name FROM product_data
WHERE NOT EXISTS (SELECT 1 FROM review_data
                    WHERE review_data.rating IS NOT NULL AND review_data.product_id = product_data.product_id); -- Check to see if product has a review. If it does, it is not included in the result.

-- Problem 8 --
WITH previous_order_data AS 
(SELECT user_data.user_id, user_data.username, order_data.order_date, LAG(order_data.order_date) OVER (PARTITION BY user_data.user_id ORDER BY order_data.order_date) 
AS previous_order_date FROM user_data
JOIN order_data ON user_data.user_id = order_data.user_id) -- Create table with user_id, username, order_date, and previous order date, where the order dates witll be compared

SELECT DISTINCT user_id, username FROM previous_order_data
WHERE DATEDIFF(order_date, previous_order_date) = 1 AND previous_order_date IS NOT NULL; -- If the user's order date and previous order date have a 1 day difference, include the user in the result
