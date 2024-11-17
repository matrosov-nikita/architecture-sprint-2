## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```
Убедиться, что все контейнеры поднялись (в docker ps -a, status: UP).

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

При запуске `./scripts/mongo_init.sh` в конце выводится кол-во документов в каждом из шардов.

Откройте в браузере http://localhost:8080

Дожно быть поле с шардами вот так выглядеть (3 реплики в каждом шарде):

```json
  "shards": {
    "shard1": "shard1/shard1-1:27019",
    "shard2": "shard2/shard2-1:27020"
},
```