-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Purpose: Retrieve the products with the highest average rating
-- This query joins products and reviews, grouping records on product_id and averaging ratings upon aggregation.
-- Option 1: using join
SELECT
    `products`.`product_id`,
    `products`.`product_name`,
    AVG(`rating`) AS `average_rating`
FROM `products`
JOIN `reviews` ON `products`.`product_id` = `reviews`.`product_id`
GROUP BY `products`.`product_id`
ORDER BY `average_rating` DESC;
-- LIMIT 1; -- Optionally to retrieve the highest record

-- Option 2: using subqueries
SELECT 
	`products`.`product_id`,
    `products`.`product_name`,
    (
		SELECT AVG(`reviews`.`rating`)
		FROM `reviews`
		WHERE `reviews`.`product_id` = `products`.`product_id`
	) AS `average_rating`
FROM `products`
ORDER BY `average_rating` DESC;
-- LIMIT 1; -- Optionally to retrieve the highest record


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Purpose: Retrieve users with one or more orders in every single category
-- This query joins users and orders based on user_id, then joins orders and order_items on order_id,
-- then joins order_items and products on product_id. Later groups them by user_id given that the count of
-- distinct products bought by the user are equal to every category that exists.
SELECT `users`.`user_id`, `users`.`username` FROM `orders`
JOIN `users` ON `orders`.`user_id` = `users`.`user_id`
JOIN `order_items` ON `orders`.`order_id` = `order_items`.`order_id`
JOIN `products` ON `order_items`.`product_id` = `products`.`product_id`
GROUP BY `orders`.`user_id`
HAVING COUNT(DISTINCT `products`.`category_id`) = (
	SELECT COUNT(*) FROM `categories`
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Purpose: Retrieve information on products which have yet to receive a review
-- This query, subqueries through product reviews grouped by product_id and filtered on the count of reviews.
SELECT `product_id`, `product_name` FROM `products`
WHERE `product_id` IN (
	SELECT `product_id` FROM `reviews`
	GROUP BY `product_id` HAVING COUNT(`product_id`) > 0
);


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Purpose: Retrieve users that made orders in at least two consecutive days
-- This query builds a table with order days and the previous order days using LAG.
-- Then, it grabs distinct users where the difference between the two columns is one day.

WITH `ConsecutiveOrders` AS (
    SELECT
        `user_id`,
        `order_date`,
        LAG(`order_date`) OVER (PARTITION BY `user_id` ORDER BY `order_date`) AS `prev_order_date`
    FROM
        `orders`
)
SELECT DISTINCT `ConsecutiveOrders`.`user_id`, `users`.`username`
FROM `ConsecutiveOrders`
JOIN `users` ON `ConsecutiveOrders`.`user_id` = `users`.`user_id`
WHERE DATEDIFF(`order_date`, `prev_order_date`) = 1;