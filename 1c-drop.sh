#!/bin/sh

echo "Остановка контейнеров..."
./1c-stop.sh || { echo "Ошибка остановки контейнеров"; exit 1; }

echo "Удаление контейнеров..."
docker-compose rm -f || { echo "Ошибка удаления контейнеров"; exit 1; }

# Загружаем переменные окружения
if [ -f $(pwd)/.env ]; then
	source "$(pwd)/.env"
fi

IMAGE=${IMAGE:-1c-server:8.3.27}

echo "Очистка директории 1c-data через Docker..."
docker run --rm -v "$(pwd)/1c-data:/target" "$IMAGE" sh -c "rm -rf /target/* /target/.* 2>/dev/null || true"

echo "Очистка директории 1c-lic через Docker..."
docker run --rm -v "$(pwd)/1c-lic:/target" "$IMAGE" sh -c "rm -rf /target/* /target/.* 2>/dev/null || true"

# Попытка удаления директорий на хосте
echo "Попытка удаления директорий на хосте..."
if [ -d "1c-lic" ]; then
    rm -rf "1c-lic" 2>/dev/null || echo "Не удалось удалить 1c-lic напрямую"
fi

if [ -d "1c-data" ]; then
    rm -rf "1c-data" 2>/dev/null || echo "Не удалось удалить 1c-data напрямую"
fi

# Дополнительная очистка через sudo, если предыдущие попытки не сработали
if [ -d "1c-lic" ] || [ -d "1c-data" ]; then
    echo "Попытка принудительного удаления через sudo..."
    sudo rm -rf "1c-lic" "1c-data" 2>/dev/null
fi

echo "Очистка завершена."
exit 0

