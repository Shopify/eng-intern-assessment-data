-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with avg_rat as (
select Products.product_id, avg(cast(Reviews.rating as float)) as 'avg_raiting'
FROM Products left join Reviews on Products.product_id = Reviews.product_id
group by Products.product_id) -- subquery WITH average raiting per product_id
select Products.product_id, Products.product_name, Products.description, avg_rat.avg_raiting
from Products left join avg_rat on Products.product_id = avg_rat.product_id
where avg_rat.avg_raiting in (select max(avg_rat.avg_raiting) from avg_rat)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
with user_to_num_of_cat as
(
select Users.user_id, count(distinct Products.category_id) as nc -- get number of categories per user
from Users left join Orders on Users.user_id = Orders.user_id left join Order_Items on Orders.order_id = Order_Items.order_id left join Products on Order_Items.product_id = Products.product_id
group by Users.user_id
),
num_of_cat as (
select count(distinct Categories.category_id) as n -- get number of categories
from Categories
)
select distinct Users.user_id, Users.username
from Users
where Users.user_id in (select user_to_num_of_cat.user_id from user_to_num_of_cat where user_to_num_of_cat.nc in (select n from num_of_cat))

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select Products.product_id, Products.product_name
from Products
where Products.product_id not in (select Reviews.product_id from Reviews)

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Assuming it means that there need to be at least two orders in two consecutive dates
with cons as (
select Users.user_id, Orders.order_date, lead(Orders.order_date) over (partition by Users.user_id order by Orders.order_date) as next_date #choosing leading value from partition
from Users left join Orders on Users.user_id = Orders.order_id
) -- we create the window with order_date -> next_date pair
select Users.user_id, Users.username
from Users join cons on Users.user_id = cons.user_id
where cons.next_date = DATE_ADD(cons.order_date, INTERVAl 1 DAY) -- checking if order_date -> next_date pair is of the consecutive days
