-- ------------------------------------------------------------------------------------
-- Performed sanity testing for all 12 problems on local mysql with the given csv files 
--  (and some more test cases added) to ensure if the code compiles properly
-- ------------------------------------------------------------------------------------



-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Ans. perform an inner join on Categories and Products (using category_id) and search with category_name
select Products.product_id, Products.product_name, Products.description, Products.price
from Products
inner join Categories on Products.category_id = Categories.category_id
where Categories.category_name = 'Sports & Outdoors';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Ans. perform left join on Users to get all Orders of the given user
select Users.user_id, Users.username, count(Orders.order_id) as total_orders
from Users
left join Orders on Users.user_id = Orders.user_id
group by Users.user_id, Users.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Ans. left join Reviews on Products using product_id. used avg() aggregator to average out the ratings for a particular product
select p.product_id, p.product_name, avg(r.rating) as average_rating
from Products p
left join Reviews r on p.product_id = r.product_id
group by p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Ans. left join Orders on Users. sum out the total amount spent by each user, sort them in descending order and limit the results to 5
select u.user_id, u.username, sum(o.total_amount) as total_spent
from Users u
left join Orders o on u.user_id = o.user_id
group by u.user_id, u.username
order by total_spent desc
limit 5;
