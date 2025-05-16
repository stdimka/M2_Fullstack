# ip a и ifconfig

Команда `ip a` (или `ip addr`) показывает список сетевых интерфейсов и их IP-адресов. 
Она используется для просмотра и управления IP-адресами на сетевых интерфейсах системы.

**Как установить и запустить ip a на разных ОС?**

## 🐧 Linux

Установка (если не установлено):

```
sudo apt update && sudo apt install iproute2  # Для Debian, Ubuntu
sudo yum install iproute                       # Для CentOS, RHEL
sudo pacman -S iproute2                        # Для Arch Linux
```

Запуск:
```
ip a
```
Или только IPv4:
```
ip -4 a
```

Или только IPv6:
```
ip -6 a
```

## 🍏 MacOS

Аналог ip a – команда ifconfig.

Установка (если не установлено):
```
brew install iproute2mac
```

Запуск:
```
ip a   # Если установлен iproute2mac
ifconfig  # Встроенная альтернатива
```

## 🖥️ Windows

Аналог `ip a` – команда `ipconfig`.

Установка: 
- не требуется, встроено в систему.
    
Запуск:
- открыть `cmd` и выполнить:

```
ipconfig /all
```
Или только основные параметры:
```
ipconfig
```

## 📌 Примеры вывода
Linux (`ip a`)
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 48:9e:bd:f5:88:fd brd ff:ff:ff:ff:ff:ff
    altname enp1s0
3: wlo1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 48:e7:da:17:c8:93 brd ff:ff:ff:ff:ff:ff
    altname wlp2s0
    inet 192.168.0.163/24 brd 192.168.0.255 scope global dynamic noprefixroute wlo1
       valid_lft 5611sec preferred_lft 5611sec
    inet6 fe80::56da:2b48:c83b:4935/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:40:df:ce:72 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```
### 1. Интерфейс lo (Loopback)
    lo – это loopback-интерфейс (локальный интерфейс), предназначенный для связи компьютера с самим собой.
    mtu 65536 – максимальный размер пакета (MTU) в байтах.
    state UNKNOWN – неизвестное состояние, но обычно означает, что интерфейс всегда активен.
    inet 127.0.0.1/8 – IPv4-адрес для локального соединения.
    inet6 ::1/128 – IPv6-адрес для локального соединения.
    valid_lft forever – IP-адрес действует бессрочно.

Зачем нужен lo?
    Позволяет программам взаимодействовать внутри одной машины, например, серверу базы данных и веб-серверу.

### 2. Интерфейс eno1 (Ethernet)
    eno1 – сетевой интерфейс, обычно проводной Ethernet (в зависимости от системы может называться eth0, enpXsY).
    NO-CARRIER – кабель не подключен (или сеть неактивна).
    BROADCAST – поддерживает широковещательную передачу.
    MULTICAST – поддерживает рассылку на несколько адресатов.
    state DOWN – интерфейс выключен или нет соединения.
    link/ether 48:9e:bd:f5:88:fd – MAC-адрес сетевой карты.

    Что означает altname enp1s0?
    Альтернативное имя интерфейса, заданное ядром Linux.

### 3. Интерфейс wlo1 (Wi-Fi)
    wlo1 – Wi-Fi-интерфейс (обычно называется wlan0 или wlpXsY).
    state UP – интерфейс включен и работает.
    inet 192.168.0.163/24 – текущий IPv4-адрес устройства.
    brd 192.168.0.255 – широковещательный (broadcast) адрес.
    scope global – глобальный IP-адрес в сети.
    dynamic – IP-адрес получен через DHCP.
    inet6 fe80::.../64 – IPv6-адрес (локальный в пределах сети).
    valid_lft 5611sec – оставшееся время аренды IP-адреса (для DHCP).

### 4. Интерфейс docker0 (виртуальный)
    docker0 – виртуальный интерфейс, созданный Docker для контейнеров.
    state DOWN – неактивен (если контейнеры не запущены).
    inet 172.17.0.1/16 – IP-адрес для внутренней сети Docker.
    valid_lft forever – IP-адрес статический.

    Для чего нужен docker0?
    Позволяет контейнерам Docker взаимодействовать друг с другом через внутреннюю сеть.


MacOS (`ifconfig`)
```
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
    inet 127.0.0.1 netmask 0xff000000
    inet6 ::1 prefixlen 128 
    inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
    ether 98:10:e8:7d:8a:3f
    inet 192.168.0.50 netmask 0xffffff00 broadcast 192.168.0.255
    inet6 fe80::9a10:e8ff:fe7d:8a3f%en0 prefixlen 64 scopeid 0x4
```
- lo0 – аналог lo, локальный интерфейс.
- en0 – основной Ethernet или Wi-Fi интерфейс.


Windows (ipconfig /all)
```
Ethernet adapter Ethernet:
   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Intel(R) Ethernet Connection
   Physical Address. . . . . . . . . : 48-9E-BD-F5-88-FD
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   IPv4 Address. . . . . . . . . . . : 192.168.0.163 (Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.0.1
   DNS Servers . . . . . . . . . . . : 8.8.8.8, 8.8.4.4
   Lease Obtained . . . . . . . . . . : Sunday, February 18, 2025 10:15:32 AM
   Lease Expires . . . . . . . . . . : Sunday, February 18, 2025 4:15:32 PM
```
- Ethernet adapter – основной сетевой интерфейс.
- Physical Address – MAC-адрес.
- IPv4 Address – текущий IP-адрес.
- Default Gateway – шлюз для выхода в интернет.

**Выводы:**

`ip a `в Linux показывает подробную информацию о сетевых интерфейсах, их состоянии и IP-адресах. 
В MacOS используется `ifconfig`, а в Windows – `ipconfig /all`.