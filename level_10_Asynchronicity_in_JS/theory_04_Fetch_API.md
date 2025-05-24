# Fetch API

**Fetch API** — это современный интерфейс JavaScript для выполнения HTTP-запросов к серверу.  
Он предоставляет более мощный, гибкий и читаемый способ работать с запросами и ответами по сравнению с устаревшим XMLHttpRequest.

## Fetch позволяет:

- Отправлять HTTP-запросы (GET, POST, PUT, DELETE и др.)
- Получать ответы от сервера
- Работать с асинхронными данными (через Promise)
- Загружать данные в разных форматах: JSON, текст, HTML, Blob, FormData и др.

## Немного истории ;-)

Для того, чтобы по достоинству оценить плюсы Fetch API, стоит рассмотреть другие (устаревшие) интерфейсы:

### Устаревший подход 1: XMLHttpRequest

```
const xhr = new XMLHttpRequest();
xhr.open("GET", "https://catfact.ninja/fact");

xhr.onload = function () {
    if (xhr.status === 200) {
        const response = JSON.parse(xhr.responseText);
        console.log("Факт о коте 🐱:", response.fact);
        document.body.innerHTML += `<p>🐱 ${response.fact}</p>`;
    } else {
        console.error("Ошибка запроса:", xhr.status);
    }
};

xhr.onerror = function () {
    console.error("Сетевая ошибка");
};

xhr.send();
```

### 📌 Минусы XMLHttpRequest:

- Много "шумного" кода (части кода, которые не несут смысловой нагрузки и не решают основную задачу, но всё равно обязательны для написания):
  - xhr.open, xhr.onload, xhr.onerror, xhr.send — обязательны для структуры, но не отражают сути задачи
  - JSON.parse — тоже вручную
  - Проверка статуса — вручную

- Нет поддержки Promise (сложно использовать с async/await)
- Много ручной обработки: статус, преобразование JSON, ошибки

### Устаревший подход 2: jQuery AJAX

Перед выполнением скрпита необходимо загрузись библиотеку jquery:
`<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>`

```
$.ajax({
    url: "https://catfact.ninja/fact",
    method: "GET",
    success: function (data) {
        console.log("Факт о коте:", data.fact);
        document.body.innerHTML += `<p>🐱 ${data.fact}</p>`;
    },
    error: function (xhr, status, error) {
        console.error("Ошибка:", error);
    }
});
```

### 📌 Минусы jQuery $.ajax():

- Требуется библиотека jQuery
- Код проще, чем XMLHttpRequest, но всё ещё громоздкий
- е встроен в стандарт JavaScript

### Современный подход: Fetch API

```
fetch("https://catfact.ninja/fact")
    .then(response => {
        if (!response.ok) throw new Error("Ошибка HTTP: " + response.status);
        return response.json();
    })
    .then(data => {
        console.log("Факт о коте:", data.fact);
        document.body.innerHTML += `<p>🐱 ${data.fact}</p>`;
    })
    .catch(error => {
        console.error("Ошибка запроса:", error);
    });
```

### 📌 Плюсы Fetch API:

- Лаконичный и понятный код
- Использует Promise — легко комбинировать и обрабатывать
- Совместим с async/await
- Встроен в браузеры — не требует внешних библиотек

### Тот же вариант с использованием async/await   

```
async function getCatFact() {
    try {
        const response = await fetch('https://catfact.ninja/fact');
        if (!response.ok) {
          throw new Error(`Ошибка HTTP: ${response.status}`);
        }
        const data = await response.json();
        document.body.innerHTML += `<p>${data.fact}</p>`;
    } catch (error) {
        console.error('Ошибка при получении факта:', error);
    }
}

// Запускаем функцию
getCatFact();
```
