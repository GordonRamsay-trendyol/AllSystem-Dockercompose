function clone_and_build() {
    microservice_folder=$1
    is_java_project=$2

    echo "$microservice_folder clone started.."

    git clone https://github.com/GordonRamsay-Trendyol/$microservice_folder.git

    if $is_java_project ; then
        echo "$microservice_folder compilation started.."
        cd $microservice_folder
        ./mvnw package -DskipTests=true
        cd ..
    fi
}

clone_and_build "user-microservice" true
clone_and_build "product-microservice" true
clone_and_build "apigateway" true
clone_and_build "user-follows-product-microservice" true
clone_and_build "notification-manager-microservice" false

echo "Docker composing started.."
docker compose up -d --build