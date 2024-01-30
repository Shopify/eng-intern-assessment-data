-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, AVG(rating) as average_rating
FROM Products as p LEFT JOIN Reviews as r ON p.product_id  = r.product_id 
GROUP BY p.product_id, p.product_name 
HAVING AVG(rating) = 
#Find the highest average rating 
(SELECT MAX(average_rating) 
FROM (
SELECT p.product_id, p.product_name, AVG(rating) as average_rating
FROM Products as p LEFT JOIN Reviews as r ON p.product_id  = r.product_id 
GROUP BY p.product_id, p.product_name ) AS p1) ;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username, COUNT(DISTINCT p.category_id) as category_count
FROM Users as u LEFT JOIN Orders AS o on u.user_id = o.user_id
	            LEFT JOIN Order_Items as i on o.order_id = i.order_id 
	            LEFT JOIN Products as p on i.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = 
(#retrive all the possible category_id from the Categories table
SELECT COUNT(DISTINCT category_id)
FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name, COUNT(review_id) AS num_review
FROM Products AS p LEFT JOIN Reviews AS r on p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(review_id) = 0;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

#Find the previous order date for each order 
With ConsecutiveOrder AS (
SELECT u.user_id, u.username, o.order_date, LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) as previous_order_date
FROM Users AS u LEFT JOIN Orders AS O ON u.user_id = o.user_id) 

#If the date difference between the order date and the previous order date is equal to 1
# we consider ths user have made orders in consecutive date
SELECT DISTINCT user_id, username 
FROM ConsecutiveOrder
WHERE DATEDIFF(order_date, previous_order_date) = 1;