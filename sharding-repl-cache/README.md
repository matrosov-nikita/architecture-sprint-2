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

1. Откройте в браузере http://localhost:8080, cache_enabled установлен в `true`.
2. Сделать 1-й запрос
```shell
curl -o /dev/null -s -w "%{time_total}\n" 'http://localhost:8080/helloDoc/users' -H 'accept: application/json'
```
Ожидаем, что он пойдет в БД и это займет время (~1c. на моей машине)
3. Сделать 2-й запрос
```shell
curl -o /dev/null -s -w "%{time_total}\n" 'http://localhost:8080/helloDoc/users' -H 'accept: application/json'
```
Ожидаем, что данные уже лежат в Redis и сразу отдадутся клиенту без похода в БД. Ожидаемое время <100мс. (на моей машине 0.004186с ~= 4.2мс)