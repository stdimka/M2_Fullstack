# **MySQL** vs **PostgreSQL**

---

### 📊 Различия в работе с датой и временем: MySQL vs PostgreSQL

| Операция / Задача                        | MySQL                                   | PostgreSQL                                  | Комментарий                                       |
| ---------------------------------------- | --------------------------------------- | ------------------------------------------- | ------------------------------------------------- |
| **Текущая дата и время**                 | `NOW()` или `CURRENT_TIMESTAMP`         | `NOW()` или `CURRENT_TIMESTAMP`             | В обоих СУБД одинаково                            |
| **Текущая дата без времени**             | `CURDATE()`                             | `CURRENT_DATE`                              | PostgreSQL не имеет `CURDATE()`                   |
| **Текущее время**                        | `CURTIME()`                             | `CURRENT_TIME`                              | Аналогично                                        |
| **Интервалы (например, +1 день)**        | `DATE_ADD(date, INTERVAL 1 DAY)`        | `date + INTERVAL '1 day'`                   | PostgreSQL использует строковые интервалы         |
| **Вычитание дат (разница)**              | `DATEDIFF(date1, date2)` → в днях       | `date1 - date2` → `interval`                | PostgreSQL даёт `interval`, MySQL — число дней    |
| **Извлечение частей (день, месяц, год)** | `YEAR(date), MONTH(date), DAY(date)`    | `EXTRACT(YEAR FROM date)`                   | PostgreSQL использует `EXTRACT` или `date_part()` |
| **Форматирование даты**                  | `DATE_FORMAT(date, '%Y-%m-%d')`         | `TO_CHAR(date, 'YYYY-MM-DD')`               | Форматы похожи, но синтаксис отличается           |
| **Парсинг из строки**                    | `STR_TO_DATE('2025-06-13', '%Y-%m-%d')` | `TO_DATE('2025-06-13', 'YYYY-MM-DD')`       | PostgreSQL требует точного шаблона                |
| **Таймзоны**                             | Ограниченная поддержка                  | Полная поддержка таймзон (`TIMESTAMPTZ`)    | PostgreSQL мощнее в работе с часовыми поясами     |
| **Типы данных**                          | `DATE`, `DATETIME`, `TIMESTAMP`, `TIME` | `DATE`, `TIME`, `TIMESTAMP`, `TIMESTAMPTZ`  | PostgreSQL различает с/без часового пояса         |
| **Добавление интервалов**                | `DATE_ADD()` и `ADDDATE()`              | Используется `+ INTERVAL '...'` или `age()` | PostgreSQL поддерживает арифметику с `interval`   |

---

### 🔍 Примеры:

#### ➕ Прибавить 7 дней к дате:

* **MySQL:**

```sql
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY);
```

* **PostgreSQL:**

```sql
SELECT NOW() + INTERVAL '7 days';
```

---

#### 📆 Извлечь месяц из даты:

* **MySQL:**

```sql
SELECT MONTH('2025-06-13');  -- → 6
```

* **PostgreSQL:**

```sql
SELECT EXTRACT(MONTH FROM DATE '2025-06-13');  -- → 6
```

---

#### 📐 Разница между двумя датами:

* **MySQL:**

```sql
SELECT DATEDIFF('2025-06-13', '2025-06-01');  -- → 12
```

* **PostgreSQL:**

```sql
SELECT DATE '2025-06-13' - DATE '2025-06-01';  -- → 12
```

---

#### ⏱ Форматирование:

* **MySQL:**

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i');
```

* **PostgreSQL:**

```sql
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI');
```


