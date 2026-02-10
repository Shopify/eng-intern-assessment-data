-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT product_id, product_name, avgRating
FROM (
    SELECT products.product_id, product_name, AVG(rating) AS avgRating, RANK() OVER (ORDER BY AVG(rating) DESC) AS ratingRank -- Use RANK to find the products with the highest ratings
    FROM products
    JOIN reviews
    ON products.product_id = reviews.product_id -- Inner join on product_id
    GROUP BY products.product_id
) avg_data
WHERE ratingRank = 1; -- Limit to products ranked 1 ie. having the highest average rating

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT users.user_id, username
FROM users
JOIN orders
ON users.user_id = orders.user_id -- Inner join orders on user_id
JOIN order_items
ON orders.order_id = order_items.order_id -- Inner join order_items on order_id
JOIN products
ON order_items.product_id = products.product_id -- Inner join products on product_id - this excludes records in the order_items table that reference products not listed in the products table
GROUP BY users.user_id, username
HAVING COUNT(DISTINCT products.category_id) = (SELECT COUNT(DISTINCT category_id) FROM products); -- Limit results to users with an order in each of the categories listed in the products table, alternatively could use all categories in the categories table but most of them do not have an associated product
-- Only the first 16 order_items entries refer to products listed in the products table and therefore have a category_id
-- The 16 products in the products table fall into 8 of the categories, so I checked for whether their orders contained each of the category ids listed in the products table
-- None of the users have an order from each of the 8 categories

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT products.product_id, product_name, rating
FROM products
LEFT JOIN reviews
ON products.product_id = reviews.product_id -- Left join so all products are kept, join on product_id
WHERE rating IS NULL; -- Filter for products without a rating
-- There are no products without a rating in the given dataset, however there are many reviews that reference products not found in the products table

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT user_id, username
FROM (
    SELECT users.user_id, username, order_date, LAG(order_date) OVER(PARTITION BY users.user_id ORDER BY order_date) AS prevOrderDate -- LAG returns the previous order date for each user
    FROM users
    JOIN orders
    ON users.user_id = orders.user_id -- Inner join on user_id
) consecutive_dates
WHERE DATEDIFF(order_date, prevOrderDate) = 1 -- Check for users with an order one day prior to the current record
GROUP BY user_id, username; -- Group by user_id and username so only a single record is returned for each user
-- None of the users in the given dataset had consecutive orders on consecutive days.