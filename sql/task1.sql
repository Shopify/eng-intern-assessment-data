/*
  MySQL style is used for all tasks
*/

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT p.product_id,
       p.product_name,
       p.description,
       p.price,
       p.category_id
  FROM Products p
  JOIN Categories c
    ON p.category_id   = c.category_id
 WHERE c.category_name = 'Sports & Outdoors'; -- Filter for the Sports category
  
-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT u.user_id,
       u.username,
       COUNT(o.order_id) AS "Total Number of Orders"
  FROM Users u
  LEFT JOIN Orders o -- Include all users, even if there is no corresponding order
    ON u.user_id = o.user_id
 GROUP BY u.user_id,
          u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

/* The product_data file only has id 1-16, but the review_data file contains extra reviews 
for product_id 17-30. The query only considers the products in the product_data file. */
SELECT p.product_id,
       p.product_name,
       AVG(r.rating) AS "Average Rating"
  FROM Products p
  LEFT JOIN Reviews r -- Include all products, even if there is no corresponding rating
    ON p.product_id = r.product_id     
 GROUP BY p.product_id,
          p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT u.user_id,
       u.username,
       SUM(o.total_amount) AS "Total Amount Spent" -- Total amount spent for each user                                                   
  FROM Users u                                     
  JOIN Orders o                                    
    ON u.user_id = o.user_id
 GROUP BY u.user_id,
          u.username
 ORDER BY SUM(o.total_amount) DESC -- Sort descending
 LIMIT 5; -- First 5 records only, regardless of ties in total amount spent (if we were to include ties, this can be re-written with subqueries or DENSE_RANK())