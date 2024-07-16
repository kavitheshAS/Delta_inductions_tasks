
# Dockerfile
FROM python:3.8-slim

WORKDIR /app

COPY . /app
RUN pip install 

COPY . .

ENV DATABASE_PATH=/data/users.db

EXPOSE 1234

CMD ["python3", "server.py"]