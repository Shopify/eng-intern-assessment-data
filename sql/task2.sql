-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Select product id, name, and average rating.
SELECT pr.product_id, pr.product_name, 
-- Calculate average rating
AVG(re.rating) AS average_rating
-- Join review_data with product_data and match product_id in both tables.
FROM product_data pr JOIN review_data re ON pr.product_id = re.product_id
-- Group results by product id and name.
GROUP BY pr.product_id, pr.product_name
-- Filter results to show only products with the highest average rating
HAVING AVG(re.rating) = (
-- Create a subquery to find the highest average rating among each product.
	SELECT MAX(average_rating) FROM (
    -- Calculate average rating for each product.
    SELECT AVG(rating) AS average_rating FROM review_data GROUP BY product_id
    )
    AS SubQuery
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Select user ID and username.
SELECT us.user_id, us.username FROM user_data us
-- Join order_data with user_data.
JOIN order_data ord ON us.user_id = ord.user_id
-- Join order_items_data with order_data.
JOIN order_items_data oid ON ord.order_id = oid.order_id
-- Join prudct_data with order_items_data.
JOIN product_data pr ON oid.product_id = pr.product_id
-- Group results by user_id and username.
GROUP BY us.user_id, us.username
-- Filter results to only show user who have ordered at least once in each category.
HAVING COUNT(DISTINCT pr.category_id) = (
-- Create a subquery to count the total number of distinct categories
    SELECT COUNT(*) FROM category_data
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Select product_id and product_name
SELECT pr.product_id, pr.product_name FROM product_data pr
-- Do a left join with review_data on product_id
LEFT JOIN review_data re ON pr.product_id = re.product_id
-- Filter results to show only products without any reviews.
WHERE re.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Select distinct user_ids and usernames.
SELECT DISTINCT us.user_id, us.username FROM user_data us
-- Join order_data with user_data
JOIN order_data or1 ON us.user_id = or1.user_id
-- Join order_data with user_data again.
JOIN order_data or2 ON us.user_id = or2.user_id
-- Filter results to only show order dates that are consecutive.
WHERE DATE(or1.order_date) = date_add(date(or2.order_date), interval 1 day)
OR DATE(or2.order_date) = date_add(date(or1.order_date), interval 1 day);
