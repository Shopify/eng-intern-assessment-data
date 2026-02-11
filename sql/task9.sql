-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    C.category_id,
    C.category_name,
    SUM(OI.quantity * OI.unit_price) AS total_sales_amount
FROM
    Categories C
JOIN
    Products P ON C.category_id = P.category_id
JOIN
    Order_Items OI ON P.product_id = OI.product_id
GROUP BY
    C.category_id, C.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;
