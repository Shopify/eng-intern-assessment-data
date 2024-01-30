-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
;WITH r AS (
	-- Identical to problem 3 in task 1
	SELECT product_id,AVG(rating) average_rating
	FROM Reviews
	GROUP BY product_id
), rmax AS (
	SELECT MAX(average_rating) max_average_rating
	FROM r
)
SELECT p.product_id, p.product_name, average_rating
FROM products p
JOIN r ON p.product_id = r.product_id
JOIN rmax ON average_rating = max_average_rating -- This is added to the problem 3 in task 1 to further exclude all except the max average rating
ORDER BY average_rating DESC

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Here we have a problem. A lot of order items (~50%) correspond to non existing products. This is because the FK from Order_Items to Products is unchecked.
-- It could be argued that this orders correspond to discontinued products, but those should still be in the database.
-- In any case, without a valid product record we have no idea what is the category of that product. These records will be discarded, which is a shame, because there
-- are so many of them:
; WITH c AS (
	SELECT COUNT(*) category_count
	FROM Categories
), u AS (
	-- Users linked to categories like this: Users -> Orders -> Order_Items -> Products -> Categories
	-- This CTE returns all the users that purchased anything in any category along with the category id. Duplicates are squashed.
	SELECT u.user_id, u.username, c.category_id
	FROM Users u
	JOIN Orders o ON u.user_id = o.user_id
	JOIN Order_Items i ON i.order_id = o.order_id
	JOIN Products p ON i.product_id = p.product_id
	JOIN Categories c on p.category_id = c.category_id
	GROUP BY u.user_id, u.username, c.category_id
), u2 AS (
	-- Grouping by the user id and name allows us to count the different rows in each group. Which gives the category count per each user.
	SELECT user_id,username,COUNT(*) category_count
	FROM u
	GROUP BY user_id, username
)
SELECT user_id, username
FROM u2
-- Finally return only those users whose category count equals the number of categories. Meaning they bought from all the categories.
JOIN c ON u2.category_count = c.category_count


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.product_id IS NULL

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- "consecutive orders on consecutive days" - what does it mean "consecutive orders" ? In a real world with a lot of concurrent orders 
-- I do not believe two orders from the same user will have consecutive ids. I will solve this question to find all the users that made orders on consecutive days, i.e.
-- 2 or more days in a row.
-- On the other hand, this is an exercise and everything is possible. So, will try to provide both variants

-- Consecutive days only
;WITH o AS (
	-- Using the LEAD window function we are adding a new column which is the order_date of the next row, where next is defined as follows:
	-- 1. Order all the rows by user_id AND then by order_date
	-- 2. The next row is taken in that order (user_id, order_date)
	-- 3. However, if the next row belongs to a new user_id (i.e. it is in the next partition), then next returns NULL.
	SELECT *,LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) next_order_date
	FROM Orders
), u2 AS (
	-- All the rows with non NULL in next_order_date AND where the difference between the order_date and next_order_date is 1 correspond to orders by the same user
	-- on two consecutive days. Must group, because the same user may purchase on 3 consecutive days, which would return 2 records. We need just one.
	SELECT user_id
	FROM o
	WHERE DATEDIFF(day, order_date, next_order_date) = 1
	GROUP BY user_id
)
SELECT u2.user_id,u.username
FROM u2
JOIN Users u ON u2.user_id = u.user_id

-- Consecutive orders on consecutive days - seems very similar, only we need two LEAD columns and the sorting should include order_id:
;WITH o AS (
	SELECT *,
		LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_id, order_date) next_order_date,
		LEAD(order_id) OVER (PARTITION BY user_id ORDER BY order_id, order_date) next_order_id
	FROM Orders
), u2 AS (
	SELECT user_id
	FROM o
	WHERE DATEDIFF(day, order_date, next_order_date) = 1 AND next_order_id - order_id = 1
	GROUP BY user_id
)
SELECT u2.user_id,u.username
FROM u2
JOIN Users u ON u2.user_id = u.user_id