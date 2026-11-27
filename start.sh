#!/bin/bash
service postgresql start
python tests/test_sql_queries.py