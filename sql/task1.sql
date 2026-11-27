

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select P.*
from dbo.categories C
inner join dbo.products P on C.category_id=P.category_id
where C.category_name = 'Sports & Outdoors'


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

select O.user_id, U.username, count(O.order_id) TotalNumberOfOrders
from dbo.Orders O
inner join dbo.users U on O.user_id=U.user_id
group by O.user_id, U.username
order by U.username

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

select R.product_id, P.product_name, Avg(R.rating) RatingAvg
from dbo.reviews R
inner join dbo.products P on R.product_id=P.product_id
group by R.product_id, P.product_name
order by r.Product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
select top 5 O.user_id, U.username,  sum(P.amount) AmountSum
from dbo.payments P
inner join dbo.orders O on P.order_id = O.order_id
inner join dbo.users U on U.user_id = O.user_id
group by O.user_id, U.username
order by 3 desc;


