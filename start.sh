#!/bin/bash

# Конфигурация
SERVER_JAR="velocity.jar"
JAVA_MEMORY="-Xms512M -Xmx1G"
JAVA_OPTS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch"
VELOCITY_VERSION="3.4.0"
VELOCITY_BUILD="557"


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting Velocity Proxy...${NC}"

# Проверяем Java
check_java() {
    if ! command -v java &> /dev/null; then
        echo -e "${RED}❌ Java is not installed or not in PATH${NC}"
        echo "Please install OpenJDK 17 or higher:"
        echo "  Ubuntu/Debian: sudo apt install openjdk-17-jre"
        echo "  CentOS/RHEL: sudo yum install java-17-openjdk"
        exit 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 17 ]; then
        echo -e "${RED}❌ Java version $JAVA_VERSION is too old. Velocity requires Java 17 or higher.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Java $JAVA_VERSION detected${NC}"
}

# Скачиваем Velocity
download_velocity() {
    if [ ! -f "$SERVER_JAR" ]; then
        echo -e "${YELLOW}📥 Downloading Velocity ${VELOCITY_VERSION} (build ${VELOCITY_BUILD})...${NC}"
        wget -q -O "$SERVER_JAR" \
            "https://api.papermc.io/v2/projects/velocity/versions/${VELOCITY_VERSION}/builds/${VELOCITY_BUILD}/downloads/velocity-${VELOCITY_VERSION}-${VELOCITY_BUILD}.jar"
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Failed to download Velocity${NC}"
            exit 1
        fi
        echo -e "${GREEN}✅ Velocity downloaded successfully${NC}"
    else
        echo -e "${GREEN}✅ Velocity JAR found${NC}"
    fi
}

# Основная функция
main() {
    echo "=========================================="
    echo "    Velocity Proxy Starter"
    echo "=========================================="
    
    check_java
    download_velocity
    
    echo -e "${GREEN}🎯 Starting Velocity with ${JAVA_MEMORY}${NC}"
    echo -e "${YELLOW}📝 Logs: tail -f logs/latest.log${NC}"
    echo -e "${YELLOW}🛑 Stop with: Ctrl+C or ./stop.sh${NC}"
    echo "=========================================="
    
    # Запускаем Velocity
    java $JAVA_MEMORY $JAVA_OPTS -jar "$SERVER_JAR"
}

# Обработка сигналов для graceful shutdown
trap 'echo -e "\n${YELLOW}🛑 Shutting down Velocity...${NC}"; exit 0' INT TERM

# Запуск
main