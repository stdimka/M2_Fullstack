# Конфигурация Nginx

Файл конфигурации `nginx.conf` нужен для определения того, как сервер будет обрабатывать входящие HTTP-запросы.  
В нём можно указать:

- на каком порту слушать запросы (например, 80 для HTTP),
- какие домены (или имена хостов) обслуживать,
- как обрабатывать разные URL-пути,
- куда проксировать запросы (если используется backend),
- где находятся статические файлы (CSS, изображения и т. д.).

Обычно файл конфигурации хранится в папке `/etc/nginx/nginx.conf`

В готовых docker-образах этот файл уже имеется и настроен для работы с простыми сайтами.  
Например:
```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
}

```
### 🔍 Подробное пояснение каждой части базового файла конфигурации
#### 1. Общие настройки
```
user  nginx;
```

    Указывает системного пользователя, от имени которого будет работать процесс nginx.

    Обычно в Docker-образе используется пользователь nginx с ограниченными правами.

```
worker_processes  auto;
```

    Определяет количество рабочих процессов.

    `auto` означает: использовать столько процессов, сколько доступно CPU-ядер — для максимальной производительности (не менее 512)

#### 2. Логирование и PID
```
error_log  /var/log/nginx/error.log warn;
```

    Путь к лог-файлу ошибок.

    Уровень логирования — warn (предупреждения и выше).
```
pid        /var/run/nginx.pid;
```

    PID-файл содержит идентификатор главного процесса Nginx (для управления им: перезапуск, остановка и т. д.).

#### 3. Секция events
```
events {
    worker_connections  1024;
}
```

    Настройки для сетевых соединений.

    worker_connections 1024; — каждый worker может одновременно обрабатывать до 1024 соединений.

    Важно для высоконагруженных серверов.

#### 4. Секция http — основная логика обработки HTTP-запросов
```
http {
    ...
}
```

MIME-типы и тип по умолчанию
```
include       /etc/nginx/mime.types;
default_type  application/octet-stream;
```
    mime.types содержит список расширений и соответствующих им Content-Type.

    default_type — используется, если расширение файла не распознано.

Формат логов
```
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';
```
    Определяет шаблон логирования.

    Что логируется:

        IP клиента

        время запроса

        метод + путь + протокол (GET / HTTP/1.1)

        HTTP-статус ответа

        количество отправленных байт

        откуда пришёл (Referer)

        браузер (User-Agent)

        цепочка IP (через прокси)
```
access_log  /var/log/nginx/access.log  main;
```

    Включает логирование всех HTTP-запросов в файл access.log с использованием формата main.

Дополнительные настройки
```
sendfile on;
```
    Включает механизм передачи файлов напрямую через ядро (ускоряет отдачу больших файлов).
```
keepalive_timeout  65;
```
    Устанавливает таймаут для keep-alive-соединений (клиент может повторно использовать одно и то же соединение в течение 65 секунд).

Подключение виртуальных хостов
```
include /etc/nginx/conf.d/*.conf;
```
    Загружает все файлы конфигурации из папки /etc/nginx/conf.d/.

    Обычно туда добавляют сайты в виде отдельных файлов, например:

        `/etc/nginx/conf.d/default.conf`

        `/etc/nginx/conf.d/app.conf`

Это ключевой механизм, благодаря которому вы можете добавлять собственные настройки, не трогая основной файл `nginx.conf`.  
Что мы, собственно, и сделали.



### Общая структура нашего файла конфигурации `nginx.conf`
```
server {
    listen 80;
    server_name localhost;

    location ... {
        ...
    }
}
```
где

    `server` — блок, описывающий конфигурацию одного виртуального хоста.

    `listen 80;` — сервер будет принимать HTTP-запросы на 80-м порту (обычный порт для HTTP).

    `server_name localhost`; — отвечает за доменное имя. Здесь — localhost.

### Блок 1: Прокси на приложение
```
location / {
    proxy_pass http://app:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```
где

    `location /` — обрабатывает все запросы к корню сайта (например, `http://localhost/`).

    `proxy_pass http://app:5000;` — перенаправляет запросы на внутренний сервер (например, Flask или FastAPI), запущенный по адресу http://app:5000. Здесь app — это имя контейнера (если используется Docker).

    `proxy_set_header Host $host;` — передаёт оригинальное имя хоста (например, localhost) в заголовке.

    `proxy_set_header X-Real-IP $remote_addr;` — передаёт реальный IP клиента, чтобы приложение знало, откуда пришёл запрос.

### Блок 2: Папка с изображениями
```
location /images/ {
    alias /images/;
    autoindex on;
    access_log /var/log/nginx/images.log;
}
```
где

    `location /images/` — обрабатывает запросы по пути, начинающемуся с /images/.

    `alias /images/;` — говорит nginx искать файлы в директории /images/ на сервере.

        Например, `http://localhost/images/cat.jpg → /images/cat.jpg`.

    `autoindex on;` — включает автоматическое отображение списка файлов в браузере (если не указан файл).

    `access_log /var/log/nginx/images.log;` — сохраняет логи обращений к этой папке отдельно (можно использовать для отладки).

### Блок 3: Статика приложения
```
location /static/ {
    alias /app/static/;
}
```
где

    `location /static/` — для запроса по пути `/static/....`

    `alias /app/static/;` — отдаёт статические файлы из папки `/app/static/` на сервере.

        Например, `http://localhost/static/style.css → файл /app/static/style.css.`


Таким образом, файл конфигурации
```
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://app:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /images/ {
        alias /images/;
        autoindex on;
        access_log /var/log/nginx/images.log;  # Debug log
    }

    location /static/ {
        alias /app/static/;
    }
}
```
помогает Nginx выполнить следующие действия:

| Путь       | Действие                                             |
| ---------- | ---------------------------------------------------- |
| `/`        | Прокси на приложение по адресу `app:5000`            |
| `/images/` | Отдаёт файлы из `/images/`, показывает список файлов |
| `/static/` | Отдаёт файлы из `/app/static/`                       |
