-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
SELECT c.category_id, c.category_name, SUM(oi.quantity*oi.unit_price) AS total_sales_amount
FROM order_items AS oi
JOIN products AS p ON p.product_id = oi.product_id
JOIN categories AS c ON c.category_id = p.category_id
GROUP BY c.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
SELECT u.user_id, u.username
FROM orders AS o
JOIN users AS u ON o.user_id = u.user_id
WHERE NOT EXISTS (
    SELECT product_id
    FROM products
    WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Toys & Games')
      AND product_id NOT IN (SELECT product_id FROM order_items WHERE order_id = o.order_id)
);


-- Problem 11: Retrieve the products that have the highest price within each category
WITH RankedProducts AS (
  SELECT
    p.product_id,
    p.product_name,
    p.price,
    c.category_id,
    ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY p.price DESC) AS prodRank FROM
    products AS p
    JOIN categories AS c ON c.category_id = p.category_id
)
SELECT
  product_id,
  product_name,
  price
FROM
  RankedProducts
WHERE
  prodRank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
SELECT user_id, username
FROM (
    SELECT
        u.user_id,
        u.username,
        COUNT(o.order_id) as num_consecutive_dates
    FROM
        users u
        JOIN orders o ON u.user_id = o.user_id
        JOIN orders prev_o ON u.user_id = prev_o.user_id AND o.order_date = prev_o.order_date + INTERVAL 1 DAY
    GROUP BY
        u.user_id, u.username, o.order_date
) AS Subquery
WHERE num_consecutive_dates >= 3;
