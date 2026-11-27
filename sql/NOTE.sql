-- Due to error regardung fkey I had to add this part
-- Product_id is 1 to 30on all other data, except in product_data which is 1 to 16

-- ALTER TABLE cart_items DROP CONSTRAINT cart_items_product_id_fkey;
ALTER TABLE cart_items
ADD CONSTRAINT cart_items_product_id_fkey
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- ALTER TABLE order_items DROP CONSTRAINT order_items_product_id_fkey;
ALTER TABLE order_items
ADD CONSTRAINT order_items_product_id_fkey
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- ALTER TABLE reviews DROP CONSTRAINT reviews_product_id_fkey
ALTER TABLE reviews
ADD CONSTRAINT reviews_product_id_fkey
FOREIGN KEY (product_id) REFERENCES products(product_id);