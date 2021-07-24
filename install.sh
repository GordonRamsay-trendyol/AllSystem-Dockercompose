echo "User microservice clone and compilation started.."
git clone https://github.com/GordonRamsay-Trendyol/user-microservice.git
cd user-microservice
./mvnw package -DskipTests=true
cd ..

echo "Product microservice clone and compilation started.."
git clone https://github.com/GordonRamsay-Trendyol/product-microservice.git
cd product-microservice
./mvnw package -DskipTests=true
cd ..

echo "ApiGateway clone and compilation started.."
git clone https://github.com/GordonRamsay-Trendyol/apigateway.git
cd apigateway
./mvnw package -DskipTests=true
cd ..

echo "UserFollowsProduct microservice clone and compilation started.."
git clone https://github.com/GordonRamsay-Trendyol/user-follows-product-microservice.git
cd user-follows-product-microservice
./mvnw package -DskipTests=true
cd ..

echo "NotificationManager microservice clone and compilation started.."
git clone https://github.com/GordonRamsay-Trendyol/notification-manager-microservice.git

echo "Docker composing started.."
docker compose up -d --build
