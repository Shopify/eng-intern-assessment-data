-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
  SELECT
    product_id,
    product_name,
    category_id,
    price,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
  FROM
    Products
)

SELECT
  product_id,
  product_name,
  category_id,
  price
FROM
  RankedProducts
WHERE
  price_rank = 1;
