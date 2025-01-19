# 一：ES入门

## 1.ES与MySQL的文件层次对应

| MYSQL  | elasticsearch                                        |
| ------ | ---------------------------------------------------- |
| Table  | Index(创建索引库得确定mapping映射-类似MySQL的表结构) |
| row    | document                                             |
| column | field                                                |

## 2.分词器的选用

Elasticsearch 中的 `english` 分词器和 `ik_smart` 分词器是两种不同的分词器，分别针对英文和中文文本设计。以下是它们的区别，并通过 HTTP 请求示例展示它们的分词效果。

---

### 1. **设计目标**
- **`english` 分词器**：
  - 专为英文文本设计。
  - 支持词干提取（stemming）、停用词过滤（stop words）和大小写转换。
- **`ik_smart` 分词器**：
  - 专为中文文本设计。
  - 采用智能分词模式，尽可能合并词语，减少冗余。

---

### 2. **分词方式**
- **`english` 分词器**：
  - 按空格和标点符号分词。
  - 支持词干提取（如将 "running" 转为 "run"）。
  - 支持停用词过滤（如去除 "the"、"is" 等常见词）。
  - 支持大小写转换（通常将单词转为小写）。
- **`ik_smart` 分词器**：
  - 采用智能分词模式，尽可能合并词语。
  - 不支持词干提取或停用词过滤。
  - 主要处理中文文本。

---

### 3. **HTTP 请求示例**

#### **`english` 分词器示例**
以下是一个使用 `english` 分词器的 HTTP 请求示例：

```http
POST /_analyze
{
  "analyzer": "english",
  "text": "The quick brown foxes are jumping over the lazy dog"
}
```

**响应结果**：
```json
{
  "tokens": [
    {
      "token": "quick",
      "start_offset": 4,
      "end_offset": 9,
      "type": "<ALPHANUM>",
      "position": 1
    },
    {
      "token": "brown",
      "start_offset": 10,
      "end_offset": 15,
      "type": "<ALPHANUM>",
      "position": 2
    },
    {
      "token": "fox",
      "start_offset": 16,
      "end_offset": 21,
      "type": "<ALPHANUM>",
      "position": 3
    },
    {
      "token": "jump",
      "start_offset": 26,
      "end_offset": 33,
      "type": "<ALPHANUM>",
      "position": 5
    },
    {
      "token": "lazi",
      "start_offset": 41,
      "end_offset": 45,
      "type": "<ALPHANUM>",
      "position": 8
    },
    {
      "token": "dog",
      "start_offset": 46,
      "end_offset": 49,
      "type": "<ALPHANUM>",
      "position": 9
    }
  ]
}
```

**说明**：
- 停用词（如 "the"、"are"、"over"）被过滤。
- 词干提取生效（如 "foxes" 转为 "fox"，"jumping" 转为 "jump"）。
- 所有单词转为小写。

---

#### **`ik_smart` 分词器示例**
以下是一个使用 `ik_smart` 分词器的 HTTP 请求示例：

```http
POST /_analyze
{
  "analyzer": "ik_smart",
  "text": "中华人民共和国"
}
```

**响应结果**：
```json
{
  "tokens": [
    {
      "token": "中华人民共和国",
      "start_offset": 0,
      "end_offset": 7,
      "type": "CN_WORD",
      "position": 0
    }
  ]
}
```

**说明**：
- `ik_smart` 将整个短语 "中华人民共和国" 作为一个词输出，符合中文语义。

---

### 4. **主要区别总结**

| 特性           | `english` 分词器               | `ik_smart` 分词器            |
| -------------- | ------------------------------ | ---------------------------- |
| **设计语言**   | 英文                           | 中文                         |
| **分词方式**   | 按空格和标点分词，支持词干提取 | 智能分词，合并词语           |
| **停用词过滤** | 支持                           | 不支持                       |
| **大小写转换** | 支持                           | 不支持                       |
| **适用场景**   | 英文文本（如日志、文档）       | 中文文本（如新闻、社交媒体） |

---

### 5. **如何选择分词器**
- 如果处理的是**英文文本**，使用 `english` 分词器。
- 如果处理的是**中文文本**，使用 `ik_smart` 分词器。

通过上述 HTTP 请求示例，可以直观地看到两者的分词效果和区别。

## 3.自定义词典与违禁词库

在 Elasticsearch 中使用 Docker 部署时，如果需要修改自定义词典或违禁词库（例如 IK 分词器的词典），可以通过挂载本地文件到容器中的方式实现。以下是详细步骤：

