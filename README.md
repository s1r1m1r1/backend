# backend



запуск сервера с использование .env файла
```zsh
export $(grep -v '^#' .env | xargs) && dart_frog dev
```