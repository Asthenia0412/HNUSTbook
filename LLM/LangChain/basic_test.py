from openai import OpenAI

client = OpenAI(api_key="sk-54579e3b75ef44c78b6229f5175581ba", base_url="https://api.deepseek.com")

try:
    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[
            {"role": "system", "content": "You are a helpful assistant"},
            {"role": "user", "content": "Hello"},
        ],
        stream=False
    )
    print(response.choices[0].message.content)
except Exception as e:
    print(f"API Error: {e}")
    print("Please check your API key balance or try again later.")