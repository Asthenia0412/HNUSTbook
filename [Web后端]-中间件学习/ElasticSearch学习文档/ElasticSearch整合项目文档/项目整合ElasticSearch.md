## 1.依赖整合

```xml
	   <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
        </dependency>
```

```xml
<properties>

        <java.version>17</java.version>
        <spring-boot.version>3.2.2</spring-boot.version>
        <spring-cloud.version>2023.0.1</spring-cloud.version>
        <spring-cloud-alibaba.version>2023.0.1.0</spring-cloud-alibaba.version>
        <pagehelper-starter.version>2.1.0</pagehelper-starter.version>
        <pagehelper.version>6.1.0</pagehelper.version>
        <druid.version>1.2.9</druid.version>
        <mybatis-generator.version>1.4.2</mybatis-generator.version>
        <mybatis.version>3.5.14</mybatis.version>
        <mybatis-spring-boot-starter.version>3.0.3</mybatis-spring-boot-starter.version>
        <mysql-connector.version>8.0.29</mysql-connector.version>
        <spring-data-commons.version>3.2.2</spring-data-commons.version>
    </properties>
```

```xml
<dependencies>
<!--MyBatis分页插件starter-->
            <dependency>
                <groupId>com.github.pagehelper</groupId>
                <artifactId>pagehelper-spring-boot-starter</artifactId>
                <version>${pagehelper-starter.version}</version>
            </dependency>
            <!--MyBatis分页插件-->
            <dependency>
                <groupId>com.github.pagehelper</groupId>
                <artifactId>pagehelper</artifactId>
                <version>${pagehelper.version}</version>
            </dependency>
            <!--MyBatis的Starter依赖-->
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis-spring-boot-starter.version}</version>
            </dependency>
            <!--集成druid连接池-->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid-spring-boot-starter</artifactId>
                <version>${druid.version}</version>
            </dependency>
  <!-- MyBatis 生成器 -->
            <dependency>
                <groupId>org.mybatis.generator</groupId>
                <artifactId>mybatis-generator-core</artifactId>
                <version>${mybatis-generator.version}</version>
            </dependency>
            <!-- MyBatis-->
            <dependency>
                <groupId>org.mybatis</groupId>
                <artifactId>mybatis</artifactId>
                <version>${mybatis.version}</version>
            </dependency>
            <!--Mysql数据库驱动-->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql-connector.version}</version>
            </dependency>
            <!--SpringData工具包-->
            <dependency>
                <groupId>org.springframework.data</groupId>
                <artifactId>spring-data-commons</artifactId>
                <version>${spring-data-commons.version}</version>
            </dependency>
</dependencies>
```

## 2.代码分析

在这段代码中，Elasticsearch 被用于实现商品搜索功能。代码中涉及了从 MySQL 数据库导入数据到 Elasticsearch、构建复杂的查询条件、聚合分析等操作。以下是对代码中 Elasticsearch 相关细节的分析：

### 1. 数据从 MySQL 导入到 Elasticsearch
在 `importAll()` 方法中，代码从 MySQL 数据库中获取商品数据，并将其导入到 Elasticsearch 中：

```java
@Override
public int importAll() {
    List<EsProduct> esProductList = productDao.getAllEsProductList(null);
    Iterable<EsProduct> esProductIterable = productRepository.saveAll(esProductList);
    Iterator<EsProduct> iterator = esProductIterable.iterator();
    int result = 0;
    while (iterator.hasNext()) {
        result++;
        iterator.next();
    }
    return result;
}
```

- **`productDao.getAllEsProductList(null)`**: 从 MySQL 数据库中获取所有商品的列表。`productDao` 是一个数据访问对象（DAO），负责与 MySQL 数据库交互。
- **`productRepository.saveAll(esProductList)`**: 将获取到的商品列表保存到 Elasticsearch 中。`productRepository` 是一个 Spring Data Elasticsearch 的 Repository 接口，负责与 Elasticsearch 交互。
- **`Iterable<EsProduct>`**: 保存操作返回一个 `Iterable` 对象，表示保存的所有商品。
- **`iterator.hasNext()`**: 遍历保存的商品，统计导入的数量。

