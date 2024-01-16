-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Purpose: Retrieve all products in the Sports (Sports & Outdoors) category
-- This query, sub-queries categories containing the word "sport" and finds products with those category_id.
SELECT * FROM `products`
WHERE `category_id` IN (
    SELECT `category_id` FROM `categories`
    WHERE `category_name` LIKE '%sport%'
);


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Purpose: Retrieve information about users and their number of orders
-- This query joins the orders and users, then groups the data on user_id.
SELECT `users`.`user_id`,
       `users`.`username`,
        COUNT(`orders`.`order_id`) AS `total_orders`
FROM `users`
JOIN `orders` ON  `users`.`user_id` = `orders`.`user_id`
GROUP BY (`users`.`user_id`) ;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Purpose: Retrieve information about average rating for each product
-- This query joins products and reviews, then groups the products calcualting each products average rate.
SELECT
    `products`.`product_id`,
    `products`.`product_name`,
    AVG(`reviews`.`rating`) AS `average_rating`
FROM `products`
JOIN `reviews` ON `products`.`product_id` = `reviews`.`product_id`
GROUP BY `products`.`product_id`;



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
-- Purpose: Retrieve information about user with highest total order amounts. We assume orders here
-- means combination of all orders (considering each user might have had more than one order)
-- This query joins users and orders, groups data by user_id and sums the total_amount upon aggregation.
-- At the end orders the records by total_amount_spent in desceding order and only shows first 5 records.
SELECT
    `users`.`user_id`,
    `users`.`username`,
    SUM(`total_amount`) AS `total_amount_spent`
FROM `users`
JOIN `orders` ON `users`.`user_id` = `orders`.`user_id`
GROUP BY `users`.`user_id`
ORDER BY `total_amount_spent` DESC
LIMIT 5;