---

### 1. **IK 分词器的自定义词典和违禁词库**
IK 分词器的词典文件通常包括：
- **主词典**：`main.dic`
- **停用词词典**：`stopword.dic`
- **扩展词典**：`ext.dic`
- **违禁词库**：`prohibit.dic`

这些文件通常位于 IK 分词器的 `config` 目录下，路径为：  
`/usr/share/elasticsearch/plugins/ik/config/`

---

### 2. **修改自定义词典和违禁词库的步骤**

#### **步骤 1：准备本地词典文件**
在本地创建一个目录（如 `ik-config`），并将需要修改的词典文件放入其中。例如：
```
ik-config/
├── ext.dic
├── stopword.dic
└── prohibit.dic
```

- **`ext.dic`**：扩展词典，每行一个词。
- **`stopword.dic`**：停用词词典，每行一个词。
- **`prohibit.dic`**：违禁词库，每行一个词。

#### **步骤 2：修改词典文件**
编辑本地词典文件，添加或删除需要的词汇。例如：
- 在 `ext.dic` 中添加新词：
  ```
  自定义词1
  自定义词2
  ```
- 在 `stopword.dic` 中添加停用词：
  ```
  的
  是
  ```
- 在 `prohibit.dic` 中添加违禁词：
  ```
  违禁词1
  违禁词2
  ```

#### **步骤 3：启动 Elasticsearch 容器并挂载词典文件**
使用 Docker 启动 Elasticsearch 容器时，将本地词典文件挂载到容器中的 IK 分词器配置目录。例如：

```bash
docker run -d \
  --name elasticsearch \
  -v $(pwd)/ik-config:/usr/share/elasticsearch/plugins/ik/config \
  -e "discovery.type=single-node" \
  -p 9200:9200 \
  elasticsearch:8.10.0
```

**说明**：
- `-v $(pwd)/ik-config:/usr/share/elasticsearch/plugins/ik/config`：将本地的 `ik-config` 目录挂载到容器中的 IK 分词器配置目录。
- `elasticsearch:8.10.0`：根据实际使用的 Elasticsearch 版本调整。

#### **步骤 4：重启 Elasticsearch 容器**
如果容器已经运行，需要重启容器以使配置生效：
```bash
docker restart elasticsearch
```

#### **步骤 5：验证词典是否生效**
使用以下 HTTP 请求测试分词效果：
```http
POST /_analyze
{
  "analyzer": "ik_smart",
  "text": "这是一个自定义词1的测试"
}
```

如果 `ext.dic` 中包含了 "自定义词1"，则分词结果会将其作为一个整体输出。

---

### 3. **动态更新词典**
如果需要在不重启 Elasticsearch 的情况下更新词典，可以使用 IK 分词器的动态词典功能。

#### **步骤 1：配置远程词典**
在 `ik/config/IKAnalyzer.cfg.xml` 中配置远程词典地址。例如：
```xml
<entry key="remote_ext_dict">http://your-server/ext.dic</entry>
<entry key="remote_ext_stopwords">http://your-server/stopword.dic</entry>
```

#### **步骤 2：更新词典文件**
将词典文件上传到配置的远程地址（如 `http://your-server/ext.dic`），IK 分词器会定期检查并加载更新。

#### **步骤 3：验证更新**
更新远程词典文件后，IK 分词器会自动加载新词典，无需重启 Elasticsearch。

---

### 4. **注意事项**
- **文件编码**：确保词典文件的编码为 `UTF-8`，否则可能导致分词异常。
- **文件权限**：挂载本地文件时，确保文件权限正确，容器可以读取。
- **Elasticsearch 版本**：不同版本的 Elasticsearch 和 IK 分词器可能存在配置差异，请参考官方文档。

---

通过以上步骤，你可以在 Docker 中轻松修改 IK 分词器的自定义词典和违禁词库，并实现动态更新。

## 4.Mapping映射的定义

常见Mapping属性介绍：Mapping是对索引库中文档的约束

- Type：字段数据类型：常见的简单类型有
  - 字符串：text(可分词的文本),keyword(精确值，例如：国家，品牌，ip地址)
  - 数值：long,Integer,short,byte,double,float
  - 布尔：boolean
  - 日期：date
  - 对象：object
- **index**：是否创建索引，默认为true。这里的索引指的是倒排索引
- **analyzer**：使用哪种分词器，只结合text发挥作用
- **properties**：该字段的子字段