### 2. 删除和创建商品
- **`delete(Long id)`**: 根据商品 ID 从 Elasticsearch 中删除商品。
- **`create(Long id)`**: 根据商品 ID 从 MySQL 中获取商品信息，并将其保存到 Elasticsearch 中。

```java
@Override
public void delete(Long id) {
    productRepository.deleteById(id);
}

@Override
public EsProduct create(Long id) {
    EsProduct result = null;
    List<EsProduct> esProductList = productDao.getAllEsProductList(id);
    if (esProductList.size() > 0) {
        EsProduct esProduct = esProductList.get(0);
        result = productRepository.save(esProduct);
    }
    return result;
}
```

### 3. 搜索商品
在 `search()` 方法中，代码构建了一个复杂的查询条件，支持关键字搜索、品牌和分类过滤、排序等功能：

```java
@Override
public Page<EsProduct> search(String keyword, Long brandId, Long productCategoryId, Integer pageNum, Integer pageSize, Integer sort) {
    Pageable pageable = PageRequest.of(pageNum, pageSize);
    NativeQueryBuilder nativeQueryBuilder = new NativeQueryBuilder();
    // 分页
    nativeQueryBuilder.withPageable(pageable);
    // 过滤
    if (brandId != null || productCategoryId != null) {
        Query boolQuery = QueryBuilders.bool(builder -> {
            if (brandId != null) {
                builder.must(QueryBuilders.term(b -> b.field("brandId").value(brandId)));
            }
            if (productCategoryId != null) {
                builder.must(QueryBuilders.term(b -> b.field("productCategoryId").value(productCategoryId)));
            }
            return builder;
        });
        nativeQueryBuilder.withFilter(boolQuery);
    }
    // 搜索
    if (StrUtil.isEmpty(keyword)) {
        nativeQueryBuilder.withQuery(QueryBuilders.matchAll(builder -> builder));
    } else {
        List<FunctionScore> functionScoreList = new ArrayList<>();
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("name").query(keyword)))
                .weight(10.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("subTitle").query(keyword)))
                .weight(5.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("keywords").query(keyword)))
                .weight(2.0)
                .build());
        FunctionScoreQuery.Builder functionScoreQueryBuilder = QueryBuilders.functionScore()
                .functions(functionScoreList)
                .scoreMode(FunctionScoreMode.Sum)
                .minScore(2.0);
        nativeQueryBuilder.withQuery(builder -> builder.functionScore(functionScoreQueryBuilder.build()));
    }
    // 排序
    if (sort == 1) {
        // 按新品从新到旧
        nativeQueryBuilder.withSort(Sort.by(Sort.Order.desc("id")));
    } else if (sort == 2) {
        // 按销量从高到低
        nativeQueryBuilder.withSort(Sort.by(Sort.Order.desc("sale")));
    } else if (sort == 3) {
        // 按价格从低到高
        nativeQueryBuilder.withSort(Sort.by(Sort.Order.asc("price")));
    } else if (sort == 4) {
        // 按价格从高到低
        nativeQueryBuilder.withSort(Sort.by(Sort.Order.desc("price")));
    }
    // 按相关度
    nativeQueryBuilder.withSort(Sort.by(Sort.Order.desc("_score")));
    NativeQuery nativeQuery = nativeQueryBuilder.build();
    LOGGER.info("DSL:{}", nativeQuery.getQuery().toString());
    SearchHits<EsProduct> searchHits = elasticsearchTemplate.search(nativeQuery, EsProduct.class);
    if (searchHits.getTotalHits() <= 0) {
        return new PageImpl<>(ListUtil.empty(), pageable, 0);
    }
    List<EsProduct> searchProductList = searchHits.stream().map(SearchHit::getContent).collect(Collectors.toList());
    return new PageImpl<>(searchProductList, pageable, searchHits.getTotalHits());
}
```

