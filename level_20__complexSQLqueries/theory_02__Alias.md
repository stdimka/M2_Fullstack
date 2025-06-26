# Alias (Псевдонимы) в MySQL

Alias (псевдонимы) используются для присвоения временных имен колонкам или таблицам в SQL-запросах. Это помогает сделать результаты более читаемыми или сокращать длинные имена.

## 1. Alias для колонок (AS)

Используется для переименования вывода в SELECT.

```
SELECT name AS employee_name, salary AS monthly_salary
FROM employees;
```

🔹 Как это работает:

    name временно переименовывается в employee_name.
    salary отображается как monthly_salary.

📌 Замечания:

    AS можно не писать, но с ним код читается лучше:
```
SELECT name employee_name, salary monthly_salary FROM employees;
```

Если alias содержит пробелы или спецсимволы, его берут в кавычки:

    SELECT name AS "Employee Name" FROM employees;

    (но лучше избегать пробелов в alias).

## 2. Alias для таблиц

Используется для сокращения длинных имен таблиц, особенно при JOIN.
```
SELECT e.name, d.department_name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id;
```
🔹 Как это работает:

    employees заменяется на e, а departments на d.
    Теперь можно писать e.name вместо employees.name.

📌 Замечания:

    AS в alias для таблиц необязателен:

    FROM employees e JOIN departments d ON e.department_id = d.id;

    Alias не влияет на исходные имена таблиц и колонок в базе.

## 3. Alias с выражениями

Часто alias используется в вычислениях:
```
SELECT name, salary * 12 AS annual_salary
FROM employees;
```
🔹 Как это работает:

    salary * 12 (годовая зарплата) отображается как annual_salary.

📌 Вывод:

    Alias помогают делать SQL-запросы короче и понятнее.
    Применяются к колонкам и таблицам.
    Лучше писать AS, но для таблиц его можно опускать.