1. **问：Mapping常见的属性有哪些？** **答：**type（数据类型） **index**(是否倒排索引) **analyzer**(分词器) **properties**(子字段)
2. **问：Type常见的有哪些？** **答：**text，keyword,long,integer,short,double,float,boolean,date,object

## 5.创建索引库

以下是一个**博客类型**的索引库创建示例。这个索引库包含常见的博客字段，如标题、内容、作者、发布日期、标签等，并使用了多种字段类型和属性。

### **示例：博客索引库**
```json
PUT /blogs
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",  // 标题，支持全文搜索
        "fields": {
          "keyword": {
            "type": "keyword"  // 标题的精确匹配版本
          }
        }
      },
      "content": {
        "type": "text",  // 博客内容，支持全文搜索
        "analyzer": "english"  // 使用英文分词器
      },
      "author": {
        "type": "keyword"  // 作者，支持精确匹配
      },
      "published_date": {
        "type": "date",  // 发布日期
        "format": "yyyy-MM-dd HH:mm:ss"  // 日期格式
      },
      "tags": {
        "type": "keyword",  // 标签，支持精确匹配
        "null_value": "unknown"  // 如果标签为空，默认值为"unknown"
      },
      "views": {
        "type": "long"  // 浏览量，长整型
      },
      "is_published": {
        "type": "boolean"  // 是否发布，布尔类型
      },
      "comments": {
        "type": "nested",  // 嵌套类型，用于存储评论
        "properties": {
          "username": {
            "type": "keyword"  // 评论者用户名
          },
          "comment": {
            "type": "text"  // 评论内容
          },
          "created_at": {
            "type": "date",  // 评论时间
            "format": "yyyy-MM-dd HH:mm:ss"
          }
        }
      }
    }
  }
}
```

---

### **字段说明**
1. **title**：
   - 类型为`text`，支持全文搜索。
   - 同时包含一个`keyword`子字段，用于精确匹配（如排序或聚合）。

2. **content**：
   - 类型为`text`，支持全文搜索。
   - 使用`english`分词器，适合英文内容的分词。

3. **author**：
   - 类型为`keyword`，支持精确匹配（如按作者筛选）。

4. **published_date**：
   - 类型为`date`，存储发布日期。
   - 指定日期格式为`yyyy-MM-dd HH:mm:ss`。

5. **tags**：
   - 类型为`keyword`，支持精确匹配。
   - 如果字段值为空，默认值为`unknown`。

6. **views**：
   - 类型为`long`，存储博客的浏览量。

7. **is_published**：
   - 类型为`boolean`，表示博客是否已发布。

8. **comments**：
   - 类型为`nested`，用于存储评论列表。
   - 每个评论包含`username`（评论者）、`comment`（评论内容）和`created_at`（评论时间）。

---

### **使用示例**
#### 插入一条博客数据
```json
POST /blogs/_doc/1
{
  "title": "Introduction to Elasticsearch",
  "content": "Elasticsearch is a distributed, RESTful search and analytics engine.",
  "author": "John Doe",
  "published_date": "2023-10-01 12:00:00",
  "tags": ["search", "database", "tutorial"],
  "views": 1000,
  "is_published": true,
  "comments": [
    {
      "username": "Alice",
      "comment": "Great article!",
      "created_at": "2023-10-02 10:00:00"
    },
    {
      "username": "Bob",
      "comment": "Very helpful, thanks!",
      "created_at": "2023-10-02 11:00:00"
    }
  ]
}
```

#### 查询博客数据
```json
GET /blogs/_search
{
  "query": {
    "match": {
      "title": "Elasticsearch"
    }
  }
}
```

#### 按标签筛选
```json
GET /blogs/_search
{
  "query": {
    "term": {
      "tags": "tutorial"
    }
  }
}
```

---

### **总结**
这个博客索引库示例展示了如何定义常见的博客字段，并使用了多种字段类型（如`text`、`keyword`、`date`、`nested`等）和属性（如`analyzer`、`null_value`等）。通过合理设计映射，可以高效地存储和查询博客数据。

## 6.索引库中的增删改查

ElasticSearch 是一个分布式的搜索引擎，常用于处理和存储大量的结构化和非结构化数据。它提供了增、删、改、查（CRUD）操作，允许用户高效地存储、索引、查询数据。下面是如何在 ElasticSearch 中进行这些操作的一些基本方法。

### 1. 插入数据 (Create)

要在 ElasticSearch 中插入（创建）文档，可以使用 **Index API**。它会将数据索引到指定的索引中。一个文档通常是以 JSON 格式表示的。

