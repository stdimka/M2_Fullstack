## 1. Стандартные заголовки HTTP

    Эти заголовки универсальны и для HTTP, и для WS.
    Они спользуются как в обычных HTTP-запросах, так и в WebSocket-запросах, потому что WebSocket-соединение начинается как обычный HTTP-запрос.
    Однако, 

GET / HTTP/1.1
Host: echo.websocket.org
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0
Accept: */*
Accept-Language: en-US,ru;q=0.7,bg;q=0.3
Accept-Encoding: gzip, deflate, br, zstd

🔹 GET / HTTP/1.1 – запрос на установку WebSocket-соединения (WebSocket использует GET, а не POST или PUT).
🔹 Host: echo.websocket.org – домен, к которому подключается клиент.
🔹 User-Agent – информация о браузере.
🔹 Accept: / – клиент принимает любые типы данных (обычно игнорируется WebSocket-серверами).
🔹 Accept-Language: en-US,ru;q=0.7,bg;q=0.3 – приоритетные языки клиента.
🔹 Accept-Encoding: gzip, deflate, br, zstd – поддерживаемые методы сжатия.

### Как это работает?

- Клиент отправляет обычный HTTP GET-запрос, но с заголовками Upgrade: websocket и Connection: Upgrade.
- Если сервер поддерживает WebSocket, он отвечает 101 Switching Protocols, и с этого момента соединение становится двусторонним (full-duplex) WebSocket-соединением.
- После этого HTTP-заголовки больше не используются — передача данных идёт в бинарном формате WebSocket.

## 2. Критические заголовки WebSocket

Sec-WebSocket-Version: 13
Origin: http://localhost:63342
Sec-WebSocket-Extensions: permessage-deflate
Sec-WebSocket-Key: ZmBnYW8K7XX7hfrwSYToEg==
Connection: keep-alive, Upgrade
Sec-Fetch-Dest: empty
Sec-Fetch-Mode: websocket
Sec-Fetch-Site: cross-site
Pragma: no-cache
Cache-Control: no-cache
Upgrade: websocket

🔹 Sec-WebSocket-Version: 13

    Указывает версию WebSocket-протокола (все современные браузеры поддерживают только версию 13).

🔹 Origin: http://localhost:63342

    Сообщает серверу, откуда исходит запрос (важно для защиты от межсайтовых атак).
    Если сервер не разрешает этот Origin, он может отказать в соединении.

🔹 Sec-WebSocket-Extensions: permessage-deflate

    Клиент предлагает серверу сжатие сообщений для оптимизации трафика.
    Сервер может либо принять этот заголовок, либо отклонить его.

🔹 Sec-WebSocket-Key: ZmBnYW8K7XX7hfrwSYToEg==

    Случайная строка, используемая для защиты от обычных HTTP-запросов.
    Сервер должен ответить заголовком Sec-WebSocket-Accept, который является хешем этой строки.

🔹 Connection: keep-alive, Upgrade

    Upgrade указывает, что клиент хочет переключиться с HTTP на WebSocket.
    Без этого заголовка сервер не поймёт, что запрос относится к WebSocket.

🔹 Upgrade: websocket

    Этот заголовок прямо говорит серверу: "Я хочу использовать WebSocket вместо HTTP".
    Если сервер поддерживает WebSocket, он ответит 101 Switching Protocols.

🔹 Sec-Fetch-Dest: empty / Sec-Fetch-Mode: websocket / Sec-Fetch-Site: cross-site

    Защита от атак типа CSRF и других нежелательных межсайтовых подключений.

🔹 Pragma: no-cache / Cache-Control: no-cache

    Указывает, что клиент не хочет кешировать этот запрос.

### Как сервер должен ответить, если WebSocket-запрос принят?

HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: qW6dZJvEJr7+NsPQa5x5Q5TV2Hk=

    101 Switching Protocols – сервер подтверждает, что переходит на WebSocket.
    Upgrade: websocket – сервер подтверждает переключение.
    Connection: Upgrade – обязательный заголовок.
    Sec-WebSocket-Accept – серверный хеш заголовка Sec-WebSocket-Key.

### Что здесь важно запомнить?

- WebSocket-запрос — это обычный HTTP GET-запрос с Upgrade: websocket.
- Без Sec-WebSocket-Key сервер отвергнет соединение.
- Без Upgrade: websocket сервер даже не поймёт, что клиент хочет WebSocket.
- Заголовок Origin может блокировать WebSocket, если сервер настроен жёстко.
- Если сервер принял соединение, он ответит 101 Switching Protocols.