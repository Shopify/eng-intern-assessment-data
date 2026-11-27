-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


-- Solution: Didn't need to do the things hinted at, but it wasn't clear whether you wanted top n rated,
-- so I assumed we just needed to sort from highest-lowest (like a sort on an e-commerce page!)
SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) FROM Reviews INNER JOIN Products ON Reviews.product_id = Products.product_id GROUP BY Products.product_id ORDER BY AVG(Reviews.rating) DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.


-- Solution: This one was a bit tougher, I had to use the HAVING keyword to filter results based on the number of DISTINCT category ids
SELECT Users.user_id, Users.username
FROM Users, Orders, Order_Items, Products, Categories WHERE 
Users.user_id = Orders.user_id 
AND Orders.order_id = Order_Items.order_id 
AND Products.product_id = Order_Items.product_id
GROUP BY Users.user_id
HAVING COUNT(DISTINCT Products.category_id) >= COUNT(DISTINCT Categories.category_id);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.


--Solution: Similar to last time, using the HAVING keyword to filter rows by criteria.
SELECT Products.product_id, Products.product_name FROM Products LEFT JOIN Reviews ON Products.product_id = Reviews.product_id GROUP BY Products.product_id HAVING COUNT(Reviews.review_id) = 0;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


--Solution: Used LAG() to find the date of the previous order of a given user (if it exists), then did a conditional select to filter for a date difference of 1
WITH Last_Order AS 
(
	SELECT Users.user_id, Users.username, Orders.order_date, LAG(Orders.order_date) OVER (PARTITION BY Orders.user_id ORDER BY Orders.order_date) AS last_order_date 
	FROM Users, Orders WHERE Users.user_id = Orders.user_id
) SELECT user_id, username FROM Last_Order WHERE JULIANDAY(order_date) - JULIANDAY(last_order_date) = 1 GROUP BY user_id