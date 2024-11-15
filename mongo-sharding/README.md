## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```
Убедиться, что для контейнеры поднялись.

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

Откройте в браузере http://localhost:8080