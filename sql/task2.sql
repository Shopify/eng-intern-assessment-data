-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Assumption: since there was no number of products to return, I'm returning all of them sorted by their average rating
-- There's a second commented out option for if you only want THE highest (singular) item WITHOUT A SEMICOLON SO THAT MY CODE CAN SPLIT THE QUERIES WELL

SELECT DISTINCT Products.product_id, product_name, AVG(rating) as avg_rating FROM Products LEFT JOIN Reviews ON Products.product_id = Reviews.product_id ORDER BY avg_rating DESC;

-- SELECT DISTINCT Products.product_id, product_name, AVG(ratings) as avg_rating FROM Products LEFT JOIN Ratings ON Products.product_id = Ratings.product_id ORDER BY avg_rating DESC LIMIT 1


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.