- **`NativeQueryBuilder`**: 用于构建 Elasticsearch 的原生查询。
- **`withPageable(pageable)`**: 设置分页参数。
- **`withFilter(boolQuery)`**: 根据品牌 ID 和分类 ID 进行过滤。
- **`withQuery(functionScoreQueryBuilder.build())`**: 根据关键字进行搜索，并对不同字段设置不同的权重。
- **`withSort()`**: 根据不同的排序条件进行排序。
- **`elasticsearchTemplate.search(nativeQuery, EsProduct.class)`**: 执行查询并返回结果。

> `Spring Data Elasticsearch` 是 Spring 提供的一个用于操作 Elasticsearch 的框架。它简化了 Elasticsearch 的操作，提供了类似于 Spring Data JPA 的编程风格，可以通过接口或模板类与 Elasticsearch 进行交互。
>
> ---
>
> ### 2. **代码整体逻辑**
> 这段代码的主要功能是通过关键字、品牌 ID、商品分类 ID 等条件，从 Elasticsearch 中搜索商品数据，并支持分页、排序和过滤。以下是代码的主要步骤：
> 1. **分页**：设置分页参数。
> 2. **过滤**：根据品牌 ID 和商品分类 ID 过滤数据。
> 3. **搜索**：根据关键字搜索商品名称、副标题和关键词。
> 4. **排序**：根据指定的排序规则对结果排序。
> 5. **执行查询**：将查询发送到 Elasticsearch 并获取结果。
>
> ---
>
> ### 3. **详细 API 解释**
>
> #### **(1) `Pageable` 和 `PageRequest`**
> - **作用**：用于分页。
> - **参数**：
>   - `pageNum`：当前页码（从 0 开始）。
>   - `pageSize`：每页的数据量。
> - **示例**：
>   ```java
>   Pageable pageable = PageRequest.of(pageNum, pageSize);
>   ```
>   这行代码创建了一个分页对象，表示从第 `pageNum` 页开始，每页显示 `pageSize` 条数据。
>
> ---
>
> #### **(2) `NativeQueryBuilder`**
> - **作用**：用于构建 Elasticsearch 的原生查询（Native Query）。
> - **常用方法**：
>   - `withPageable(Pageable pageable)`：设置分页。
>   - `withFilter(Query query)`：设置过滤条件。
>   - `withQuery(Query query)`：设置搜索条件。
>   - `withSort(Sort sort)`：设置排序规则。
>   - `build()`：构建最终的查询对象。
>
> ---
>
> #### **(3) `QueryBuilders`**
> - **作用**：用于构建 Elasticsearch 的查询条件。
> - **常用方法**：
>   - `bool(Builder builder)`：构建布尔查询（组合多个查询条件）。
>   - `term(b -> b.field("fieldName").value(value))`：精确匹配某个字段的值。
>   - `match(b -> b.field("fieldName").query(keyword))`：全文匹配某个字段的值。
>   - `matchAll()`：匹配所有文档。
>   - `functionScore()`：构建函数评分查询（用于调整搜索结果的评分）。
>
> ---
>
> #### **(4) `FunctionScoreQuery`**
> - **作用**：用于调整搜索结果的评分（权重）。
> - **常用参数**：
>   - `functions`：评分函数列表。
>   - `scoreMode`：评分模式（如 `Sum` 表示将多个评分相加）。
>   - `minScore`：最低评分阈值，低于此值的文档将被过滤掉。
> - **示例**：
>   ```java
>   FunctionScoreQuery.Builder functionScoreQueryBuilder = QueryBuilders.functionScore()
>       .functions(functionScoreList)
>       .scoreMode(FunctionScoreMode.Sum)
>       .minScore(2.0);
>   ```
>   这段代码表示根据 `functionScoreList` 中的评分规则调整搜索结果，并过滤掉评分低于 2.0 的文档。
>
> ---
>
> #### **(5) `Sort`**
> - **作用**：用于对搜索结果进行排序。
> - **常用方法**：
>   - `by(Sort.Order order)`：根据指定的排序规则排序。
>   - `desc("fieldName")`：按字段降序排序。
>   - `asc("fieldName")`：按字段升序排序。
> - **示例**：
>   ```java
>   nativeQueryBuilder.withSort(Sort.by(Sort.Order.desc("price")));
>   ```
>   这行代码表示按 `price` 字段降序排序。
>
> ---
>
> #### **(6) `ElasticsearchTemplate`**
> - **作用**：用于执行 Elasticsearch 查询。
> - **常用方法**：
>   - `search(NativeQuery query, Class<T> clazz)`：执行查询并返回结果。
> - **示例**：
>   ```java
>   SearchHits<EsProduct> searchHits = elasticsearchTemplate.search(nativeQuery, EsProduct.class);
>   ```
>   这行代码执行查询并将结果映射到 `EsProduct` 类中。
>
> ---
>
> #### **(7) `SearchHits`**
> - **作用**：表示 Elasticsearch 的查询结果。
> - **常用方法**：
>   - `getTotalHits()`：获取匹配的文档总数。
>   - `stream()`：将结果转换为流。
>   - `map(SearchHit::getContent)`：将每个结果映射为实体对象。
> - **示例**：
>   ```java
>   List<EsProduct> searchProductList = searchHits.stream()
>       .map(SearchHit::getContent)
>       .collect(Collectors.toList());
>   ```
>   这段代码将查询结果转换为 `EsProduct` 对象的列表。
>
> ---
>
> #### **(8) `PageImpl`**
> - **作用**：用于封装分页结果。
> - **参数**：
>   - `content`：当前页的数据列表。
>   - `pageable`：分页信息。
>   - `total`：总数据量。
> - **示例**：
>   ```java
>   return new PageImpl<>(searchProductList, pageable, searchHits.getTotalHits());
>   ```
>   这行代码将查询结果封装为分页对象。
>
> ---
>
> ### 4. **代码流程总结**
> 1. **分页**：通过 `PageRequest.of` 设置分页参数。
> 2. **过滤**：通过 `QueryBuilders.bool` 构建布尔查询，过滤品牌 ID 和商品分类 ID。
> 3. **搜索**：通过 `QueryBuilders.functionScore` 构建评分查询，根据关键字搜索商品名称、副标题和关键词。
> 4. **排序**：通过 `Sort.by` 设置排序规则。
> 5. **执行查询**：通过 `ElasticsearchTemplate.search` 执行查询并获取结果。
> 6. **封装结果**：将查询结果封装为分页对象并返回。
>
> ---
>
> 

