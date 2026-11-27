-- Problem 1: Retrieve all products in the Sports & Outdoors category
-- Write an SQL query to retrieve all products in a specific category.

SELECT P.product_id, P.product_name, P.description, P.price
FROM Products AS P
JOIN Categories AS C ON P.category_id = C.category_id
WHERE C.category_name = 'Sports & Outdoors';