**示例：**
```json
POST /blog/_doc/1
{
  "title": "如何使用 ElasticSearch",
  "content": "本文介绍如何在 ElasticSearch 中执行增删改查操作。",
  "author": "张三",
  "date": "2025-01-15"
}
```
- `POST /blog/_doc/1`：指向 `blog` 索引，`_doc` 是类型，`1` 是文档的 ID（可以是自动生成的，也可以指定）。
- 文档内容是一个 JSON 对象。

### 2. 查询数据 (Read)

查询数据是 ElasticSearch 中最常用的操作之一。可以使用 **Search API** 来执行。

**示例：**

```json
GET /blog/_search
{
  "query": {
    "match": {
      "title": "ElasticSearch"
    }
  }
}
```
- `GET /blog/_search`：查询 `blog` 索引中的所有文档。
- 查询内容：寻找 `title` 字段包含 `ElasticSearch` 的文档。

### 3. 更新数据 (Update)

在 ElasticSearch 中，更新操作会替换或修改现有文档的部分内容。可以使用 **Update API**。

**示例：**
```json
POST /blog/_update/1
{
  "doc": {
    "content": "ElasticSearch 是一个强大的搜索引擎，广泛应用于数据分析。"
  }
}
```
- `POST /blog/_update/1`：更新 `blog` 索引中 ID 为 `1` 的文档。
- `doc`：定义要更新的字段及其新值。

### 4. 删除数据 (Delete)

如果需要删除某个文档，可以使用 **Delete API**。

**示例：**
```json
DELETE /blog/_doc/1
```
- `DELETE /blog/_doc/1`：删除 `blog` 索引中 ID 为 `1` 的文档。

### 5. 批量操作 (Bulk)

ElasticSearch 支持批量操作，可以通过 **Bulk API** 在一个请求中执行多个增、删、改操作。

**示例：**
```json
POST /_bulk
{ "index": { "_index": "blog", "_id": "2" } }
{ "title": "ElasticSearch 批量操作", "content": "批量操作可以一次处理多个文档。" }
{ "delete": { "_index": "blog", "_id": "1" } }
```
- 在单个请求中，可以同时执行多个操作（例如 `index`、`delete`、`update`）。

### 6. 扩展查询

ElasticSearch 提供了强大的查询功能，可以进行复杂的过滤、排序和聚合。

- **Match 查询**：用于全文搜索，类似于 SQL 中的 `LIKE` 查询。
- **Term 查询**：用于精确匹配。
- **Range 查询**：用于范围查询，如日期、数字区间。
- **Bool 查询**：用于组合多个查询条件。
- **Aggregations**：进行聚合操作（例如统计分析，分组等）。

**示例：**
```json
GET /blog/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "author": "张三" } },
        { "range": { "date": { "gte": "2025-01-01" } } }
      ]
    }
  }
}
```
这个查询会找到 `author` 为 `张三` 且 `date` 大于或等于 2025-01-01 的文档。

# 二.SpringBoot整合ES

## 1.根据MySQL表结构，设计Index的Mapping

为了将MySQL表结构（例如一个酒店表）转换为适用于Elasticsearch的索引映射（mapping），首先需要理解表的结构和每个字段的类型、使用方式。通常，MySQL表会包含一些基础字段，比如酒店名称、地址、评分、价格等，而这些字段会在Elasticsearch中有相应的映射设置。

在考虑是否做分词时，我们需要依据字段类型和查询需求来确定。例如，对于字符串类型字段，通常需要做分词处理；对于数值、日期等字段，则不需要分词。以下是一个假设的酒店表结构及其对应的Elasticsearch映射。

假设有以下MySQL表结构：

### MySQL 表结构示例：

```sql
CREATE TABLE hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    description TEXT,
    rating FLOAT,
    price INT,
    check_in DATE,
    check_out DATE
);
```

### 转换为 Elasticsearch 的映射：

在 Elasticsearch 中，我们需要为每个字段定义类型，并且根据需求指定是否分词。以下是一个适用于上述表的Elasticsearch映射示例。

