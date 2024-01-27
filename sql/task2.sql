-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
--- As there could be multiple products sharing the highest average rating, we need to use the CTE below.
WITH prod_rating AS (
	SELECT p.product_id,
		   p.product_name,
           AVG(r.rating) AS avg_rating
	FROM Products AS p
	JOIN
		Reviews AS r
	ON
		p.product_id=r.product_id
	GROUP BY p.product_id)
SELECT * FROM prod_rating
WHERE avg_rating=(SELECT MAX(avg_rating) From prod_rating);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

--- CTE Get all category count dynamically --
--- Get unique category purchases by user in the second query
WITH all_category_count AS (
    SELECT COUNT(*) FROM Categories
)
SELECT u.user_id,
	   u.username,
       count(distinct(p.category_id))
FROM Orders AS o
LEFT JOIN
	Users AS u
ON
	u.user_id=o.user_id
LEFT JOIN
	Order_Items as o_i
ON
	o.order_id=o_i.order_id
LEFT JOIN
	Products as p
ON
	o_i.product_id=p.product_id
GROUP BY u.user_id
HAVING
	COUNT(
		DISTINCT(p.category_id))=(
			SELECT * FROM all_category_count
		 );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
---  We can use an anti-join to find products that have not received any reviews.
SELECT * FROM Products as p
LEFT JOIN
	Reviews as r
ON
	p.product_id=r.product_id
WHERE r.product_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
--- Used a window function to partiton data by the user_id and order by date,
--- then with the lag function I got the date of the previous purchase
--- USED the DATEDIFF function to get the filter for consecutive purchases
--- DISTINCT ensures that users who made multiple consecutive orders on consective days are only returned once.
WITH OrderHistory AS (
SELECT
	user_id,
	order_date,
	LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
FROM Orders)
SELECT DISTINCT(u.user_id), u.username FROM OrderHistory as oh
JOIN
	Users as u
ON
	oh.user_id=u.user_id
WHERE DATEDIFF(oh.order_date, oh.prev_order_date) = 1;