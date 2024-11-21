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

При запуске `./scripts/mongo_init.sh` в конце выводится кол-во документов в каждом из шардов.

Откройте в браузере http://localhost:8080

Поле с шардами должно выглядеть вот так:

```json
{
  "shards": {
    "shard1": "shard1/shard1-1:27019",
    "shard2": "shard2/shard2-1:27020"
  }
}
```

### Как остановить
```shell
docker compose down --volumes
```