### 4. 推荐商品
在 `recommend()` 方法中，代码根据当前商品的名称、品牌和分类信息，推荐相似的商品：

```java
@Override
public Page<EsProduct> recommend(Long id, Integer pageNum, Integer pageSize) {
    Pageable pageable = PageRequest.of(pageNum, pageSize);
    List<EsProduct> esProductList = productDao.getAllEsProductList(id);
    if (esProductList.size() > 0) {
        EsProduct esProduct = esProductList.get(0);
        String keyword = esProduct.getName();
        Long brandId = esProduct.getBrandId();
        Long productCategoryId = esProduct.getProductCategoryId();
        // 构建查询条件
        NativeQueryBuilder nativeQueryBuilder = new NativeQueryBuilder();
        // 分页
        nativeQueryBuilder.withPageable(pageable);
        // 用于过滤掉相同的商品
        nativeQueryBuilder.withFilter(QueryBuilders.bool(build -> build.mustNot(QueryBuilders.term(b -> b.field("id").value(id)))));
        // 根据商品标题、品牌、分类进行搜索
        List<FunctionScore> functionScoreList = new ArrayList<>();
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("name").query(keyword)))
                .weight(8.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("subTitle").query(keyword)))
                .weight(2.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("keywords").query(keyword)))
                .weight(2.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("brandId").query(brandId)))
                .weight(5.0)
                .build());
        functionScoreList.add(new FunctionScore.Builder()
                .filter(QueryBuilders.match(builder -> builder.field("productCategoryId").query(productCategoryId)))
                .weight(3.0)
                .build());
        FunctionScoreQuery.Builder functionScoreQueryBuilder = QueryBuilders.functionScore()
                .functions(functionScoreList)
                .scoreMode(FunctionScoreMode.Sum)
                .minScore(2.0);
        nativeQueryBuilder.withQuery(builder -> builder.functionScore(functionScoreQueryBuilder.build()));
        NativeQuery nativeQuery = nativeQueryBuilder.build();
        LOGGER.info("DSL:{}", nativeQuery.getQuery().toString());
        SearchHits<EsProduct> searchHits = elasticsearchTemplate.search(nativeQuery, EsProduct.class);
        if (searchHits.getTotalHits() <= 0) {
            return new PageImpl<>(ListUtil.empty(), pageable, 0);
        }
        List<EsProduct> searchProductList = searchHits.stream().map(SearchHit::getContent).collect(Collectors.toList());
        return new PageImpl<>(searchProductList, pageable, searchHits.getTotalHits());
    }
    return new PageImpl<>(ListUtil.empty());
}
```

