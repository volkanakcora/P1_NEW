import requests

def notify_via_telegram(message):
    url = "http://telegram-bot-service/send_message"
    data = {"message": message}
    response = requests.post(url, json=data)
    return response.status_code

def check_stock_price(stock_symbol, target_price):
    current_price = get_current_stock_price(stock_symbol)
    if current_price >= target_price:
        message = f'Stock Alert: The stock price of {stock_symbol} has reached {current_price}!'
        notify_via_telegram(message)

def get_current_stock_price(stock_symbol):
    # Placeholder for your stock price fetching logic
    return 150  # Example price

if __name__ == '__main__':
    stock_symbol = 'XYZ'
    target_price = 100
    check_stock_price(stock_symbol, target_price)


