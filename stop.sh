#!/bin/bash

echo "🛑 Stopping Velocity Proxy..."

# Ищем процесс Velocity
PID=$(ps aux | grep velocity.jar | grep -v grep | awk '{print $2}')

if [ -z "$PID" ]; then
    echo "✅ Velocity is not running"
    exit 0
fi

echo "📝 Sending graceful shutdown to PID: $PID"
kill $PID

# Ждем завершения
TIMEOUT=30
COUNT=0
while kill -0 $PID 2>/dev/null; do
    sleep 1
    COUNT=$((COUNT + 1))
    if [ $COUNT -ge $TIMEOUT ]; then
        echo "❌ Force killing Velocity..."
        kill -9 $PID
        break
    fi
done

echo "✅ Velocity stopped successfully"