- **`withFilter(QueryBuilders.bool(build -> build.mustNot(QueryBuilders.term(b -> b.field("id").value(id)))))`**: 过滤掉当前商品，避免推荐自己。
- **`FunctionScoreQuery`**: 根据商品名称、副标题、关键字、品牌 ID 和分类 ID 进行加权搜索，推荐相似商品。

### 5. 聚合分析
在 `searchRelatedInfo()` 方法中，代码使用 Elasticsearch 的聚合功能，分析商品的品牌、分类和属性信息：

```java
@Override
public EsProductRelatedInfo searchRelatedInfo(String keyword) {
    NativeQueryBuilder nativeQueryBuilder = new NativeQueryBuilder();
    // 搜索条件
    if (StrUtil.isEmpty(keyword)) {
        nativeQueryBuilder.withQuery(QueryBuilders.matchAll(builder -> builder));
    } else {
        nativeQueryBuilder.withQuery(QueryBuilders.multiMatch(builder -> builder.fields("name", "subTitle", "keywords").query(keyword)));
    }
    // 聚合搜索品牌名称
    nativeQueryBuilder.withAggregation("brandNames", AggregationBuilders.terms(builder -> builder.field("brandName").size(10)));
    // 聚合搜索分类名称
    nativeQueryBuilder.withAggregation("productCategoryNames", AggregationBuilders.terms(builder -> builder.field("productCategoryName").size(10)));
    // 聚合搜索商品属性，去除type=0的属性
    Aggregation aggregation = new Aggregation.Builder().nested(builder -> builder.path("attrValueList"))
            .aggregations("productAttrs", new Aggregation.Builder()
                    .filter(b -> b.term(a -> a.field("attrValueList.type").value("1")))
                    .aggregations("attrIds", new Aggregation.Builder().terms(b -> b.field("attrValueList.productAttributeId").size(10))
                            .aggregations("attrValues", new Aggregation.Builder().terms(b -> b.field("attrValueList.value").size(10)).build())
                            .aggregations("attrNames", new Aggregation.Builder().terms(b -> b.field("attrValueList.name").size(10)).build())
                            .build()).build()).build();
    nativeQueryBuilder.withAggregation("allAttrValues", aggregation);
    NativeQuery nativeQuery = nativeQueryBuilder.build();
    LOGGER.info("DSL:{}", nativeQueryBuilder.getQuery().toString());
    SearchHits<EsProduct> searchHits = elasticsearchTemplate.search(nativeQuery, EsProduct.class);
    return convertProductRelatedInfo(searchHits);
}
```

- **`withAggregation()`**: 使用 Elasticsearch 的聚合功能，分析品牌名称、分类名称和商品属性。
- **`nested()`**: 用于处理嵌套类型的字段（如 `attrValueList`）。
- **`convertProductRelatedInfo()`**: 将聚合结果转换为 `EsProductRelatedInfo` 对象。

### 6. 总结
- **数据导入**: 通过 `productRepository.saveAll()` 将 MySQL 中的数据导入到 Elasticsearch 中。
- **查询构建**: 使用 `NativeQueryBuilder` 构建复杂的查询条件，支持分页、过滤、加权搜索、排序等功能。
- **聚合分析**: 使用 Elasticsearch 的聚合功能，分析商品的品牌、分类和属性信息。
- **推荐系统**: 根据当前商品的信息，推荐相似的商品。

