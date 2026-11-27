-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    c.category_id, 
    c.category_name, 
    total_sales
FROM 
    Categories AS c
INNER JOIN 
    (   -- subquery to calculate total sales amount for each category
        SELECT 
            p.category_id, 
            SUM(order_item.quantity * order_item.unit_price) AS total_sales
        FROM 
            Products AS p
        INNER JOIN 
            Order_Items AS order_item ON p.product_id = order_item.product_id
        GROUP BY 
            p.category_id
    ) AS ps ON c.category_id = ps.category_id
ORDER BY 
    total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    user_id, 
    username
FROM
    Users AS u
WHERE NOT EXISTS ( - checks if there are any products in the "Toys & Games" category that were not ordered by that user.
        SELECT 
            p.product_id
        FROM 
            Products AS p
        WHERE
            NOT EXISTS ( -- checks if each product has any associated orders from that user. If there are no orders found, it means the user has not ordered that product.
                SELECT -- subquery to retrieve the order_id for each product
                    oi.order_id
                FROM 
                    Order_Items AS oi
                INNER JOIN 
                    Orders AS o ON oi.order_id = o.order_id
                WHERE 
                    oi.product_id = p.product_id
                    AND o.user_id = u.user_id
            )
            AND p.category_id = ( -- subquery to retrieve the category_id for Toys & Games
                SELECT 
                    category_id
                FROM 
                    Categories
                WHERE 
                    category_name = 'Toys & Games'
            )
    );


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH CategoryPriceRank AS ( -- performs a ranking of products per category based on price in descending order. So the highest priced product in each category gets a rank of 1.
   SELECT p.product_id, 
          p.product_name,
          p.category_id,
          p.price,
          RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS rk
   FROM Products p
)
SELECT c.product_id, 
       c.product_name,
       c.category_id,
       c.price
FROM CategoryPriceRank c
WHERE c.rk = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderDateRank AS ( --calculating and assigning a rank based on order_date within each user partition
    SELECT 
        o.user_id,
        o.order_date,
        RANK() OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS rk
    FROM Orders o
)

SELECT 
    u.user_id,
    u.username
FROM OrderDateRank o
INNER JOIN Users u ON o.user_id = u.user_id
WHERE o.rk >= 3;