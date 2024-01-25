-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT 
    p.product_id,
    p.product_name,
    havg AS average_rating 
FROM 
    shopify.products AS p
JOIN (
    SELECT 
        product_id,
        AVG(rating) AS havg 
    FROM 
        shopify.reviews 
    GROUP BY 
        product_id 
) AS h ON p.product_id = h.product_id 
WHERE 
    havg = (SELECT MAX(havg) FROM (SELECT product_id, AVG(rating) AS havg FROM shopify.reviews GROUP BY product_id) AS max_havg);



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    u.user_id,
    u.username
FROM
    shopify.users as u
JOIN
    shopify.orders as od ON u.user_id = od.user_id
JOIN
   shopify.order_items as oi ON od.order_id = oi.order_id
JOIN
   shopify.products as p ON oi.product_id = p.product_id
GROUP BY
    u.user_id, u.username, p.category_id
HAVING
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM shopify.products);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

Select product_id, product_name from shopify.products where products.product_id not in (select product_id from shopify.reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.



WITH OrderedOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM
        shopify.orders
)

SELECT
    u.user_id,
    u.username
FROM
    shopify.users as u
JOIN
    OrderedOrders oo ON u.user_id = oo.user_id
WHERE
    (DATEDIFF(oo.order_date, oo.prev_order_date) = 1 OR oo.prev_order_date IS NULL)
    AND oo.prev_order_date IS NOT NULL; -- Exclude users with no consecutive orders
