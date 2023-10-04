# Домашнее задание к занятию 4 «Работа с roles»

Ваша цель — разбить ваш playbook на отдельные roles.

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей.

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
```md
Lighthouse
=========

This role can install Lighthouse on Centos

Role Variables
--------------

| vars | description                      |
|------|----------------------------------|
| 0.1  | Version of Lighthouse to install |

Dependencies
------------

- GIT

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: lighthouse }

License
-------

MIT

Author Information
------------------

Vladislav Plotnikov
```
```md
Vector
=========

This role can install Vector on Centos


Role Variables
--------------

| vars   | description                  |
|--------|------------------------------|
| 0.32.1 | Version of Vector to install |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vector }

License
-------

MIT

Author Information
------------------

Vladislav Plotnikov
```
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.

```yaml
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.13"
  name: clickhouse

- src: git@github.com:bosone87/vector-role.git
  scm: git
  name: vector

- src: git@github.com:bosone87/lighthouse-role.git
  scm: git
  name: lighthouse
```

9.  Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
```yaml
- name: Install Clickhouse
  hosts: clickhouse
  roles: 
    - clickhouse

- name: Install Vector
  hosts: vector
  roles: 
    - vector

- name: Install lighthouse
  hosts: lighthouse
  pre_tasks:
    - name: Lighthouse | Install dependencies
      become: true
      ansible.builtin.yum:
        name: git
        state: present
  roles: 
    - lighthouse
```

10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---