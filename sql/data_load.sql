SET SEARCH_PATH TO onlineShopping;

\copy Categories from './data_copy/category_data.csv' delimiter ',' CSV HEADER;
\copy Users from './data_copy/user_data.csv' delimiter ',' CSV HEADER;
\copy Products from './data_copy/product_data.csv' delimiter ',' CSV HEADER;
\copy Orders from './data_copy/order_data.csv' delimiter ',' CSV HEADER;
\copy Order_Items from './data_copy/order_items_data.csv' delimiter ',' CSV HEADER;
\copy Cart from './data_copy/cart_data.csv' delimiter ',' CSV HEADER;
\copy Cart_Items from './data_copy/cart_item_data.csv' delimiter ',' CSV HEADER;
\copy Payments from './data_copy/payment_data.csv' delimiter ',' CSV HEADER;
\copy Reviews from './data_copy/review_data.csv' delimiter ',' CSV HEADER;
\copy Shipping from './data_copy/shipping_data.csv' delimiter ',' CSV HEADER;
