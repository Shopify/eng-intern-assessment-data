COPY Categories
FROM '/csv_data/category_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Products
FROM '/csv_data/product_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Users
FROM '/csv_data/user_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Orders
FROM '/csv_data/order_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Order_Items
FROM '/csv_data/order_items_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Reviews
FROM '/csv_data/review_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Cart
FROM '/csv_data/cart_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Cart_Items
FROM '/csv_data/cart_item_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Payments
FROM '/csv_data/payment_data.csv'
WITH (FORMAT csv, HEADER true);

COPY Shipping
FROM '/csv_data/shipping_data.csv'
WITH (FORMAT csv, HEADER true);