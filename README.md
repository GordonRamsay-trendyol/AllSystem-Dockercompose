# AllSystem-Dockercompose

Docker compose file of the whole system. The projects should be under the same folder.

```yml
version: "3.8"
services:
  zookeeper:
    image: wurstmeister/zookeeper:latest
    restart: always
    ports:
      - 2181:2181
    environment:
      ALLOW_ANONYMOUS_LOGIN: "yes"

  kafka:
    image: wurstmeister/kafka:latest
    restart: always
    ports:
      - 9092:9092
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ADVERTISED_HOST_NAME: kafka
      KAFKA_ADVERTISED_PORT: 9092
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      ALLOW_PLAINTEXT_LISTENER: "yes"
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
      KAFKA_CREATE_TOPICS: "product.update:3:1,product.create:3:1"
    depends_on:
      - zookeeper

  postgresql:
    image: postgres
    restart: always
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: toor
      POSTGRES_DB: trendxdb
      POSTGRES_PORT: 5432
      POSTGRES_HOST: 127.0.0.1

  apigw:
    build: ./apigateway
    restart: always
    ports:
      - 8881:8881

  product-ms:
    build: ./product
    restart: always
    ports:
      - 8888:8888
    depends_on:
      - postgresql
      - kafka

```
