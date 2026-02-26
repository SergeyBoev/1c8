FROM ubuntu:22.04

LABEL maintainer="SergeyBoev@gmail.com"
LABEL description="1C:Enterprise 8.3.27 Server"

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y \
        unzip \
        libfontconfig1 \
        libfreetype6 \
        tzdata \
        locales \
        sudo && \
    rm -rf /var/lib/apt/lists/*


# Локализация
RUN locale-gen ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8


# Создание пользователя 1С
RUN useradd -m -d /opt/1C -s /bin/bash usr1cv8 && \
    echo 'usr1cv8:usr1cv8' | chpasswd && \
    adduser usr1cv8 sudo


# Директории
RUN mkdir -p /opt/1C/v8.3/x86_64 && \
    chown -R usr1cv8:usr1cv8 /opt/1C


# Копирование DEB‑пакетов (из распакованного ZIP)
COPY debs/ /tmp/debs/


# Установка 1С из DEB‑пакетов
RUN cd /tmp/debs && \
    dpkg -i 1c-enterprise*common*.deb && \
    dpkg -i 1c-enterprise*server*.deb && \
    dpkg -i 1c-enterprise*ws*.deb && \
    rm -rf /tmp/debs


# Очистка
RUN apt-get clean

USER usr1cv8

WORKDIR /opt/1cv8/x86_64/8.3.27.1786

