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
      - ALLOW_ANONYMOUS_LOGIN=yes

  kafka:
    image: wurstmeister/kafka:latest
    restart: always
    ports:
      - 9092:9092
    environment:
      - KAFKA_BROKER_ID=1
      - KAFKA_LISTENERS='PLAINTEXT://:9092
      - KAFKA_ADVERTISED_LISTENERS='PLAINTEXT://127.0.0.1:9092
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
    depends_on:
      - zookeeper

  apigw:
    build:
      context: ./apigw
    restart: always

  product-db:
    image: postgres
    restart: always

  product-ms:
    build:
      context: ./product
    restart: always
    ports: 
      - 8888:8888
    depends_on:
      - kafka
      - product-db

  user-db:
    image: postgres
    restart: always

  user-ms:
    build:
      context: ./user
    restart: always
    ports: 
      - 8885:8885
    depends_on:
      - kafka
      - user-db

  user-follows-product-db:
    image: couchbase:latest
    ports:
      - 8091-8094:8091-8094
      - 11210-11211:11210:11211
    environment:
      - COUCHBASE_NODE_NAME=user-follows-product
      - COUCHBASE_CLUSTER_NAME=user-follows-product-cluster
      - COUCHBASE_ADMINISTRATOR_USERNAME=Administrator
      - COUCHBASE_ADMINISTRATOR_PASSWORD=password
      - COUCHBASE_BUCKET=followed_products
      - COUCHBASE_BUCKET_PASSWORD=123321
      - COUCHBASE_RBAC_USERNAME=myapp
      - COUCHBASE_RBAC_PASSWORD=123321
      - COUCHBASE_RBAC_PASSWORD=bucket_full_access[followed_products]

  user-follows-product-ms:
    build:
      context: ./user-follows-product
    restart: always
    ports: 
      - 8887:8887
    depends_on:
      - user-follows-product-db
      - kafka

  notification-manager-ms:
    build:
      context: ./notification-manager
    restart: always
    depends_on:
      - kafka

```
