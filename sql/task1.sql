-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Assumptions made: There is no "Sports" category, but there is "Sports & Outdoors", so we'll go with that
-- Also assuming that you just want all the info.

-- This SQL query performs an INNER JOIN between 'Products' and 'Categories' by their common column 'category_id'.
-- An inner join is acceptable here because we only want to retrieve products that are in a specific category, so we don't need to include products that are not in that category or that don't have a category.
-- We filter which speicific category we want by using WHERE, specifically WHERE category_name="Sports & Outdoors" to get our category

SELECT 
    * 
FROM 
    Products 
INNER JOIN 
    Categories ON Products.category_id = Categories.category_id 
WHERE 
    Categories.category_name = "Sports & Outdoors";

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- This SQL statement is performing a LEFT JOIN operation between two tables: 'Users' and 'Orders' on the 'user_id' column.
-- We want to use a LEFT JOIN here because we want to include all users, even if they have not placed any orders.
-- We 'GROUP BY' the results by user ID, which is then counted by the 'COUNT' function for each user's id in the orders.  
-- We use 'DISTINCT' to ensure that we only return each user's info once.

SELECT 
    DISTINCT Users.user_id, 
    username, 
    COUNT(Orders.order_id) 
FROM 
    Users 
LEFT JOIN 
    Orders ON Users.user_id = Orders.user_id 
GROUP BY 
    Users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Note: In the example data, there were many reviews for products that didn't exist, so my query deals with that.
-- I also decided that it was acceptable to return NULL for products that have no reviews, since the question didn't specify what to do in that case.

-- A similar idea to the query above, with a left join to get all the reviews even if there are none, and averaging the ratings for each product grouped by ID.

SELECT 
    Products.product_id, 
    product_name, 
    AVG(rating) AS avg_rating 
FROM 
    Products 
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id 
GROUP BY 
    Products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- As above, I assumed it was acceptable to return NULL for users with 0 spent if there was just not enough values

-- A third similar query, but when we sum the amounts spent for each user, we store this as an allias used later for sorting

SELECT 
    Users.user_id, 
    username, 
    SUM(total_amount) AS grand_total_spent 
FROM 
    Users 
LEFT JOIN 
    Orders ON Users.user_id = Orders.user_id 
GROUP BY 
    Users.user_id 
ORDER BY 
    grand_total_spent DESC 
LIMIT 5;
