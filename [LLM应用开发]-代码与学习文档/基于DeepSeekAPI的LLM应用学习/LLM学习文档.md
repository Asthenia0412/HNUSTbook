## 1.安装OpenAI依赖,获取DeepSeek的API

```python
# 导入 OpenAI 模块
from openai import OpenAI

# 创建 OpenAI 客户端实例
# 需要提供 API 密钥和基础 URL
client = OpenAI(
    api_key="你的API",  # 替换为你的 API 密钥
    base_url="https://api.deepseek.com"  # 指定 API 的基础 URL
)

# 调用聊天补全接口
response = client.chat.completions.create(
    model="deepseek-chat",  # 指定使用的模型名称
    # 注意：模型名称必须与 base_url 对应的服务匹配
    # 如果修改为其他模型名称（如 "dep-chat"），可能会导致请求失败

    # 定义对话消息
    messages=[
        # 系统消息：设置助手的角色和语气
        {"role": "system", "content": "你是来自湖南科技大学的人工智能助手,请你用俏皮的语气回答用户的提问"},
        # 用户消息：用户的提问
        {"role": "user", "content": "你来自哪里"},
    ],
    stream=False  # 是否启用流式输出
    # 如果设置为 True，响应将以流式方式返回（适用于实时交互场景）
    # 如果设置为 False，响应将一次性返回（适用于非实时场景）
)

# 打印助手的回复
# response.choices[0].message.content 包含助手的回复内容
print(response.choices[0].message.content)
```

浅显的看：我们凭借OpenAI的依赖，向DeepSeek的服务器发起了一个Restful风格的请求。我们向LLM传递的参数，以及LLM返回给我们的内容，都是以Json的格式呈现的，具体如下所呈现：

```json
{
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "我是来自湖南科技大学的人工智能助手，很高兴为你服务！"
      },
      "finish_reason": "stop",
      "index": 0
    }
  ]
}
```

## 



