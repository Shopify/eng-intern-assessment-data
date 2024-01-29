-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select Products.product_id, Products.product_name, Products.description, Products.price
from Products join Categories on Products.category_id = Categories.category_id
where category_name like '%Sports%' -- We can remove %% if we don't want a sting containing word Sports, but being the word Sports


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
select Users.user_id, username, COALESCE(count(*), 0) as 'total_num_of_orders' -- setting 0 IF NULL so if user has not ordered anything, the value is 0
from Users left join Orders on Users.user_id = Orders.user_id
group by Users.user_id, username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select Products.product_id, Products.product_name, avg(cast(Reviews.rating as float)) as 'avg_raiting'
FROM Products left join Reviews on Products.product_id = Reviews.product_id
group by Products.product_id, Products.product_name

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

select Users.user_id, Users.username, sum(Orders.total_amount) as 'total_amount_spent'
from Users left join Orders on Users.user_id = Orders.user_id
group by Users.user_id, Users.username
order by total_amount_spent DESC 
limit 5

-- If we want to do the same, but using cost from Products we need to join Order_Items and Products on product_id and use cost from product
