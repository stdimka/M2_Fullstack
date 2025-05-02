# Сравнение обычной и мультистейдж сборки Docker контейнера

Если необходимо создать легковесный образ, который будет иметь только то, что нужно - требуется, как минимум, две стадии.

## 🚨 Почему одностадийный образ всё равно тяжелее и "грязнее"?
+ Нельзя удалить pip, не удаляя всё
  - Если установить `pip`, он остаётся в образе.
  - Удалить его потом можно, но сложно и рискованно (могут эаодно удалиться и важные вещи).
  - Он добавляет лишние команды, слои и зависимости (`setuptools`, `wheel` и др.).

+ Слои Docker'а сохраняют всё
  - Каждая инструкция `RUN`, `COPY`, `ADD` создаёт новый слой
  - Даже если удалить файл позже, он всё равно останется в истории слоёв образа.
  - Например, команда `RUN pip install flask && rm -rf ~/.cache` не удалит весь кэш из конечного образа — она просто будет добавлена в новый слой.

+ Нет изоляции "среды сборки"
  - В одной стадии приходится смешивать этапы сборки и исполнения.
  - Это усложняет структуру, мешает кэшированию и снижает безопасность.

## Что делаем?
Дважды создадим один и тот же проект:
 - с помощью однй стадии
 - и с помощью двух

## Суть проекта
Python-код будет содержать простой веб-сервер на Flask — он будет отдавать "Hello from Docker!" по HTTP.

Мы просто сделаем два Dockerfile:
- Обычный (монолитный) — с установленными зависимостями.
- Мультистейдж — финальный образ без Python-пакетов, только с нужными файлами.

И сравним размеры образов.

## 🗂 Структура проекта
```
flask-examples/
├── app.py
├── requirements.txt
├── Dockerfile        # обычная сборка
├── Dockerfile.multi  # мультистейдж-сборка
```
📄 app.py
```
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from Docker!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```
📄 requirements.txt
```
flask
```
## 📦 Вариант 1: Обычный Dockerfile

```
# обычный образ: Python + зависимости + код
FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000
CMD ["python", "app.py"]
```

## 🪄 Вариант 2: Мультистейдж Dockerfile.multi
```
# Этап 1: установка зависимостей и сборка
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/deps -r requirements.txt

COPY app.py .

# Этап 2: минимальный образ
FROM python:3.12-slim

WORKDIR /app

# Копируем только зависимости и код
COPY --from=builder /deps /usr/local/lib/python3.12/site-packages
COPY --from=builder /app/app.py .

EXPOSE 5000
CMD ["python", "app.py"]
```
✅ Делает почти то же самое, но в финальном образе:

- нет `pip`,
- нет `requirements.txt`,
- нет временных кэшей,
- меньше слоёв.

## Что добавлено во второй Dockerfile?

### ✅ AS builder
```
FROM python:3.12-slim AS builder
```
🔹 Это создаёт именованный этап сборки — в данном случае с именем builder.

📦 Зачем?
Для того чтобы:
- можно было к нему обратиться в `COPY --from=builder ...`
- Внутри `builder` можно устанавливать лишние инструменты (`pip`, `build`, и т.д.), которые гарантированно не попадут в финальный образ.

📝 Можно иметь сколько угодно таких этапов: `AS builder`, `AS dev`, `AS test`, `AS runtime`, и т.п.
### ✅ `--target=/deps в pip install`
```
RUN pip install --no-cache-dir --target=/deps -r requirements.txt
```
Флаг `--target=/deps` говорит `pip install`, что устанавливать зависимости нужно не в системный Python, а папку `/deps`

📦 Зачем?

- Чтобы потом скопировать только эут папку в финальный образ.
- Это позволяет не засорять `/usr/local/lib/...` в builder-образе и удобно управлять путями.

В итоге, после завершения первой стадии сборки, в файловой системе контейнера `builder` появится что-то вроде:
```
/deps/
└── flask/
└── flask-2.3.3.dist-info/
```
### ✅ COPY `--from=builder /deps /usr/local/lib/python3.12/site-packages`
```
COPY --from=builder /deps /usr/local/lib/python3.12/site-packages
```
Эта команда копирует папку `/deps` из промежуточного образа `builder` в целевую директорию `site-packages` внутри финального образа

📦 Зачем?
- `site-packages` — это стандартное место, откуда Python подхватывает библиотеки
- После копирования Flask и прочие зависимости будут «видны» для Python, как будто они были установлены через pip

### ✅ `COPY --from=builder /app.py .`
```
COPY --from=builder /app.py .
```
Эта команда копирует только один файл `app.py` из builder-этапа в текущую рабочую директорию (`/app`) финального образа

📦 Зачем?
- В итоговом проекте будет нужен только `app.py`.
- А всё остальное содержимое директории `flask-examples` (`Dockerfile` и т.д.) нужны только на стадии сборки и не абсолютно не нужны в production.
- Таким образом, не попадают в финальный образ ни `requirements.txt`, ни `.git`, ни другие исходники

🔚 Подытожим:

| Строка                             | Значение                                                             |
|-----------------------------------|----------------------------------------------------------------------|
| `AS builder`                      | Создаёт промежуточный образ с именем `builder`                      |
| `--target=/deps`                  | Устанавливает зависимости в указанную директорию `/deps`            |
| `COPY --from=builder /deps ...`   | Копирует библиотеки из `builder` в финальный образ                  |
| `COPY --from=builder /app.py .`   | Копирует только нужный файл `app.py`, избегая всего лишнего         |


## Сборка образов и запуск контейнеров

ВНИМАНИЕ: терминал должен быть открыт в папке проекта!
```
# обычный
docker build -t flask-regular -f Dockerfile .
docker run -d --name regular-container -p 5000:5000 flask-regular

# мультистейдж
docker build -t flask-multy-stage -f Dockerfile.multi .
docker run -d --name multy-stage-container -p 5001:5000 flask-multy-stage

# проверяем работоспособность обоих контейнеров
curl http://localhost:5000
curl http://localhost:5001

# выводим информацию об образах, чтобы сравнить их размеры
docker images
```
Результат должен быть примерно таким:
```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
flask-multy-stage   latest    195bfb796ba0   3 minutes ago    129MB
flask-regular       latest    4c568cbe6411   20 minutes ago   1.03GB
```

Как видим, 129MB против 1.03GB - выигрыш очевиден!