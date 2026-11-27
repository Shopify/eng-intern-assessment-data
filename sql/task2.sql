-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT Products.product_id AS ProductID, Products.product_name AS ProductName,
    AVG(Reviews.rating) AS AverageRating
FROM
(Products LEFT JOIN Reviews ON Products.product_id=Reviews.product_id)
GROUP BY Products.product_id
HAVING AverageRating=
    (SELECT MAX(AverageRating) FROM 
        (SELECT AVG(Reviews.Rating) as AverageRating 
         FROM 
         (Products LEFT JOIN Reviews ON Products.product_id=Reviews.product_id)
         GROUP BY Products.product_id));

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT Users.user_id AS UserID, Users.username AS Username
FROM
((((Users LEFT JOIN Orders ON Users.user_id=Orders.user_id)
   LEFT JOIN Order_Items ON Orders.order_id=Order_Items.order_id)
  LEFT JOIN Products ON Order_Items.product_id=Products.product_id)
 LEFT JOIN Categories ON Products.category_id=Categories.category_id)
GROUP BY Users.user_id
HAVING COUNT(Categories.category_id)=
    (SELECT COUNT(Categories.category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT Products.product_id AS ProductID, Products.product_name AS ProductName
FROM
(Products LEFT JOIN REVIEWS ON Products.product_id=Reviews.product_id)
WHERE Reviews.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT Users.user_id AS UserID, Users.username AS Username 
FROM 
((Users LEFT JOIN Orders Orders1 ON Users.user_id=Orders1.user_id)
 LEFT JOIN Orders Orders2 ON Users.user_id=Orders2.user_id)
WHERE Orders1.order_date=DATE(Orders2.order_date, "+1 day");
