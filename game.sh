# Keep functionality from previous steps
echo "Welcome to the True or False Game!"
curl --silent --cookie-jar cookie.txt --user your_username:your_password http://127.0.0.1:8000/login && \
echo "Login message: $(curl --silent --cookie cookie.txt http://127.0.0.1:8000/endpoint)"

# Use curl to connect to the game endpoint, send session cookie, and print the question and answer
response=$(curl --silent --cookie cookie.txt http://127.0.0.1:8000/game)
question=$(echo "$response" | jq -r .question)
answer=$(echo "$response" | jq -r .answer)
echo "Response: {\"question\": \"$question\", \"answer\": \"$answer\"}"