```json
{
  "mappings": {
    "properties": {
      "id": {
        "type": "integer"
      },
      "name": {
        "type": "text", 
        "analyzer": "ik_smart"  // 字符串类型的字段使用标准分词器
      },
      "address": {
        "type": "text", 
        "analyzer": "ik_smart"  // 地址字段也可能包含多个词，所以使用分词
      },
      "description": {
        "type": "text", 
        "analyzer": "ik_smart"  // 详细描述通常较长，适合进行分词
      },
      "rating": {
        "type": "float"  // 评分是数值类型，不需要分词
      },
      "price": {
        "type": "integer"  // 价格是数值类型，不需要分词
      },
      "check_in": {
        "type": "date", 
        "format": "yyyy-MM-dd"  // 日期类型，按照指定格式存储
      },
      "check_out": {
        "type": "date", 
        "format": "yyyy-MM-dd"  // 日期类型，按照指定格式存储
      }
    }
  }
}
```

### 解释：
1. **id**: 用于标识酒店的唯一ID，类型为`integer`，不需要分词。
2. **name**: 酒店名称是一个字符串，需要分词处理，使用Elasticsearch的默认`standard`分析器。通常分词处理有助于提高搜索效果，特别是针对名称查询。
3. **address**: 地址也是字符串类型，可能包含多个单词，因此需要分词处理。
4. **description**: 详细描述字段，通常较长，适合进行分词。
5. **rating**: 评分字段，数值类型不进行分词处理。
6. **price**: 价格字段，数值类型不进行分词处理。
7. **check_in, check_out**: 日期字段，Elasticsearch有专门的`date`类型来存储日期，格式为`yyyy-MM-dd`。

### 关于分词：
- 对于文本类型字段（如`name`、`address`、`description`等），Elasticsearch 会使用分词器对文本进行切分，以便进行更精确的搜索。字段类型使用`text`，并且默认使用 `standard` 分词器，当然也可以根据需要选择其他分析器。
- 对于数值类型字段（如`rating`、`price`等），这些字段不会进行分词，直接作为精确值处理。

### 总结：
根据上述示例，Elasticsearch 的索引映射与 MySQL 表结构相对应，并且根据字段类型决定是否需要分词。通常，字符串字段需要分词，而数值和日期字段则不需要分词。你可以根据具体的查询需求调整分词器或者添加其他的分析器（如`ik_max_word`等）。

## 2.使用Mybatis-plus整合ElasticSearch

在Spring Boot项目中整合Elasticsearch（ES）并使用MyBatis-Plus和Lombok，通常需要以下几个步骤：

### 1. 添加依赖
首先，在`pom.xml`中添加必要的依赖：

```xml
<dependencies>
    <!-- Spring Boot Starter Data Elasticsearch -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
    </dependency>

    <!-- MyBatis-Plus -->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>最新版本</version>
    </dependency>

    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <scope>provided</scope>
    </dependency>

    <!-- 其他依赖 -->
    <!-- ... -->
</dependencies>
```

### 2. 配置Elasticsearch
在`application.yml`或`application.properties`中配置Elasticsearch的连接信息：

```yaml
spring:
  elasticsearch:
    rest:
      uris: http://localhost:9200  # Elasticsearch服务器地址
```

### 3. 创建实体类
使用Lombok简化实体类的编写，并使用MyBatis-Plus的注解来映射数据库表。

```java
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Data
@Document(indexName = "your_index_name")  // 指定Elasticsearch索引名称
public class YourEntity {

    @Id
    private Integer id;

    @Field(type = FieldType.Text, analyzer = "ik_smart")
    private String name;

    @Field(type = FieldType.Text, analyzer = "ik_smart")
    private String address;

    @Field(type = FieldType.Text, analyzer = "ik_smart")
    private String description;

    @Field(type = FieldType.Float)
    private Float rating;

    @Field(type = FieldType.Integer)
    private Integer price;

    @Field(type = FieldType.Date, format = DateFormat.date)
    private String checkIn;

    @Field(type = FieldType.Date, format = DateFormat.date)
    private String checkOut;
}
```

### 4. 创建Repository接口
使用Spring Data Elasticsearch提供的`ElasticsearchRepository`接口来操作Elasticsearch。

```java
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface YourEntityRepository extends ElasticsearchRepository<YourEntity, Integer> {
    // 可以定义自定义查询方法
}
```

### 5. 创建Service层
在Service层中调用Repository的方法来操作Elasticsearch。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class YourEntityService {

    @Autowired
    private YourEntityRepository yourEntityRepository;

    public void save(YourEntity entity) {
        yourEntityRepository.save(entity);
    }

    public YourEntity findById(Integer id) {
        return yourEntityRepository.findById(id).orElse(null);
    }

    // 其他业务逻辑
}
```

### 6. 创建Controller层
在Controller层中暴露API供外部调用。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/your-entity")
public class YourEntityController {

    @Autowired
    private YourEntityService yourEntityService;

    @PostMapping
    public void save(@RequestBody YourEntity entity) {
        yourEntityService.save(entity);
    }

    @GetMapping("/{id}")
    public YourEntity findById(@PathVariable Integer id) {
        return yourEntityService.findById(id);
    }

    // 其他API
}
```

