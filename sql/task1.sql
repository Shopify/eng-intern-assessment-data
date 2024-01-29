-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT
    P.product_id,
    P.product_name,
    P.description,
    P.price,
    C.category_name
FROM
    products P,
    categories C
WHERE
    P.category_id = C.category_id
    AND C.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    U.user_id,
    U.username,
    sum(OI.quantity) AS total_orders
FROM
    users U,
    orders O,
    order_items OI
WHERE
    U.user_id = O.user_id
    AND O.order_id = OI.order_id
GROUP BY
    U.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
-- Since each product has only been bought once, its average rating is the rating given by the user.
SELECT
    P.product_id,
    P.product_name,
    AVG(R.rating)
FROM
    products P
    INNER JOIN reviews R ON P.product_id = R.product_id
GROUP BY
    P.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
    U.user_id,
    U.username,
    OI.quantity * OI.unit_price AS total_spent
FROM
    users U,
    orders O,
    order_items OI
WHERE
    U.user_id = O.user_id
    AND O.order_id = OI.order_item_id
ORDER BY
    total_spent DESC
LIMIT
    5;