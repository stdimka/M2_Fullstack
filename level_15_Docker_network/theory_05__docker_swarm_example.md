# Эмуляция работы кластера на одной локальной машине 👍  

В данном случае, локальная машина будет
- и **Manager Node**,
- и **Worker Node** одновременно.

**Docker Swarm** это поддерживает: для тестирования и обучения можно развернуть кластер даже на одном компьютере!

---

# Как это сделать: план действий

1. **Инициализировать Swarm** прямо на вашей машине.
2. **Создать файл** `docker-compose.yml`, подходящий для Swarm.
3. **Развернуть стек** через `docker stack deploy`.
4. **Проверить работу сервиса** через команды типа `docker service ls`, `docker service ps`.

---

# Пошаговая инструкция

## 1. Инициализируем Docker Swarm

```
docker swarm init
```

- Это превратит вашу машину в **Manager Node**.
- Docker автоматически создаст **overlay network**.
- Вы увидите команду для подключения воркеров (`docker swarm join ...`), но для локального теста это не нужно.

## 2. Создаём файл `docker-compose.yml`

Пример простого приложения: **веб-сервер Nginx**, который будет масштабирован до нескольких реплик.

```
services:
    web:
        image: nginx:alpine
        ports:
            - "8080:80"
        deploy:
            replicas: 3
        networks:
            - webnet

networks:
    webnet:
```

**Объяснение:**
- `replicas: 3` — хотим 3 копии контейнера.
- `placement: constraints` — обычно указывают "только на воркерах", но на одной машине это не критично (можно убрать строку).
- `networks` — создаём виртуальную сеть `webnet`, чтобы контейнеры могли общаться.

**Важно!**  
В Swarm в секции `deploy` указывается масштабирование (`replicas`), балансировка, лимиты ресурсов и т.д.  
В обычном Docker Compose подобная команда, записанная в `docker-compose.yml` - игнорируется.  
(Справедливости ради стоит заметить, что там репликацию контейнеров можно выполнить в командной строке: `docker compose up --scale worker=3`)

## 3. Разворачиваем стек

Что такое стек (stack) в Docker Swarm?

**Стек (stack)** — это группа связанных сервисов, объединённых в единое приложение и управляющихся как одна единица.

Иными словами:
-  Несколько контейнеров (например, backend, frontend, база данных) вместе составляют одно приложение.
- Все они описываются в одном файле (docker-compose.yml).
- При развертывании они управляются через одно имя стека.

Действия Docker Swarm:
- Запустит все сервисы,
- Свяжет их сетями,
- Настроит порты,
- Управляет их масштабированием,
- И будет всё это рассматривать как один логический блок.

Создадим стек под именем, например, `mystack`:

```
docker stack deploy -c docker-compose.yml mystack
```

**Расшифровка:**
- `-c docker-compose.yml` — путь к файлу описания стека.
- `mystack` — имя стека (как имя проекта в Compose).

## 4. Проверяем, что всё запустилось

Показать узлы (Nods):
```
docker node ls
```
(должен появиться один узел - с именем нашей локальной машины)

Показать список сервисов (задач или Tasks):

```
docker service ls
```

(должно быть что-то вроде этого:)
```
ID             NAME          MODE         REPLICAS   IMAGE          PORTS
rvmh2v2td7do   mystack_web   replicated   3/3        nginx:alpine   *:8080->80/tcp
```
_где_:
- `NAME` — имя сервиса (в формате `stackname_servicename`, то есть `mystack_web`).
- `MODE = replicated` — значит сервис масштабируется с помощью реплик.
- `REPLICAS = 3/3` — запущены 3 из 3 ожидаемых контейнеров.
- `MAGE` — образ контейнера (`nginx:alpine`).

Показать задачи каждого сервиса:

```
docker service ps mystack_web
```
(должно быть что-то вроде этого:)
```
ID             NAME            IMAGE          NODE                       DESIRED STATE   CURRENT STATE           ERROR     PORTS
v9gjwzg42lt5   mystack_web.1   nginx:alpine   su-HP-250-G8-Notebook-PC   Running         Running 4 minutes ago             
lfp6pxh85ho1   mystack_web.2   nginx:alpine   su-HP-250-G8-Notebook-PC   Running         Running 4 minutes ago             
052b5he5apmn   mystack_web.3   nginx:alpine   su-HP-250-G8-Notebook-PC   Running         Running 4 minutes ago             

```


Показать контейнеры:

```
docker ps
```
(должно быть что-то вроде этого:)
```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
40a289ebc2eb   nginx:alpine   "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes   80/tcp    mystack_web.1.v9gjwzg42lt5fmxzyxui5ydi3
fbeef2ca86bc   nginx:alpine   "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes   80/tcp    mystack_web.2.lfp6pxh85ho17efym9qhetdy1
f3ffa63ae9a5   nginx:alpine   "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes   80/tcp    mystack_web.3.052b5he5apmnuhvhnckzs4kzn

```

## 5. Проверка в браузере

Откройте в браузере:  
`http://localhost:8080`

Вы увидите стандартную страничку Nginx.

---

# Дополнительные команды

**Масштабирование прямо в бою:**

```
docker service scale mystack_web=5
```
(Тут же поднимется ещё 2 контейнера!)

**Остановка стека:**

```
docker stack rm mystack
```

**Выход из Swarm:**

```
docker swarm leave --force
```

---

# Краткий итог

| Шаг | Что происходит |
|:----|:---------------|
| `docker swarm init` | Создаёт кластер на одной машине. |
| `docker stack deploy` | Разворачивает всё приложение как стек сервисов. |
| `docker service` | Управление сервисами: посмотреть, масштабировать, останавливать. |

---