### 7. 配置MyBatis-Plus
在`application.yml`中配置MyBatis-Plus的相关信息：

```yaml
mybatis-plus:
  mapper-locations: classpath*:mapper/*.xml  # MyBatis映射文件位置
  type-aliases-package: com.example.entity  # 实体类所在的包
```

### 8. 创建MyBatis-Plus的Mapper接口
使用MyBatis-Plus的`BaseMapper`接口来操作数据库。

```java
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

public interface YourEntityMapper extends BaseMapper<YourEntity> {
    // 可以定义自定义查询方法
}
```

### 9. 创建MyBatis-Plus的Service层
在Service层中调用MyBatis-Plus的Mapper接口来操作数据库。

```java
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class YourEntityServiceImpl extends ServiceImpl<YourEntityMapper, YourEntity> implements YourEntityService {
    // 实现自定义业务逻辑
}
```

### 10. 整合MyBatis-Plus和Elasticsearch
在业务逻辑中，可以根据需求选择使用MyBatis-Plus操作数据库，或者使用Elasticsearch进行全文搜索。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class YourEntityService {

    @Autowired
    private YourEntityRepository yourEntityRepository;  // Elasticsearch

    @Autowired
    private YourEntityMapper yourEntityMapper;  // MyBatis-Plus

    public void saveToDatabase(YourEntity entity) {
        yourEntityMapper.insert(entity);
    }

    public void saveToElasticsearch(YourEntity entity) {
        yourEntityRepository.save(entity);
    }

    // 其他业务逻辑
}
```

### 11. 启动类
确保在Spring Boot启动类上添加`@MapperScan`注解，扫描MyBatis-Plus的Mapper接口。

```java
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.mapper")  // 扫描MyBatis-Plus的Mapper接口
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### 12. 测试
启动项目后，可以通过API测试Elasticsearch和MyBatis-Plus的整合是否成功。

## 3.使用RestClient整合ElasticSearch

如果不使用 MyBatis-Plus，而是直接使用 Elasticsearch 的 `RestHighLevelClient` 或 `RestClient` 来操作 Elasticsearch，可以按照以下步骤进行整合。以下是详细的实现流程：

---

### 1. 添加依赖
在 `pom.xml` 中添加 Elasticsearch 和 Spring Boot 的相关依赖：

```xml
<dependencies>
    <!-- Spring Boot Starter Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Elasticsearch Rest Client -->
    <dependency>
        <groupId>org.elasticsearch.client</groupId>
        <artifactId>elasticsearch-rest-high-level-client</artifactId>
        <version>7.17.0</version> <!-- 根据你的 Elasticsearch 版本选择 -->
    </dependency>

    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <scope>provided</scope>
    </dependency>

    <!-- JSON 处理库（可选，用于处理 JSON 数据） -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
    </dependency>
</dependencies>
```

---

### 2. 配置 Elasticsearch 客户端
在 Spring Boot 中配置 `RestHighLevelClient` 或 `RestClient`。

#### 在 `application.yml` 中配置 Elasticsearch 连接信息：
```yaml
elasticsearch:
  host: localhost
  port: 9200
  scheme: http
```

#### 创建配置类：
```java
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {

    @Value("${elasticsearch.host}")
    private String host;

    @Value("${elasticsearch.port}")
    private int port;

    @Value("${elasticsearch.scheme}")
    private String scheme;

    @Bean
    public RestHighLevelClient restHighLevelClient() {
        RestClientBuilder builder = RestClient.builder(
                new HttpHost(host, port, scheme)
        );
        return new RestHighLevelClient(builder);
    }
}
```

---

### 3. 创建实体类
使用 Lombok 简化实体类的编写。

```java
import lombok.Data;

@Data
public class YourEntity {
    private Integer id;
    private String name;
    private String address;
    private String description;
    private Float rating;
    private Integer price;
    private String checkIn;
    private String checkOut;
}
```

---

### 4. 创建 Service 层
在 Service 层中通过 `RestHighLevelClient` 操作 Elasticsearch。

