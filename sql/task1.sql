-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
DECLARE @Category VARCHAR(255) = 'Sports & Outdoors'
SELECT p.*, c.category_name
FROM Products p
JOIN Categories c ON c.category_id = p.category_id	-- Every product belongs to a category through the respective FK
WHERE c.category_name = @Category

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
;WITH o AS (
	-- This groups all the orders by user_id. The aggregation function simply counts the records in every group, which corresponds to the total order count.
	SELECT user_id, COUNT(*) total_order_count
	FROM orders
	GROUP BY user_id
)
SELECT u.user_id,u.username,o.total_order_count
FROM Users u
-- inner join, will skip those users who have not bought anything. This is because there are no records with total_order_count = 0, because we base it by grouping orders.
JOIN o ON o.user_id = u.user_id

-- If it is important to get those users who have not bought anything, then we need to change the query to use LEFT JOIN and handle NULL as the total order count:
;WITH o AS (
	SELECT user_id, COUNT(*) total_order_count
	FROM orders
	GROUP BY user_id
)
SELECT u.user_id,u.username,ISNULL(o.total_order_count, 0) total_order_count
FROM Users u
LEFT JOIN o ON o.user_id = u.user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
;WITH r AS (
	-- same technique as in the previous question - group reviews by product id, this time the aggregation function computes the average of the rating column in each group
	SELECT product_id,AVG(rating) average_rating
	FROM Reviews
	GROUP BY product_id
)
SELECT p.product_id, p.product_name, average_rating
FROM products p
-- inner join - skips all the products that have no rating. We can use left join if we need to output something for those that have no rating, in this case NULL would be
-- a good choice. So, just add LEFT before JOIN if that is needed.
JOIN r ON p.product_id = r.product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
;WITH o AS (
	-- Almost identical to counting the orders, except the aggregation function sums the total_amount column in each group
	SELECT TOP 5 user_id, SUM(total_amount) total_amount
	FROM orders
	GROUP BY user_id
	ORDER BY total_amount DESC
)
SELECT u.user_id, u.username,total_amount
FROM Users u
-- Inner join, because we are not interested in those who bought nothing.
JOIN o ON u.user_id = o.user_id
ORDER BY total_amount DESC