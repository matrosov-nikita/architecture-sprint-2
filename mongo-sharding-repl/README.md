## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```
Убедиться, что все контейнеры поднялись (в docker ps -a, status: UP).

Заполняем mongodb данными

```shell
./scripts/mongo_init.sh
```

## Как проверить

При запуске `./scripts/mongo_init.sh` в конце выводится кол-во документов в каждом из шардов, а также кол-во реплик.

Откройте в браузере http://localhost:8080.

Поле с шардами должно выглядеть вот так(3 реплики в каждом шарде):

```json
{
  "shards": {
    "shard1": "shard1/shard1-1:27019,shard1-2:27021,shard1-3:27022",
    "shard2": "shard2/shard2-1:27020,shard2-2:27023,shard2-3:27024"
  }
}
```

### Как остановить
```shell
docker compose down --volumes
```
