#!/bin/bash
# Функция для проверки статуса реплицированного набора
function wait_for_rs() {
  local service_name=$1
  local port=$2

  while true; do
    # Проверка состояния реплицированного набора
    status=$(docker compose exec -T $service_name mongosh --port $port --quiet --eval 'rs.status().myState' | tail -1)

    # Если статус равен 1 (PRIMARY) или 2 (SECONDARY), то репликация инициализирована
    if [ "$status" == "1" ] || [ "$status" == "2" ]; then
      echo "$service_name инициализирован"
      break
    fi

    echo "Ожидание инициализации $service_name..."
    sleep 2
  done
}

docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF

wait_for_rs "configSrv" 27017

docker compose exec -T shard1-1 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27019" },
        { _id : 1, host : "shard1-2:27021" },
        { _id : 2, host : "shard1-3:27022" }
      ]
    }
);
exit();
EOF

wait_for_rs "shard1-1" 27019
wait_for_rs "shard1-2" 27021
wait_for_rs "shard1-3" 27022

docker compose exec -T shard2-1 mongosh --port 27020 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27020" },
        { _id : 1, host : "shard2-2:27023" },
        { _id : 2, host : "shard2-3:27024" }
      ]
    }
);
exit();
EOF

wait_for_rs "shard2-1" 27020
wait_for_rs "shard2-2" 27023
wait_for_rs "shard2-3" 27024

docker compose exec -T mongos_router mongosh --port 27018 --quiet <<EOF
sh.addShard( "shard1/shard1-1:27019");
sh.addShard( "shard2/shard2-1:27020");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
print("[mongos_router] Документы в коллекции helloDoc: " + db.helloDoc.countDocuments());

exit();
EOF


docker compose exec -T shard1-1 mongosh --port 27019 --quiet <<EOF
use somedb;
print("[shard1] Документы в коллекции helloDoc: " + db.helloDoc.countDocuments());
print("[shard1] Кол-во реплик: " + rs.status().members.length);
exit();
EOF

docker compose exec -T shard2-1 mongosh --port 27020 --quiet <<EOF
use somedb;
print("[shard2] Документы в коллекции helloDoc: " + db.helloDoc.countDocuments());
print("[shard2] Кол-во реплик: " + rs.status().members.length);
exit();
EOF