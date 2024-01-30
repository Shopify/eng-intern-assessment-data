-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT
    product_data.product_id,
    product_name,
    AVG(rating) AS average_rating
FROM
    `Products` product_data
    LEFT JOIN `Reviews` review_data ON product_data.product_id = review_data.product_id
GROUP BY
    product_id,
    product_name
ORDER BY average_rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, username
FROM `Users` u
WHERE
    u.user_id IN (
        SELECT O.user_id
        FROM
            `Orders` O
            JOIN `Order_Items` item ON O.order_id = item.order_id
            JOIN `Products` P ON item.product_id = P.product_id
        GROUP BY
            O.user_id, P.category_id
        HAVING
            COUNT(DISTINCT P.category_id) = (
                SELECT COUNT(*)
                FROM `Categories`
            )
    );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT product_id, product_name
FROM `Products` review_data
WHERE
    product_id NOT IN(
        SELECT review_data.product_id
        FROM review_data
    );

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT u.user_id, u.username
FROM `Users` u
WHERE
    u.user_id IN (
        SELECT o.user_id
        FROM (
                SELECT
                    user_id, order_date, LAG(order_date, 1) OVER (
                        PARTITION BY
                            user_id
                        ORDER BY order_date
                    ) AS prev_order_date
                FROM `Orders` order_data
            ) AS o
        WHERE
            DATEDIFF(
                o.order_date, o.prev_order_date
            ) = 1
    );