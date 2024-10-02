from flask import Flask, request
import telegram
import os

app = Flask(__name__)

# Load the bot token and chat ID from environment variables
BOT_TOKEN = os.getenv("BOT_TOKEN")
CHAT_ID = os.getenv("CHAT_ID")

@app.route('/send_message', methods=['POST'])
def send_message():
    data = request.json
    message = data.get('message', 'No message provided')
    bot = telegram.Bot(token=BOT_TOKEN)
    bot.send_message(chat_id=CHAT_ID, text=message)
    return 'Message sent', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


