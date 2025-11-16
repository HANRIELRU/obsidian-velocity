#!/bin/bash

# Проверяем, установлена ли Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Installing OpenJDK 21..."
    sudo dnf update && sudo dnf install -y openjdk-21-jre
fi

# Скачиваем Velocity если нет
if [ ! -f "velocity.jar" ]; then
    echo "📥 Downloading Velocity..."
    wget -O velocity.jar https://api.papermc.io/v2/projects/velocity/versions/3.4.0-SNAPSHOT/builds/557/downloads/velocity-3.4.0-SNAPSHOT-557.jar
fi

echo "🚀 Starting Velocity..."
java -Xms512M -Xmx1G -jar velocity.jar