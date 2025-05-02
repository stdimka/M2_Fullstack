# Создание БД PostgresSQL в контейнере, дамп, восстановление из дампа

## 🐘 1. Запуск PostgreSQL в контейнере с томом

Создайте том для хранения данных:
```
docker volume create pgdata
```
Запустите контейнер:
```
docker run -d \
  --name my_postgres \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydb \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:17
```
где:
- `myuser`, `mypassword`, `mydb` — имя пользователя, пароль и имя БД
- `-v pgdata:/var/lib/postgresql/data` — монтирует постоянное хранилище.
- `-p 5432:5432` — пробрасывает порт на хост-машину.
- `postgres:17` — образ PostgreSQL версии 17.

## 💾 2. Создание бэкапа (дампа) базы данных
```
docker exec -t my_postgres pg_dump -U myuser -d mydb > mydb_backup.sql
```
Результатом будет файл `mydb_backup.sql` на локальной машине в текущей директории.

Если бэкап необходимо сохранить ещё внутри контейнера:
```
docker exec -t my_postgres pg_dump -U myuser -d mydb -f /backup/mydb_backup.sql
```
Но для этого нужно смонтировать каталог:
```
mkdir pg_backups
docker run -d \
  --name my_postgres \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydb \
  -v pgdata:/var/lib/postgresql/data \
  -v $(pwd)/pg_backups:/backup \
  -p 5432:5432 \
  postgres:17
```

## ♻️ 3. Восстановление базы данных из дампа

### 3.1. Необходимо создать пустую базу

Самый простой способ в нашей ситуации - удалить БД из только что созданного контейнера и тут же создать её заново.    
Эта операция гарантированно создаст пустую базу с нужным нам именем `mydb`.
Для этого выполняем команду:  
```
docker exec -it my_postgres psql -U myuser -d postgres
```
где
- `docker exec -it my_postgres` - запуск терминала в только что созданном контейнере PostgreSQL
- `psql` - команда запускает клиент командной строки PostgreSQL
- `-U myuser` - подключение должно быть от имени пользователя  `myuser`
- `-d postgres` - подключение к системной базе `postgres` даёт возможность решать административные задачи (создание/удаление БД)

Далее, в окне терминала запускаем команды удаления и создания БД `mydb`, и команды выз
```sql
DROP DATABASE IF EXISTS mydb;  -- удаление БД `mydb`
CREATE DATABASE mydb;          -- создание БД `mydb`
\q                             -- выход из клиента `psql`
```

### 3.2. Восстановление базы из дампа

Дамп БД `cat mydb_backup.sq`, созданный в предыдущем пункте, находится в работ каталоге.
Поэтому, команда:
```
cat mydb_backup.sql | docker exec -i my_postgres psql -U myuser -d mydb
```
считает этот дамп и перенаправит его в стандартный поток ввода (`stdin`) команды `docker exec -i my_postgres psql -U myuser -d mydb`.
Эта команда последовательно выполнит все инструкции дампа и восстановит БД в контейнере `my_postgres`.


