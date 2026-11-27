import sqlite3  
import pandas as pd

class DatabaseSetup():
    def databaseConnection(self):
        '''
            Method extablishes connection to database
            ---
            Returns:
                (tuple): connection and cursor
        '''
        
        
        self.conn=None
        try:
            self.conn = sqlite3.connect(database='my_database')
            print(f'successful SQLite connection with id {id(self.conn)}')
        except:
            print('Error occurred.')

        self.cur = self.conn.cursor()
        return self.conn, self.cur

    def createTables(self):
        '''
            Method builds schema, creates tables
            ---
        '''
        with open('sql/schema.sql', 'r') as file:
            sql_query = file.read()

        sep_queries = sql_query.split(';\n\n')

        for q in sep_queries:
            result = self.conn.execute(q)

    def populateData(self):
        '''
            Method populate data in database
        '''
        categories_data_df = pd.read_csv('data/category_data.csv')
        products_data_df = pd.read_csv('data/product_data.csv')
        users_data_df = pd.read_csv('data/user_data.csv')
        orders_data_df = pd.read_csv('data/order_data.csv')
        order_Items_data_df = pd.read_csv('data/order_items_data.csv')
        reviews_data_df = pd.read_csv('data/review_data.csv')
        cart_data_df = pd.read_csv('data/cart_data.csv')
        cart_Items_data_df = pd.read_csv('data/cart_item_data.csv')
        payments_data_df = pd.read_csv('data/payment_data.csv')
        shipping_data_df = pd.read_csv('data/shipping_data.csv')
        
        categories_data_df.to_sql('Categories', self.conn, if_exists='replace', index=False)
        products_data_df.to_sql('Products', self.conn, if_exists='replace', index=False)
        users_data_df.to_sql('Users', self.conn, if_exists='replace', index=False)
        orders_data_df.to_sql('Orders', self.conn, if_exists='replace', index=False)
        order_Items_data_df.to_sql('Order_Items', self.conn, if_exists='replace', index=False)
        reviews_data_df.to_sql('Reviews', self.conn, if_exists='replace', index=False)
        cart_data_df.to_sql('Cart', self.conn, if_exists='replace', index=False)
        cart_Items_data_df.to_sql('Cart_Items', self.conn, if_exists='replace', index=False)
        payments_data_df.to_sql('Payments', self.conn, if_exists='replace', index=False)
        shipping_data_df.to_sql('Shipping', self.conn, if_exists='replace', index=False)

