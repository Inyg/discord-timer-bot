#!/bin/bash
set -e

# Создает папку и скачивает bot.py прямо из GitHub
mkdir -p /opt/discord-bot
cd /opt/discord-bot

# Скачиваем bot.py из репозитория
curl -o bot.py https://raw.githubusercontent.com/Inyg/discord-timer-bot/main/bot.py

# Ввод данных
read -p "Введите токен бота: " TOKEN
read -p "Введите TIMERS (пример: Timer1|123456789012345678|1m|20): " TIMERS

cat <<EOF > .env
DISCORD_TOKEN=$TOKEN
TIMERS=$TIMERS
EOF

# Виртуальная среда
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install discord.py python-dotenv

# Настройка systemd
cat <<EOF > /etc/systemd/system/discordbot.service
[Unit]
Description=Discord Timer Bot
After=network.target

[Service]
User=root
WorkingDirectory=/opt/discord-bot
ExecStart=/opt/discord-bot/venv/bin/python3 bot.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable discordbot
systemctl start discordbot

echo "=== Бот установлен и работает 24/7 ==="
echo "Проверить статус: systemctl status discordbot"
