-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT P.product_id, P.product_name, AVG(R.rating) AS average_rating
FROM Products AS P
LEFT JOIN Reviews AS R ON P.product_id = R.product_id
GROUP BY P.product_id, P.product_name
ORDER BY P.product_id;
