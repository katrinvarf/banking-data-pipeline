# Banking Data Pipeline

ETL-проект для загрузки банковских данных из CSV в PostgreSQL, расчёта витрин DM, построения формы 101 и экспорта результата в CSV.

## Стек

- Python 3.7+
- PostgreSQL 13+
- pandas
- SQLAlchemy
- psycopg2

## Структура проекта

```text
.
├── data
│   ├── exports
│   │   └── f101.csv
│   └── raw
│       ├── ft_balance_f.csv
│       ├── ft_posting_f.csv
│       ├── md_account_d.csv
│       ├── md_currency_d.csv
│       ├── md_exchange_rate_d.csv
│       └── md_ledger_account_s.csv
├── README.md
├── requirements.txt
├── sql
│   ├── dm
│   │   ├── ddl
│   │   │   ├── 001_create_schema.sql
│   │   │   └── 002_create_tables.sql
│   │   └── procedures
│   │       └── fill_f101_round_f.sql
│   ├── ds
│   │   ├── ddl
│   │   │   ├── 001_create_schema.sql
│   │   │   └── 002_create_tables.sql
│   │   ├── dml
│   │   │   ├── insert_ft_balance_f.sql
│   │   │   ├── insert_ft_posting_f.sql
│   │   │   ├── insert_md_account_d.sql
│   │   │   ├── insert_md_currency_d.sql
│   │   │   ├── insert_md_exchange_rate_d.sql
│   │   │   └── insert_md_ledger_account_s.sql
│   │   └── procedures
│   │       ├── fill_account_balance_f.sql
│   │       └── fill_account_turnover_f.sql
│   ├── init.sql
│   ├── logs
│   │   └── ddl
│   │       ├── 001_create_schema.sql
│   │       └── 002_create_tables.sql
│   └── stage
│       └── ddl
│           └── 001_create_schema.sql
└── src
    ├── build_dm.py
    ├── build_f101.py
    ├── export_data.py
    ├── load_data.py
    └── logging_utils.py
```

## Инициализация базы данных

Для создания схем, таблиц и процедур выполните:

```bash
psql -h <host> -U <user> -d <db_name> -f sql/init.sql
```
Где:

- `<host>` — адрес PostgreSQL (например, localhost)
- `<user>` — пользователь базы данных
- `<db_name>` — имя базы данных

Например:
```bash
psql -h localhost -U postgres -d banking_dwh -f sql/init.sql
```

## Настройка

1. Создать виртуальное окружение
2. Установить зависимости:
```bash
pip install -r requirements.txt
```
3. Создать `.env` на основе `.env.example`
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_db
DB_USER=your_user
DB_PASSWORD=your_password
```

## Запуск

### 1. Загрузка данных в детальный слой DS
```bash
python src/load_data.py
```

### 2. Расчет витрин (DM)
```bash
python src/build_dm.py
```

### 3. Расчет формы 101
```bash
python src/build_f101.py
```

### 4. Экспорт и импорт данных
```bash
python src/export_data.py
```

## Логирование

Для логирования используется таблица: `logs.process_log`

Фиксируется:
- название процесса
- статус выполнения (STARTED / SUCCESS / FAILED)
- время начала и окончания
- количество обработанных строк
- текст ошибки (при наличии)

## Примечания

- Папка `data/exports` создаётся автоматически при выполнении `export_data.py`
- Файлы экспорта не коммитятся в репозиторий