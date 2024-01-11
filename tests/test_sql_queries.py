import unittest
import mysql.connector

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            user='root',
            password='Nikita@021003',
            host='localhost',
            database='shopify',
            port='3306'
        )
        self.cur = self.conn.cursor()
        # Clear all table data before adding new data
        self.clear_data()

        self.add_data()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('./sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        print(result)

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('./sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks
    # Add Data from CSV files into each Table
    def add_data(self):
        try:
            tables = ["Categories", "Products", "Users", "Orders", "Order_Items", "Reviews", "Cart", "Cart_Items", "Payments", "Shipping"]
            for table in tables:
                csv_file = table.lower() + "_data.csv"
                table= table.lower()

                # Check if the table is empty
                self.cur.execute(f"SELECT COUNT(*) FROM {table}")
                if self.cur.fetchone()[0] == 0:
                    # Load each CSV contents into tables
                    sql_command = f"""
                    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.2/Uploads/{csv_file}'
                    INTO TABLE {table}
                    FIELDS TERMINATED BY ','
                    ENCLOSED BY '"'
                    LINES TERMINATED BY '\\n'
                    IGNORE 1 ROWS;
                    """

                    self.cur.execute(sql_command)
                    self.conn.commit()
            print("All table data added successfully.")
        except Exception as e:
            print(f"An error occurred: {str(e)}")
  
    # Clear Database Rows from Tables
    def clear_data(self):
        try:
            self.cur.execute("SET FOREIGN_KEY_CHECKS = 0;")

            self.cur.execute("SHOW TABLES;")
            tables = [table[0] for table in self.cur.fetchall()]
            for table in tables:
                self.cur.execute(f"TRUNCATE TABLE `{table}`;")
            
            self.conn.commit()
            self.cur.execute("SET FOREIGN_KEY_CHECKS = 1;") 

            print("All tables truncated successfully.")
        except Exception as e:
            print(f"An error occurred while truncating tables: {str(e)}")


if __name__ == '__main__':
    unittest.main()