# AllSystem-Dockercompose

Docker compose file of the whole system. There are `*.sh` files and `docker-compose.yml` file inside this repository.

To `install` and  `prepare` all of the microservices, you should run the commands below.

```bash
./install.sh
./prepare.sh
```

These two commands will

1. Download all of the github repositories.
2. Build all of the java projects
3. Run docker compose file.
4. Prepare couchbase user and buckets.
