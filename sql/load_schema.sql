COPY categories(category_id, category_name)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/category_data.csv'
DELIMITER ','
CSV HEADER;

COPY products(product_id, product_name, description, price, category_id)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/product_data.csv'
DELIMITER ','
CSV HEADER;

COPY users(user_id, username, email, password, address, phone_number)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/user_data.csv'
DELIMITER ','
CSV HEADER;

COPY orders(order_id, user_id, order_date, total_amount)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/order_data.csv'
DELIMITER ','
CSV HEADER;

COPY order_items(order_item_id, order_id, product_id, quantity, unit_price)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/order_items_data.csv'
DELIMITER ','
CSV HEADER;

COPY reviews(review_id, user_id, product_id, rating, review_text, review_date)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/review_data.csv'
DELIMITER ','
CSV HEADER;

COPY cart(cart_id, user_id)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/cart_data.csv'
DELIMITER ','
CSV HEADER;

COPY cart_items(cart_item_id, cart_id, product_id, quantity)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/cart_item_data.csv'
DELIMITER ','
CSV HEADER;

COPY payments(payment_id, order_id, payment_date, payment_method, amount)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/payment_data.csv'
DELIMITER ','
CSV HEADER;

COPY shipping(shipping_id, order_id, shipping_date, shipping_address, tracking_number)
FROM '/Users/patelh/Documents/Jobs/ShopifyDataEngOA2024/eng-intern-assessment-data/data/shipping_data.csv'
DELIMITER ','
CSV HEADER;