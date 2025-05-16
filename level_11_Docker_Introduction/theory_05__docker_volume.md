# 🗄️ Docker volume (Том)

**Docker volume** (том) — это механизм хранения данных, который Docker использует для постоянного хранения информации, чтобы она не терялась при пересоздании контейнера, а также для обмена данных с другими контейнерами.
По сути, Docker volume - это виртуальный жёсткий диск.

## 🔹 Зачем нужны volume'ы?

- Данные сохраняются между перезапусками контейнеров.
- Можно шарить данные между несколькими контейнерами.
- Управление данными вне контейнера: бэкапы, миграции и т.д.

## 📌 Основные команды для работы с volume'ами
### ✅ Проверить список всех томов:
```
docker volume ls

DRIVER    VOLUME NAME
local     my_volume
...

```
### ✅ Создать volume:
```
docker volume create my_volume
```

### ✅ Посмотреть подробности о томе:
```
docker volume inspect my_volume
[
    {
        "CreatedAt": "2025-04-15T11:42:56+03:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/my_volume/_data",
        "Name": "my_volume",
        "Options": null,
        "Scope": "local"
    }
]
```

### ✅ Удалить volume:
```
docker volume rm my_volume
```

⚠️**Важно**: Нельзя удалить volume, если он используется контейнером.

