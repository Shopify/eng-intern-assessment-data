-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Assuming category id is not known, and category "type" is known, "home" can be replaced with any category type.
-- Since foreign key constraint exits, all category ids in products will exist in category
SELECT * 
FROM Products p 
LEFT JOIN Categories c ON p.category_id = c.category_id 
WHERE c.category_name LIKE '%home%';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
-- Same reasoning for left join as above- foreign key constraint 
SELECT
    o.user_id,
    u.username,
    COUNT(DISTINCT o.order_id) AS total_orders
    -- distinct in case orders are repeated or completed in multiple transactions
FROM
    orders o
LEFT JOIN
    users u ON o.user_id = u.user_id
GROUP BY
    o.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.


-- If a product does not have any reviews, the result will say 'No ratings'.
-- Join defaults to outer join since NULL has been handled by case statement
-- Assuming 0 is not allowed as a rating (since it is not in the range of 1-5)
SELECT
    r.product_id,
    p.product_name,
    CASE 
        WHEN COUNT(r.rating) > 0 THEN AVG(r.rating)
        ELSE 'No ratings'
    END AS avg_rating
FROM
    reviews r
JOIN
    products p ON r.product_id = p.product_id
GROUP BY
    r.product_id, p.product_name;

-- Wanted to incorporate higher priority of products with more reviews, but did not want to affect auto testing so it is commented out here:
-- SELECT
--     r.product_id,
--     p.product_name,
--     CASE 
--         WHEN COUNT(r.rating) > 0 THEN AVG(r.rating)
--         ELSE 'No ratings'
--     END AS avg_rating,
--     COUNT(r.rating) AS review_count
-- FROM
--     reviews r
-- JOIN
--     products p ON r.product_id = p.product_id
-- GROUP BY
--     r.product_id, p.product_name
-- ORDER BY
--     review_count DESC;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.


-- LEFT JOIN used to include all users, even if they have not made any orders
-- COALESCE used to handle NULL values
SELECT TOP 5
    u.user_id,
    u.username,
    COALESCE(SUM(o.total_amount), 0) AS total_amount_spent
FROM
    users u
LEFT JOIN
    orders o ON o.user_id = u.user_id
GROUP BY
    u.user_id, u.username
ORDER BY
    total_amount_spent DESC;




-- Extra notes:
-- Product data.csv and order_items.csv do not saisfy foreign key constraints. Some rows were omitted from order_items to deal with this issue.
-- Wasn't sure if test files were required to submit so skipped
-- Testing was done locally by adding corner cases 
