-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH Average_ratings -- Calculate the average rating for each product
  AS (SELECT r.product_id,
             p.product_name,
             AVG(r.rating) AS avg_rating
        FROM Reviews r
        JOIN Products p
          ON r.product_id = p.product_id
       GROUP BY r.product_id,
                p.product_name),
  Product_ranks      -- Rank products by average rating 
  AS (SELECT product_id,
             product_name,
             avg_rating,
             DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS rnk
        FROM Average_ratings)
SELECT product_id,
       product_name,
       avg_rating AS "Average Rating"
  FROM Product_ranks
 WHERE rnk = 1; -- Filter for the highest average rating, including ties
  

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH Total_categories AS (
  SELECT COUNT(*) AS count_categories
    FROM Categories)
-- Join to find the orders and their corresponding categories for each user
SELECT u.user_id,
       u.username
  FROM Users u
  JOIN Orders o
    ON u.user_id = o.user_id
  JOIN Order_Items oi
    ON o.order_id = oi.order_id
  JOIN Products p
    ON oi.product_id = p.product_id
  JOIN Categories c
    ON p.category_id = c.category_id
 GROUP BY u.user_id,
          u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT count_categories -- Check if the user has at least one order in each category
                                          FROM Total_categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id,
       p.product_name
  FROM Products p
  LEFT JOIN Reviews r -- Include all products, even if there is no corresponding review
    ON p.product_id = r.product_id
 GROUP BY p.product_id,
          p.product_name
HAVING COUNT(r.review_id) = 0; -- Filter for products that have not received any reviews
 
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH User_with_consec_orders -- Calculate the previous and the next order date for each order
  AS (SELECT user_id,
             order_date,
             LAG(order_date) OVER (PARTITION BY user_id -- LAG() for getting the order date precedeing the current one
                                         ORDER BY order_date) AS prev_date,
             LEAD(order_date) OVER (PARTITION BY user_id -- LEAD() for getting the order date following the current one
                                         ORDER BY order_date) AS next_date
        FROM Orders o)
SELECT DISTINCT 
       u.user_id,
       u.username
  FROM User_with_consec_orders uw
  JOIN Users u
    ON uw.user_id = u.user_id
 WHERE (DATE_ADD(uw.order_date, INTERVAL -1 DAY) = uw.prev_date -- Filter for the order date and the prev_date
    OR DATE_ADD(uw.order_date, INTERVAL 1 DAY) = uw.next_date); -- Filter for the order date and the next_date