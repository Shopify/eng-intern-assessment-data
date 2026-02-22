FROM python:latest

# Set up app files
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
RUN apt-get update
#RUN apt-get install sqlite3
#RUN sqlite3 mydatabase.db

# Set up Postgres
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib && \
    service postgresql start && \
    service postgresql status && \
    su - postgres -c "psql -c \"CREATE DATABASE mydatabase;\"" && \
    su - postgres -c "psql -c \"CREATE USER myuser WITH PASSWORD 'mypassword';\"" && \
    su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;\"" && \
    # su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON SCHEMA public TO myuser;\"" && \
    # su - postgres -c "psql -c \"GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO myuser;\""
    su - postgres -c "psql mydatabase -c \"GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myuser;\"" && \
    su - postgres -c "psql mydatabase -c \"GRANT ALL PRIVILEGES ON SCHEMA public TO myuser;\"" && \
    su - postgres -c "psql mydatabase -c \"GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO myuser;\"" && \
    su - postgres -c "psql mydatabase -c \"ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO myuser;\""

RUN chmod 755 /app/start.sh
#ENV POSTGRES_USER=myuser
#ENV POSTGRES_PASSWORD=mypassword
#ENV POSTGRES_DB=mydatabase
#RUN apt-get install -y postgresql
#RUN service postgresql start

# Run tests
CMD ["/app/start.sh"]