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
      KAFKA_CREATE_TOPICS: "product.update:3:1,product.create:3:1,notification:3:1"
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
  
  # run the setup.sh script under user-follows-product
  couchbase:
    image: couchbase:latest
    restart: always
    ports:
      - 8091-8094:8091-8094
      - 11210-11211:11210-11211

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

  user-follows-product-ms:
    build: ./user-follows-product-microservice
    ports:
      - 8887:8887
    restart: always
    depends_on:
      - couchbase
      - kafka

```

### Setup script for Couchbase

```bash
container=$1

if [ "$container" -eq '' ]
then
  echo 'Please input a container id'
  exit
else
  echo 'Container captured=' $container
fi

docker exec -t $container couchbase-cli cluster-init --cluster-name user-follows-product-cluster \
   --cluster-username Administrator --cluster-password password --services data,index,query,fts,eventing,analytics \
   --cluster-ramsize 2048

docker exec -t $container couchbase-cli bucket-create -c localhost -u Administrator -p password \
  --bucket followed_products --bucket-type couchbase --bucket-ramsize 1024

docker exec -t $container couchbase-cli user-manage -c localhost -u Administrator -p password \
  --set --rbac-username myapp --rbac-name myapp --rbac-password 123321 --roles admin \
  --auth-domain local
```
