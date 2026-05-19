#!/bin/sh

# 1. Очистка кэша (папки .dart_frog), так как команды 'dart_frog clean' не существует
# Это помогает при ошибках 'Invalid kernel binary format version'
echo "🧹 Cleaning Dart Frog cache (.dart_frog)..."
rm -rf .dart_frog

# 2. Проверка наличия .env файла
if [ ! -f .env ]; then
  echo "❌ Error: .env file not found."
  exit 1
fi

# 3. Загрузка переменных и запуск сервера
echo "🚀 Starting Dart Frog with .env variables..."
env $(grep -v '^#' .env | xargs) dart_frog dev