```java
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.xcontent.XContentType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class YourEntityService {

    @Autowired
    private RestHighLevelClient restHighLevelClient;

    private static final String INDEX_NAME = "your_index_name";

    // 保存数据到 Elasticsearch
    public String save(YourEntity entity) throws IOException {
        IndexRequest request = new IndexRequest(INDEX_NAME)
                .id(entity.getId().toString())
                .source(convertEntityToJson(entity), XContentType.JSON);

        IndexResponse response = restHighLevelClient.index(request, RequestOptions.DEFAULT);
        return response.getId();
    }

    // 根据 ID 查询数据
    public YourEntity findById(String id) throws IOException {
        GetRequest request = new GetRequest(INDEX_NAME, id);
        GetResponse response = restHighLevelClient.get(request, RequestOptions.DEFAULT);

        if (response.isExists()) {
            return convertJsonToEntity(response.getSourceAsString());
        }
        return null;
    }

    // 将实体类转换为 JSON
    private String convertEntityToJson(YourEntity entity) {
        // 使用 Jackson 或其他 JSON 库将实体类转换为 JSON 字符串
        // 例如：new ObjectMapper().writeValueAsString(entity);
        return "{\"id\":" + entity.getId() + ",\"name\":\"" + entity.getName() + "\",...}";
    }

    // 将 JSON 转换为实体类
    private YourEntity convertJsonToEntity(String json) {
        // 使用 Jackson 或其他 JSON 库将 JSON 字符串转换为实体类
        // 例如：new ObjectMapper().readValue(json, YourEntity.class);
        return new YourEntity();
    }
}
```

---

### 5. 创建 Controller 层
在 Controller 层中暴露 API 供外部调用。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/your-entity")
public class YourEntityController {

    @Autowired
    private YourEntityService yourEntityService;

    @PostMapping
    public String save(@RequestBody YourEntity entity) throws IOException {
        return yourEntityService.save(entity);
    }

