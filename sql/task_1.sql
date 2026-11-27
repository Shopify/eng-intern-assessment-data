-- Problem 1: Retrieve all products in the Sports category
-- Assigning the product data table an alias and selecting all the columns that need to be retrieved from the product data table 
-- Assigning the category data table an alias
-- Joining the two tables together based on the column name that is identical in both product data table and category data table
-- Specifying the category name to retrieve all the products from that category

SELECT pd.product_id, pd.product_name, pd.description, pd.price, cd.category_name FROM product_data pd
JOIN category_data cd ON pd.category_id = cd.category_id
WHERE cd.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Assigning the user data table an alias and selecting all the columns that need to be retrieved, from the user data table 
-- Assigning the order data table an alias and renaming column order_id as total_orders
-- Used COUNT to count the total number of orders for each user from the order data table
-- Joining the two tables together based on the column name that is identical in both user data table and order data table

SELECT ud.user_id, ud.username, COUNT(od.order_id) AS total_orders FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
GROUP BY ud.user_id, ud.username, od.order_id

-- Problem 3: Retrieve the average rating for each product
-- Assigning the product data table an alias and selecting all the columns that need to be retrieved from the product data table
-- Assigning the review data table an alias and renaming column rating as average_rating
-- Used AVG to average the ratings for each product from the review data table
-- Joining the two tables together based on the column name that is identical in both product data table and review data table
  
SELECT pd.product_id, pd.product_name, AVG(rd.rating) AS average_rating FROM product_data pd
JOIN review_data rd ON pd.product_id = rd.product_id
GROUP BY pd.product_id, pd.product_name, rd.rating

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Assigning the user data table an alias and selecting all the columns that need to be retrieved from the user data table 
-- Assigning the order data table an alias
-- Joining the two tables together based on the column name that is identical in both product data table and category data table
-- Ordering the total_amount column in the table in descending order and displaying the top 5 highest total amounts
SELECT ud.user_id, ud.username, od.total_amount FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
GROUP BY ud.user_id, ud.username, od.total_amount
ORDER BY od.total_amount DESC
LIMIT 5;
