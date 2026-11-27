-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- We cannot use order total_amount, of course, because that one is across different order items, i.e. potentially different categories.
-- Hence we must drill down to the individual order items.
SELECT TOP 3 c.category_id, c.category_name, SUM(i.quantity * i.unit_price) total_amount
FROM Order_Items i
JOIN Products p ON p.product_id = i.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_amount DESC

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This should be similar to problem 6 in task 2.
; WITH c AS (
	SELECT category_id
	FROM Categories
	WHERE category_name = 'Toys & Games'
), p AS (
	SELECT COUNT(*) product_count
	FROM Products p
	JOIN c ON c.category_id = p.category_id
), u AS (
	-- Users linked to categories like this: Users -> Orders -> Order_Items -> Products -> Categories
	-- This CTE returns all the users that purchased anything in the Toy & Games category along with the product id. Duplicates are squashed.
	SELECT u.user_id, u.username, p.product_id
	FROM Users u
	JOIN Orders o ON u.user_id = o.user_id
	JOIN Order_Items i ON i.order_id = o.order_id
	JOIN Products p ON i.product_id = p.product_id
	JOIN c on p.category_id = c.category_id
	GROUP BY u.user_id, u.username, p.product_id
), u2 AS (
	-- Grouping by the user id and name allows us to count the different rows in each group. Which gives the product count per each user.
	SELECT user_id,username,COUNT(*) product_count
	FROM u
	GROUP BY user_id, username
)
SELECT user_id, username
FROM u2
-- Finally return only those users whose product count equals the number of products in the Toys & Games category. Meaning they bought from all the products.
JOIN p ON u2.product_count = p.product_count


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

;WITH m AS (
	SELECT MAX(price) max_price, category_id
	FROM Products
	GROUP BY category_id
)
SELECT product_id, product_name, p.category_id, price
FROM Products p
JOIN m ON p.price = m.max_price AND p.category_id = m.category_id

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Should be similar to problem 8
;WITH o AS (
	-- Using the LEAD window function we are adding a new column which is the order_date of the next row, where next is defined as follows:
	-- 1. Order all the rows by user_id AND then by order_date
	-- 2. The next row is taken in that order (user_id, order_date)
	-- 3. However, if the next row belongs to a new user_id (i.e. it is in the next partition), then next returns NULL.
	-- 4. Unlike the problem 8 we want 3 consecutive days, so add a second field showing the order_date of the next to the next record with the partition, of course.
	SELECT *,
		LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) next_order_date,
		LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) next_order_date_2
	FROM Orders
), u2 AS (
	-- All the rows with non NULL in next_order_date AND where the difference between the order_date and next_order_date is 1 correspond to orders by the same user
	-- on two consecutive days. Must group, because the same user may purchase on 3 consecutive days, which would return 2 records. We need just one.
	-- In addition, check that the next to the next record has order_date in 2 days from the current. This way we get 3 consecutive, instead of 2.
	SELECT user_id
	FROM o
	WHERE DATEDIFF(day, order_date, next_order_date) = 1 AND DATEDIFF(day, order_date, next_order_date_2) = 2
	GROUP BY user_id
)
SELECT u2.user_id,u.username
FROM u2
JOIN Users u ON u2.user_id = u.user_id
