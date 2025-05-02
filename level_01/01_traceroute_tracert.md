# traceroute 

`traceroute` – это утилита, которая показывает путь, по которому пакеты данных проходят от вашего компьютера до указанного узла (IP-адреса или домена). Она помогает определить маршрут, измерить задержки на каждом этапе и выявить проблемные участки сети.

**Как установить и запустить traceroute на разных ОС?**
## 🐧 Linux

Установка (если не установлено):
```
sudo apt update && sudo apt install traceroute  # Для Debian, Ubuntu
sudo yum install traceroute                     # Для CentOS, RHEL
sudo pacman -S traceroute                       # Для Arch Linux
```
Запуск:
```
traceroute google.com
```

Или с увеличением максимального количества прыжков:
```
traceroute -m 30 google.com
```

## 🍏 MacOS

Установка (обычно уже установлен, но если нет):

```
brew install traceroute
```
Запуск:
```
traceroute google.com
```

## 🖥️ Windows

Установка: 
- не требуется, встроено в систему.

Запуск (используется `tracert` вместо `traceroute`):
- Открыть `cmd` (Win + R → ввести `cmd` → Enter) и выполнить:
```
tracert google.com
```

Или с увеличением количества прыжков:
```
    tracert -h 30 google.com
```
## 📌 Примеры вывода
### Linux/MacOS (traceroute)
```
traceroute to google.com (142.250.185.78), 30 hops max
1  192.168.1.1 (192.168.1.1)  1.123 ms  1.104 ms  1.087 ms
2  10.10.10.1 (10.10.10.1)  2.345 ms  2.556 ms  2.478 ms
3  192.0.2.1 (192.0.2.1)  12.678 ms  12.789 ms  12.899 ms
```

### Windows (tracert)

Tracing route to google.com [142.250.185.78]
over a maximum of 30 hops:
```
  1     1 ms     1 ms     1 ms  192.168.1.1
  2     3 ms     2 ms     3 ms  10.10.10.1
  3     ***
  4     10 ms    11 ms    10 ms  192.0.2.1
```

Каждая строка – это узел, через который проходит пакет. Если на каком-то этапе значок *, это означает, что узел не отвечает.
