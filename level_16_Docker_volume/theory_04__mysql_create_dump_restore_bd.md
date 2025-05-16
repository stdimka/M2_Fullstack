Ниже приведены аналогичные команды для MySQL:
 - создание дампа и 
 - восстановление из дампа.  
Команды следуют той же логике, что и для PostgreSQL в предыдущем параграфе, но используют инструменты и синтаксис MySQL.


## 🐬 1. Запуск MySQL в контейнере с томом
Создаём том для хранения данных:
```
docker volume create mysqldata
```
И запускаем контейнер для MySQL:
```
docker run -d \
  --name my_mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  -e MYSQL_DATABASE=mydb \
  -v mysqldata:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.4
```
где:

- `rootpassword` — пароль для root-пользователя MySQL.
- `myuser`, `mypassword`, `mydb` — имя пользователя, пароль и имя базы данных.
- `-v mysqldata:/var/lib/mysql` — монтирует постоянное хранилище для данных MySQL.
- `-p 3306:3306` — пробрасывает порт MySQL на хост-машину.
- `mysql:8.4` — образ MySQL версии 8.4.

## 💾 2. Создание бэкапа (дампа) базы данных
```
docker exec my_mysql mysqldump -u myuser -p'mypassword' mydb > mydb_mysql_backup.sql
```
- Команда `mysqldump` создаёт дамп базы данных MySQL `mydb`.
- Результат сохраняется в файл `mydb_mysql_backup.sql` на локальной машине.


## ♻️ 3. Восстановление базы данных из дампа
### 3.1. Создание пустой базы данных

Для восстановления из дампа нужно создать пустую базу mydb.  
Если база уже существует (наш случай), её можно удалить и создать заново.

#### 3.1.1. Подключитесь к контейнеру MySQL:
```
docker exec -it my_mysql mysql -u myuser -p'mypassword'
```

#### 3.1.2. В командной строке MySQL выполните:
```
DROP DATABASE IF EXISTS mydb;  -- Удаление базы, если она существует
CREATE DATABASE mydb;          -- Создание новой пустой базы
EXIT;                          -- Выход из клиента MySQL
```

### 3.2. Восстановление базы из дампа

Если дамп `mydb_mysql_backup.sql` находится в текущей директории на локальной машине, выполните:
```
cat mydb_mysql_backup.sql | docker exec -i my_mysql mysql -u myuser -p'mypassword' mydb
```
где
- Команда `cat mydb_backup.sql` отправляет содержимое дампа в стандартный поток ввода.  
- `mysql -u myuser -p'mypassword' mydb` выполняет инструкции из дампа, восстанавливая базу mydb в контейнере.

### Основные отличия от PostgreSQL:

- **Инструменты**: Вместо `pg_dump` и `psql` используются `mysqldump` и `mysql`.
- **Пароль**: В MySQL пароль указывается через `-p'mypassword'` (без пробела между `-p` и паролем).
- **Порт**: MySQL по умолчанию использует порт 3306, PostgreSQL — 5432.
- **Переменные окружения**: MySQL использует `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` вместо `POSTGRES_*`.
- **Синтаксис SQL:** В основном совпадает для создания/удаления баз, но могут быть различия в сложных запросах или специфичных настройках.

