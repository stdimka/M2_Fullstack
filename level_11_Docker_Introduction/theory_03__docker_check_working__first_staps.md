# Проверка работы Docker

### Проверка статуса Docker

Откройте терминал и выполните:
```
docker info
```

Если Docker запущен, вы увидите подробную информацию (версия, количество контейнеров и т. д.).
Если не запущен — будет ошибка вроде:
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```
### ✅ Альтернативно (на Linux)

Можно использовать systemd дла проверки статуса:
```
systemctl status docker
```
Если статус докера неактивен, его надо запустить

### ▶ Как запустить Docker
**На Linux:**
```
sudo systemctl start docker
```
Если хотите, чтобы Docker запускался автоматически при старте системы:
```
sudo systemctl enable docker
```
На Windows / macOS (и Linux в том числе):
```
Откройте Docker Desktop (через меню Пуск или Spotlight).  
Он сам запустит демон, если его ещё нет.
```

# 📦 Работа с Docker Hub?

**Docker Hub** — это официальный облачный репозиторий Docker, в котором хранятся образы (images).

##🔹 По умолчанию Docker Hub всегда подключён!
Когда команды `docker pull`, `docker run` запускаются без указания адреса образа, Docker сам ищет образ на Docker Hub.

## ✅ Проверка связи с Docker Hub

Можно сразу протестировать соединение, запустив официальный тестовый образ:
```
docker run hello-world
```
🔹 Если Docker и Hub работают — вы увидите приветственное сообщение, значит всё настроено правильно.
## 🔍 Как посмотреть образы (в терминале)?

### Поиск образов:
```
docker search ubuntu
```
Поиск будет по ключу `ubuntu`, что означает вывод всех образов, где присутствует слово `ubuntu` 
```html
NAME                             DESCRIPTION                                     STARS     OFFICIAL
ubuntu                           Ubuntu is a Debian-based Linux operating sys…   17538     [OK]
ubuntu/squid                     Squid is a caching proxy for the Web. Long-t…   111       
ubuntu/nginx                     Nginx, a high-performance reverse proxy & we…   129       
ubuntu/cortex                    Cortex provides storage for Prometheus. Long…   4   
...
```
Обратите внимание, что третье поле (STARS) - рейтинг популярности образа

#### ⚙️ Полезные опции поиска:

`--limit` — ограничивает количество результатов:
```
docker search node --limit 5
```
`--filter` — фильтровать по звёздочкам STARS (популярности), например:

docker search redis --filter=stars=1000

### Скачать образ (из Hub):
```
docker pull ubuntu
```
### Посмотреть, какие образы уже загружены локально:
```
docker images
```

## 🖥 Как посмотреть образы на Docker Hub через Docker Desktop?

- Откройте Docker Desktop
- Перейдите во вкладку Images (в левом меню).
- Нажмите кнопку "Pull" (или "Add Image", в зависимости от версии).
- В открывшемся окне:
  - Введите часть названия нужного образа, например nginx или python.
  - Вам отобразятся подсказки с доступными образами с Docker Hub.
- Выберите нужный образ и нажмите "Pull" для загрузки.

После загрузки можно запустить контейнер прямо из интерфейса Docker Desktop.