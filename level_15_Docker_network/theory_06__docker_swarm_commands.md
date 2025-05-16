# 📋 Список команд для Docker Swarm

## 🔹 Кластер (Swarm)

| Команда | Что делает |
|:--------|:-----------|
| `docker swarm init` | Инициализирует новый кластер (на текущей машине). |
| `docker swarm join` | Присоединяет узел к существующему кластеру. |
| `docker swarm leave` | Выводит узел из кластера. (`--force` — принудительно для менеджера) |
| `docker swarm join-token manager` | Показывает команду для присоединения нового менеджера. |
| `docker swarm join-token worker` | Показывает команду для присоединения нового воркера. |
| `docker swarm update` | Обновляет параметры текущего Swarm-кластера. |
| `docker swarm ca` | Управляет сертификатами кластера (обновление, ротация). |

---

## 🔹 Узлы (Nodes)

| Команда | Что делает |
|:--------|:-----------|
| `docker node ls` | Список всех узлов кластера. |
| `docker node inspect <node>` | Подробная информация об узле. |
| `docker node update --availability active/drain/pause <node>` | Изменить доступность узла (активный, не принимает задачи и т.д.). |
| `docker node promote <node>` | Повысить узел до **manager**. |
| `docker node demote <node>` | Понизить узел до **worker**. |
| `docker node rm <node>` | Удалить узел из кластера. |

---

## 🔹 Стек (Stack)

| Команда | Что делает |
|:--------|:-----------|
| `docker stack deploy -c docker-compose.yml <stack_name>` | Разворачивает стек по описанию в YAML-файле. |
| `docker stack ls` | Список всех стеков. |
| `docker stack services <stack_name>` | Показать все сервисы в стеке. |
| `docker stack ps <stack_name>` | Показать все задачи стека (запущенные контейнеры). |
| `docker stack rm <stack_name>` | Удалить стек целиком. |

---

## 🔹 Сервисы (Service)

| Команда | Что делает |
|:--------|:-----------|
| `docker service create ...` | Создать новый сервис вручную. |
| `docker service ls` | Список всех сервисов в кластере. |
| `docker service inspect <service>` | Подробная информация о сервисе. |
| `docker service ps <service>` | Список задач (реплик) сервиса. |
| `docker service update ...` | Обновить параметры сервиса (например, образ, количество реплик). |
| `docker service scale <service=replicas>` | Масштабировать сервис. |
| `docker service logs <service>` | Просмотреть логи сервиса. |
| `docker service rm <service>` | Удалить сервис. |

---

## 🔹 Задачи (Tasks)

| Команда | Что делает |
|:--------|:-----------|
| `docker service ps <service>` | Список задач сервиса. |
| `docker inspect <task_id>` | Информация о конкретной задаче (контейнере). |

---

## 🔹 Контейнеры

> В Swarm **контейнеры** создаются автоматически на основе задач сервиса, но можно посмотреть их как обычно.

| Команда | Что делает |
|:--------|:-----------|
| `docker ps` | Все запущенные контейнеры (включая те, что в Swarm). |
| `docker inspect <container_id>` | Подробная информация о контейнере. |

**Важно:**  
Имена контейнеров в Swarm обычно имеют вид:  
```
<stack>_<service>.<replica_number>.<task_id>
```
например: `mystack_web.1.abcd123456`

---

# 🧠 Итоговая структура работы с Swarm

| Что хотите сделать | Блок команд |
|:-------------------|:------------|
| Настроить кластер | `docker swarm init`, `docker node ls`, `docker swarm join` |
| Развернуть приложение | `docker stack deploy`, `docker stack services` |
| Управлять сервисами | `docker service ls`, `docker service scale`, `docker service update` |
| Управлять узлами | `docker node promote`, `docker node update`, `docker node rm` |
| Удалить всё | `docker stack rm <stack_name>` |

