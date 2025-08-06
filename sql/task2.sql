-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- retrives the product(s) with the highest average rating

-- defines a product_avg_ratings CTE that contains average ratings for each product
WITH product_avg_ratings AS (
	SELECT
		p.product_id,
		p.product_name,
		-- AVG aggregate function to calculate the average rating for each product
		AVG(r.rating) AS avg_rating
	FROM
		products p
    -- RIGHT JOIN to only keep the products with an average rating
	RIGHT JOIN reviews r ON p.product_id = r.product_id
GROUP BY
	p.product_id
)
SELECT
	product_id,
	product_name,
	avg_rating
FROM
	product_avg_ratings
	-- filters all products WHERE the avg_rating is equal to the highest average rating found in product_avg_ratings
WHERE
	avg_rating = (
        -- subquery to get the max average rating overall
		SELECT
			MAX(avg_rating)
		FROM
			product_avg_ratings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- retrieves the user ids and usernames of the users who have made at least one order in each category
SELECT
    u.user_id,
    u.username
FROM
    users u
-- joins to ultimately get the products each user has bought
JOIN orders o ON u.user_id = o.user_id
JOIN order_Items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY
    u.user_id
-- filters for the rows where the number of distinct product catgories a user has bought equals the total number of categories
HAVING
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- retrives all product ids and names that do not have an associated review
SELECT
  p.product_id,
  p.product_name
FROM
  products p
-- WHERE NOT EXISTS used to only keep the products with no reviews
WHERE
  NOT EXISTS (
    -- subquery used to check if there is at least one review for the current product
    SELECT
      1
    FROM
      reviews r
    WHERE
      r.product_id = p.product_id
  );

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Retrieves the user ids and usernames of users who have made consecutive orders on consecutive days

-- SELECT DISTINCT to avoid having the same user twice in the result
-- needed since for example, a 3 day span will include multiple consecutive days
SELECT DISTINCT
	u.user_id,
	u.username
FROM (
    -- subquery to retrieve user_id, order_date, and the next_order_date for each order
	SELECT
		o.user_id,
		o.order_date,
        -- LEAD window function to get the next_order_date
		LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
	FROM
		orders o) AS sub
	JOIN users u ON sub.user_id = u.user_id
-- Filtering the results to include only the users who have made consecutive orders on consecutive days
WHERE
	sub.order_date = sub.next_order_date - INTERVAL '1 day';