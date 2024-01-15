import psycopg2
import csv

def get_connection():
    conn = psycopg2.connect(
            dbname='technicalassessment',
            user='newuser',
            password='123',
            host='localhost',
        )
    cur = conn.cursor()

    return cur, conn

def create_tables(cur, conn):
    with open('./sql/schema.sql', 'r') as file:
        sql_query = file.read()

    cur.execute(sql_query)

    conn.commit()

#create_tables(cur, conn)

cur, conn = get_connection()

cur.close()
conn.close()
