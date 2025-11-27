-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Assigning the category data table an alias and selecting all the columns that need to be retrieved from the category data table
-- Multiplying the quantity with price from the order items data table to get the total sales amount
-- Assigning the product data table an alias
-- Joining the two tables together based on the column name that is identical in both product data table and category data table
-- Assigning the order items data table an alias
-- Joining the two tables together based on the column name that is identical in both order items data table and product data table
-- Ordering the total sales amount column in the table in descending order and displaying the top 3 highest total sales amount

SELECT cd.category_id, cd.category_name, SUM(oid.quantity*oid.unit_price) AS total_sales_amount FROM category_data cd
JOIN product_data pd ON cd.category_id = pd.category_id
JOIN order_items_data oid ON pd.product_id = oid.product_id
GROUP BY cd.category_id, cd.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Assigning the user data table an alias and selecting all the columns that need to be retrieved from the user data table
-- Assigning the order data table an alias
-- Joining the two tables together based on the column name that is identical in both user data table and order data table
-- Assigning the order items data table an alias
-- Joining the two tables together based on the column name that is identical in both order data table and order items data table
-- Assigning the product data table an alias
-- Joining the two tables together based on the column name that is identical in both order items data table and product data table
-- Assigning the category data table an alias
-- Joining the two tables together based on the column name that is identical in both product data table and category data table
-- Specifying the category name to retrieve all the products from that category

SELECT ud.user_id, ud.username FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
JOIN order_items_data oid ON od.order_id = oid.order_id
JOIN product_data pd ON oid.product_id = pd.product_id
JOIN category_data cd ON pd.category_id = cd.category_id
WHERE cd.category_name = 'Toys & Games'
GROUP BY ud.user_id, ud.username

-- Problem 11: Retrieve the products that have the highest price within each category
-- Make a CTE for the Highest priced products in each category
-- Window function is used to create a row number that will be displayed in descending order
-- Selecting all the columns that need to be displayed from the CTE
-- Row number stores the highest priced product from each category
  
WITH HighestPricedProducts AS (
  SELECT product_id, product_name, category_id, price, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_numbers 
  FROM product_data
)
SELECT product_id, product_name, category_id, price 
FROM HighestPricedProducts
WHERE row_numbers = 1;
  

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Assigning the user data table an alias and selecting all the columns that need to be retrieved from the user data table
-- Assigning the order data table an alias
-- Joining the two tables together based on the column name that is identical in both user data table and order data table
-- Joining two tables together for the second time, with a different alias, and same user id, to show the comparison of the user's orders between the first and second day
-- Joining two tables together for the third time, with a different alias, and same user id, to show the comparison of the user's orders between the second and third day
-- HAVING COUNT is used to ensure the user has consecutive orders on consecutive days

SELECT ud.user_id, ud.username FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
JOIN order_data odtwo ON ud.user_id = odtwo.user_id AND odtwo.order_date = DATE_ADD(od.order_date, INTERVAL 1 DAY)
JOIN order_data odthree ON ud.user_id = odthree.user_id AND odthree.order_date = DATE_ADD(odtwo.order_date, INTERVAL 2 DAY)
GROUP BY ud.user_id, ud.username
HAVING COUNT(DISTINCT od.order_id) > 2;