    @GetMapping("/{id}")
    public YourEntity findById(@PathVariable String id) throws IOException {
        return yourEntityService.findById(id);
    }
}
```

---

### 6. 启动类
确保 Spring Boot 启动类正确配置。

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

---

### 7. 测试
启动项目后，可以通过以下方式测试 API：

#### 保存数据：
```bash
curl -X POST http://localhost:8080/your-entity \
-H "Content-Type: application/json" \
-d '{
  "id": 1,
  "name": "Test Name",
  "address": "Test Address",
  "description": "Test Description",
  "rating": 4.5,
  "price": 100,
  "checkIn": "2023-10-01",
  "checkOut": "2023-10-05"
}'
```

#### 查询数据：
```bash
curl -X GET http://localhost:8080/your-entity/1
```

---

### 8. 其他操作
你可以根据需要扩展 `YourEntityService`，实现更多 Elasticsearch 操作，例如：
- 更新数据（`UpdateRequest`）
- 删除数据（`DeleteRequest`）
- 搜索数据（`SearchRequest`）

---

# 三：高阶操作

在大众点评的业务场景中，地理位置查询、相关性算分、排序、分页和高亮显示是非常重要的功能。以下是如何结合这些功能来优化用户体验的详细说明：

---

### 1. **地理位置查询（Geo Query）**
大众点评的核心功能之一是帮助用户找到附近的商家（如餐厅、酒店、景点等）。ElasticSearch 提供了丰富的地理位置查询功能：

- **Geo Distance Query**：查找距离用户当前位置一定范围内的商家。  
  例如，用户搜索“5公里内的火锅店”，可以使用 `geo_distance` 查询。
  
  ```json
  {
    "query": {
      "bool": {
        "must": [
          { "match": { "category": "火锅" } }
        ],
        "filter": {
          "geo_distance": {
            "distance": "5km",
            "location": { "lat": 39.9042, "lon": 116.4074 } // 用户当前位置
          }
        }
      }
    }
  }
  ```
  
- **Geo Bounding Box Query**：查找位于某个矩形区域内的商家。  
  例如，用户在地图上拖动一个矩形区域，搜索该区域内的商家。

- **Geo Polygon Query**：查找位于某个多边形区域内的商家。  
  例如，用户自定义一个多边形区域，搜索该区域内的商家。

- **Geo Sorting**：按距离排序。  
  例如，用户希望搜索结果按距离从近到远排序：
  ```json
  {
    "sort": [
      {
        "_geo_distance": {
          "location": { "lat": 39.9042, "lon": 116.4074 },
          "order": "asc",
          "unit": "km"
        }
      }
    ]
  }
  ```

---

### 2. **相关性算分（Relevance Scoring）**
大众点评的搜索需要根据用户查询的相关性对商家进行排序。ElasticSearch 使用相关性算分（如 TF-IDF 或 BM25）来确定文档的匹配程度。

- **BM25 算法**：ElasticSearch 默认使用 BM25 算法，综合考虑词频（TF）、逆文档频率（IDF）和文档长度归一化。
  - 例如，用户搜索“火锅”，商家名称或描述中包含“火锅”的次数越多，得分越高。
  - 如果“火锅”是一个常见词（如在北京），IDF 会降低其权重。

- **Boosting**：可以通过 Boosting 提升某些字段的权重。  
  例如，商家名称中包含“火锅”的权重高于描述中包含“火锅”的权重：
  ```json
  {
    "query": {
      "multi_match": {
        "query": "火锅",
        "fields": ["name^3", "description"] // name 字段权重是 description 的 3 倍
      }
    }
  }
  ```

- **Function Score Query**：结合业务逻辑调整得分。  
  例如，用户更倾向于评分高的商家，可以将评分作为得分的一部分：
  ```json
  {
    "query": {
      "function_score": {
        "query": { "match": { "category": "火锅" } },
        "functions": [
          {
            "field_value_factor": {
              "field": "rating",
              "factor": 1.2, // 评分权重
              "modifier": "sqrt"
            }
          }
        ]
      }
    }
  }
  ```

---

### 3. **排序（Sorting）**
在大众点评中，排序是提升用户体验的关键。除了默认的相关性排序外，还可以支持多种排序方式：

- **按距离排序**：如“离我最近”。
- **按评分排序**：如“评分最高”。
- **按销量排序**：如“销量最高”。
- **按价格排序**：如“价格最低”。
- **综合排序**：结合距离、评分、销量等多个因素。

例如，按评分和距离综合排序：
```json
{
  "sort": [
    { "rating": { "order": "desc" } },
    {
      "_geo_distance": {
        "location": { "lat": 39.9042, "lon": 116.4074 },
        "order": "asc",
        "unit": "km"
      }
    }
  ]
}
```

---

### 4. **分页（Pagination）**
大众点评的搜索结果通常需要分页显示，ElasticSearch 提供了 `from` 和 `size` 参数来实现分页：

- **基本分页**：
  ```json
  {
    "from": 0, // 从第 0 条开始
    "size": 10 // 返回 10 条结果
  }
  ```

- **深度分页优化**：  
  当需要获取大量数据时（如第 1000 条之后），使用 `search_after` 或 `scroll` 来避免性能问题。

---

### 5. **高亮显示（Highlighting）**
在大众点评中，高亮显示可以帮助用户快速定位搜索结果中的关键词。例如，用户搜索“火锅”，商家名称或描述中的“火锅”会被高亮显示。

- **基本高亮**：
  ```json
  {
    "highlight": {
      "fields": {
        "name": {},
        "description": {}
      }
    }
  }
  ```

- **自定义高亮标签**：  
  可以使用自定义标签（如 `<em>`）来高亮关键词：
  ```json
  {
    "highlight": {
      "pre_tags": ["<em>"],
      "post_tags": ["</em>"],
      "fields": {
        "name": {},
        "description": {}
      }
    }
  }
  ```

- **高亮片段大小**：  
  可以控制高亮片段的大小（如只显示包含关键词的前 100 个字符）：
  ```json
  {
    "highlight": {
      "fields": {
        "description": { "fragment_size": 100 }
      }
    }
  }
  ```

---

### 结合大众点评的业务场景
1. **用户搜索“附近的火锅店”**：
   - 使用地理位置查询（Geo Distance Query）找到 5 公里内的商家。
   - 使用相关性算分（BM25）对商家名称和描述进行匹配。
   - 按距离和评分综合排序。
   - 分页显示结果，每页 10 条。
   - 高亮显示商家名称和描述中的“火锅”。

2. **用户在地图上拖动区域搜索“烧烤”**：
   - 使用 Geo Bounding Box Query 找到区域内的商家。
   - 按销量和评分排序。
   - 高亮显示“烧烤”关键词。

3. **用户搜索“评分高的日料店”**：
   - 使用 Function Score Query 提升高评分商家的权重。
   - 按评分排序。
   - 高亮显示“日料”关键词。

通过结合地理位置查询、相关性算分、排序、分页和高亮显示，ElasticSearch 能够为大众点评提供高效、精准的搜索体验。