# Массивы в PostgreSQL

В PostgreSQL массивы — это встроенный тип данных, который позволяет хранить **несколько значений одного типа в одной ячейке таблицы**. 
- PostgreSQL поддерживает до 6 измерений в массивах.
- Элементы в массиве должны быть одного типа.

---

### 🔹 Объявление массива

```
-- Одномерный массив целых чисел
my_column INTEGER[];

-- Двумерный массив строк
my_column TEXT[][];

-- Массив фиксированной длины
my_column INTEGER[3];
```

---

### 🔹 Создание таблицы с массивом

```sql
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name TEXT,
    tags TEXT[]  -- массив тегов
);
```

---

### 🔹 Вставка значений в массив

```sql
INSERT INTO example (name, tags)
VALUES ('Laptop', ARRAY['electronics', 'computer', 'tech']);
```

Или:

```sql
INSERT INTO example (name, tags)
VALUES ('Phone', '{mobile,tech}');
```

---

### 🔹 Доступ к элементам массива

Индекс первого элемента 1, а не 0.

```sql
-- Получить первый тег
SELECT tags[1] FROM example;

-- Обновить второй тег
UPDATE example SET tags[2] = 'updated' WHERE name = 'Laptop';
```

---

### 🔹 Основные операторы для работы с массивами

| Оператор | Что делает                                                | Пример запроса (SQL)                      | Пример результата             |
|----------|-------------------------------------------------------|-----------------------------------------------|-------------------------------|
| `ANY`    | Проверяет, встречается ли значение в массиве          | SELECT 1 WHERE 'a' = ANY(ARRAY['a','b','c']); | 1 (значение есть)            |
| `ALL`    | Проверяет, удовлетворяет ли значение всем элементам   | SELECT 1 WHERE 5 > ALL(ARRAY[1,2,3]);         | 1 (все < 5)                   |
| `@>`     | Массив слева содержит массив справа                   | SELECT 1 WHERE ARRAY[1,2,3] @> ARRAY[2,3];    | 1 (да, содержит)             |
| `<@`     | Массив слева содержится в массиве справа              | SELECT 1 WHERE ARRAY[2,3] <@ ARRAY[1,2,3];    | 1 (да, содержится)           |
| `&&`     | Массивы пересекаются, есть хотя бы один общий элемент | SELECT 1 WHERE ARRAY[1,2] && ARRAY[2,3];      | 1 (общий элемент: 2)         |
| `\|\|`   | Объединяет два массива                                | SELECT ARRAY[1,2] \|\| ARRAY[3,4];            | {1,2,3,4} (объединённый массив) |


#### Создадим таблицу для тестирования массивов

```sql
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title TEXT,
    tags TEXT[]
);

INSERT INTO books (title, tags) VALUES
('SQL Basics',     ARRAY['sql', 'database']),
('Advanced Python',ARRAY['python', 'code']),
('Web Dev',        ARRAY['html', 'css', 'javascript']),
('Mixed',          ARRAY['sql', 'python']);
```


#### Пример: `ANY`
```sql 
SELECT title FROM books WHERE 'sql' = ANY(tags);  -- SQL Basics, Mixed
```

#### Пример: `ALL`
```sql 
SELECT 1 WHERE 10 > ALL(ARRAY[1, 5, 9]);  -- 1
-- (возвращает true, так как 10 больше всех элементов указанного массива)
```

#### Пример: `@>` (содержит)
(вернуть строки, где массив `tags` содержит значение 'python')
```sql 
SELECT title FROM books WHERE tags @> ARRAY['python'];  -- Advanced Python, Mixed
```
 
#### Пример: `<@` (содержится в)
(вернуть строки, где значение 'python'содержится в массиве `tags`)
```sql 
SELECT title FROM books WHERE ARRAY['python'] <@ tags;  -- Advanced Python, Mixed
```

#### Пример: `&&` (пересекается)
(вернуть строки, где в массиве `tags` содержится хотя бы одно значение из массива {'html', 'sql'})
```sql 
SELECT title FROM books WHERE tags && ARRAY['html', 'sql']; --  SQL Basics, Web Dev, Mixed
```

#### Пример: `||` (конкатенация)
Вернуть конкатенацию массива `tags` с массивом `{'new'}` для строки, где `title = 'SQL Basics'` 
```sql 
SELECT tags || ARRAY['new'] FROM books WHERE title = 'SQL Basics';  -- {sql, database, new}
```

### Некоторые функции для работы с массивами:

| Функция                       | Описание                    | Пример                                             | Результат     |
|------------------------------|-----------------------------|-----------------------------------------------------|---------------|
| `unnest(array)`              | Преобразует массив в строки | `SELECT unnest(ARRAY[1,2,3]);`                      | 1, 2, 3       |
| `array_length(array, dim)`   | Длина массива по измерению  | `SELECT array_length(ARRAY[1,2,3], 1);`             | 3             |
| `array_append(array, elem)`  | Добавить элемент            | `SELECT array_append(ARRAY[1,2], 3);`               | {1,2,3}       |
| `array_prepend(elem, array)` | Добавить в начало           | `SELECT array_prepend(0, ARRAY[1,2]);`              | {0,1,2}       |
| `array_remove(array, value)` | Удалить элемент             | `SELECT array_remove(ARRAY[1,2,3], 2);`             | {1,3}         |
| `array_position(array, value)` | Индекс первого вхождения  | `SELECT array_position(ARRAY[1,2,3], 2);`           | 2             |
| `array_to_string(array, sep)` | Объединение в строку       | `SELECT array_to_string(ARRAY['a','b','c'], ',');`  | 'a,b,c'       |
| `string_to_array(str, sep)`  | Строка в массив             | `SELECT string_to_array('a,b,c', ',');`             | {'a','b','c'} |
