-- Problem 5: Retrieve the products with the highest average rating
-- Assigning the product data table an alias and selecting all the columns that need to be retrieved from the product data table 
-- Assigning the review data table an alias and renaming column rating as average rating
-- Used AVG to average the ratings for each product from the review data table
-- Joining the two tables together based on the column name that is identical in both product data table and review data table
-- Ordering the average_rating column in the table in descending order and displaying the top 5 highest average ratings
SELECT pd.product_id, pd.product_name, AVG(rd.rating) AS average_rating FROM product_data pd
JOIN review_data rd ON pd.product_id = rd.product_id
GROUP BY pd.product_id, pd.product_name
ORDER BY average_rating DESC
LIMIT 5;

-- Problem 6: Retrieve the users who have made at least one order in each category
SELECT ud.user_id, ud.username FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
JOIN order_items_data oid ON od.order_id = oid.order_id
GROUP BY ud.user_id, ud.username

-- Problem 7: Retrieve the products that have not received any reviews
SELECT pd.product_id, pd.product_name FROM product_data pd
JOIN review_data rd ON pd.product_id = rd.product_id
WHERE rd.review_text IS NULL AND rd.rating IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
SELECT ud.user_id, ud.username FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
JOIN order_data odtwo ON ud.user_id = odtwo.user_id AND odtwo.order_date = DATE_ADD(od.order_date, INTERVAL 1 DAY)
GROUP BY ud.user_id, ud.username
HAVING COUNT(DISTINCT od.order_id) > 1;
