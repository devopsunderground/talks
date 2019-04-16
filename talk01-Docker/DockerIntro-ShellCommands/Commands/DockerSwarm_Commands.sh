## Docker Swarm commands

# Create VMs for cluster

docker-machine create --driver virtualbox manager1
docker-machine create --driver virtualbox worker1
docker-machine create --driver virtualbox worker2
docker-machine create --driver virtualbox worker3
docker-machine ls
docker-machine lp manager

# Initialize swarm

docker-machine ssh manager1
docker swarm init --advertise-addr 192.168.99.105
docker swarm join-token worker
docker swarm join-token manager

# Create Service

docker service create --replicas 4 -p 80:80 --name web nginx
docker service ls
docker service ps web

# Scale Service

docker service scale web=8
docker service ls
docker service ps web

# Update Service

docker service update --image nginx:latest web
docker service ps web

# Remove Service

docker service rm web
docker service inspect web

# Mark node as unavailable

docker node update --availability drain worker1
docker service ps web

# Remove node from swarm

docker node rm worker3
docker node ls

# Promote and demote nodes

docker node ls
docker node promote worker1
docker node demote manager1
docker node demote worker1

# Create Secret

echo “ This is top secret” | docker secret create my-secret-data -
Docker secret ls
docker service create --name test-redis --replicas 3 --secret my-secret-data redis:alpine
docker service ls
docker secret rm my-secret-data
docker service rm test-redis
docker secret ls

# Deploy NGINX app on swarm

docker-machine ls
docker-machine ssh manager1
docker node ls
docker service create --name test-redis --mode global redis
docker service ls
docker service ps test-redis
docker service create -name test-nginx --replicas 3 nginx
docker service ls
docker service ps test-nginx
