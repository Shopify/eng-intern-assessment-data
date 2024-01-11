-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Query to retrieve the top 3 categories with the highest total sales amount.
-- Includes the category ID, category name, and the total sales amount.

SELECT c.category_id, c.category_name, SUM(oi.quantity * p.price) AS total_sales_amount
FROM category_data c
JOIN product_data p ON c.category_id = p.category_id
JOIN order_items_data oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Query to retrieve the users who have placed orders for all products in a specific category.
-- Includes the user ID and username.
-- Replace Specific Category ID with actual category id.

SELECT u.user_id, u.username
FROM user_data u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM product_data p
    WHERE p.category_id = [Specific Category ID]
    AND NOT EXISTS (
        SELECT oi.order_id
        FROM order_items_data oi
        JOIN order_data o ON oi.order_id = o.order_id
        WHERE o.user_id = u.user_id AND oi.product_id = p.product_id
    )
);

-- Example for category_id = 2:

SELECT u.user_id, u.username
FROM user_data u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM product_data p
    WHERE p.category_id = 2
    AND NOT EXISTS (
        SELECT oi.order_id
        FROM order_items_data oi
        JOIN order_data o ON oi.order_id = o.order_id
        WHERE o.user_id = u.user_id AND oi.product_id = p.product_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Query to retrieve the products that have the highest price within each category.
-- Includes the product ID, product name, category ID, and price.

WITH MaxPriceProducts AS (
    SELECT product_id, product_name, category_id, price,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM product_data
)
SELECT product_id, product_name, category_id, price
FROM MaxPriceProducts
WHERE rn = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- Includes the user ID and username.

WITH ConsecutiveOrders AS (
    SELECT user_id, order_date,
           LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
           LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM order_data
)
SELECT DISTINCT user_id
FROM (
    SELECT user_id,
           CASE 
               WHEN order_date = prev_order_date + INTERVAL '1 DAY' 
                    AND order_date = next_order_date - INTERVAL '1 DAY' THEN 1
               ELSE 0
           END AS is_consecutive
    FROM ConsecutiveOrders
) sub
WHERE is_consecutive = 1
GROUP BY user_id
HAVING COUNT(*) >= 3;
