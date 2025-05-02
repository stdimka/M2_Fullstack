# Создание проекта для тестирования docker контейнеров

Трудно учиться играть не гитаре без гитары.
Поэтому создадим микро-проект `my_project` для тестирования и изучения docker.

## 🔧 Что будет в проекте:

- Контейнер 1: 
  - API-сервер на Python (с использованием Flask) — возвращает простое сообщение.

- Контейнер 2: 
  - Клиент на Python — раз в 5 секунд делает запрос к API и печатает ответ.

## 📁 Структура проекта
```
docker-demo/
│
├── api/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── client/
│   ├── client.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── docker-compose.yml
└── README.md (опционально)
```
### 📦 Контейнер 1: API

файл `api/app.py`:

```
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Привет из API!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

файл  `api/requirements.txt`:
```
flask
```

### 📦 Контейнер 2: Клиент

файл  `client/client.py`:

```
import time
import requests

while True:
    try:
        response = requests.get("http://api:5000/")
        print("Ответ от API:", response.text)
    except Exception as e:
        print("Ошибка при подключении к API:", e)
    time.sleep(5)
```

файл `client/requirements.txt`:
```
requests
```

### 🧱 docker-compose.yml
```
version: "3.9"

services:
    api:
        build: ./api
        container_name: api-container
        ports:
            - "5000:5000"

    client:
        build: ./client
        container_name: client-container
        depends_on:
            - api
```
### 🐳 Dockerfile'ы

файл `api/Dockerfile`:
```
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```
файл `client/Dockerfile`:
```
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY client.py .
CMD ["python", "-u", "client.py"]
```
**Примечание**: `-u` — это флаг Python, который означает `unbuffered` режим:  
вывод (`stdout` и `stderr`) будет сразу отправляться в консоль, без задержки на буферизацию.


##🚀 Запуск
### 1. C помощью `docker-compose`

 1. Перейти в корень проекта:
```
cd docker-demo
```
 2. Собрать и запустить проект:
```
docker-compose up --build
```

Отличный и удобный вариант, но `docker-compose` мы ещё не проходили.  
Поэтому создаём и запускаем уже известным способом:

### 2. "Ручной вариант" - создаём и запускаем контейнеры самостоятельно
===========================================================
#### 📦 1. Сначала создадим образ API

- Переходим в папку `api` и запускаем:
```
docker build -t my-api .
```
- Запустим API-контейнер из образа `my-api` под именем `api-container`:
```
docker run -d --name api-container -p 5000:5000 my-api
```
Проверяем, работает или нет:
```
curl http://localhost:5000
```
#### 📦 2. Теперь создадим образ клиента

- Переходим в папку client 

Прежде всего, надо определиться, каким образом клиент будет с связываться с сервером.  
Возможны 2 варианта:
- найти ip контейнера в общей сети и подключиться по этому IP
- для этой цели создать свою собственную docker-сеть
- 
##### 🔄 Вариант 1 (не наш случай): Заменить адрес API в client.py на IP

- Для подключения к API-контейнеру определим его IP
``` 
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' api-container
```
- Результат отобразится в терминале. Например, вот такой:
```
172.17.0.2
```
Чтобы клиент знал, куда обращаться — нужно указать IP серверного контейнера в коде:

- Изменяем клиентский скрипт:
  - меняем url запроса номер полученного IP, например:
    ```
    response = requests.get("http://172.17.0.2:5000/")
    ```

  - Запускаем клиент-контейнер, передавая IP API:
  ```
  docker run -d --name client-container my-client
  ```


##### 🔄 Вариант 2 (наш вариант): создать свою docker-сеть, что гораздо удобней  
(не нужно вручную менять код клиента и пересобирать контейнер при смене ip)
- создаём сеть `mynetwork`
```
docker network create mynetwork
```
- проверяем сеть
```
docker network ls
```
- и видим появление нашей сети:
```
NETWORK ID     NAME        DRIVER    SCOPE
1b80adeac0a0   bridge      bridge    local
0e1153d9ce2a   host        host      local
59411aeb4ee1   mynetwork   bridge    local
8f7d2caf3549   none        null      local
```

- Запускаем API в этой сети:
```
docker run -d --name api-container --network mynetwork my-api
```

Если сайт должен быть виден не только внутри сети, но ещё и "снаружи",  
нам нужно явно "пробросить" порт 5000 наружу, то есть на `localhost:5000`:
```
docker run -d --name api-container -p 5000:5000 --network mynetwork my-api
```

Теперь в client.py можно оставить адрес сервера:
```
response = requests.get("http://api-container:5000/")
```

и создаём клиентский image, запустив команду в папку клиента:
```
docker build -t my-client .
```

А теперь запускаем клиента в той же сети, и он может использовать имя api-container как хост:
```
docker run -d --name client-container --network mynetwork my-client
```

🔍 Проверка состояния:

    docker ps — список контейнеров

    docker logs client-container — лог клиента

    docker stop/start и т.д.



