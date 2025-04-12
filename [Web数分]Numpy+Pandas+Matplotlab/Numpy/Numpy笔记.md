# NumPy 知识框架

## 1.1 NumPy简介

### 数组计算库

NumPy是Python中用于科学计算的基础库，提供高性能的多维数组对象和工具。

```python
import numpy as np

# 创建NumPy数组
arr = np.array([1, 2, 3, 4, 5])
print("NumPy数组:", arr)
print("类型:", type(arr))

# 与Python列表的性能对比
import time

# 大数组/列表的创建时间比较
size = 1000000
start = time.time()
python_list = list(range(size))
end = time.time()
print(f"Python列表创建时间: {end - start:.6f}秒")

start = time.time()
numpy_array = np.arange(size)
end = time.time()
print(f"NumPy数组创建时间: {end - start:.6f}秒")

# 运算性能比较
start = time.time()
result = [x * 2 for x in python_list]
end = time.time()
print(f"Python列表运算时间: {end - start:.6f}秒")

start = time.time()
result = numpy_array * 2
end = time.time()
print(f"NumPy数组运算时间: {end - start:.6f}秒")
```

### 与Python列表的区别

| 特性     | Python列表           | NumPy数组                |
| -------- | -------------------- | ------------------------ |
| 数据类型 | 可以包含不同类型元素 | 所有元素必须是相同类型   |
| 内存使用 | 较大                 | 较小                     |
| 性能     | 较慢                 | 较快                     |
| 功能     | 基本操作             | 丰富的数学运算和广播功能 |
| 多维支持 | 嵌套列表实现         | 原生支持多维数组         |
| 大小可变 | 是                   | 否(创建后大小固定)       |

```python
# 数据类型差异示例
python_list = [1, "two", 3.0, True]  # 合法
try:
    numpy_array = np.array([1, "two", 3.0, True])  # 会尝试统一类型
    print("NumPy数组:", numpy_array)  # 所有元素被转换为字符串
except Exception as e:
    print("错误:", e)

# 内存占用比较
import sys

list_memory = sys.getsizeof(python_list) + sum(sys.getsizeof(x) for x in python_list)
array_memory = arr.nbytes
print(f"Python列表内存占用: {list_memory}字节")
print(f"NumPy数组内存占用: {array_memory}字节")

# 运算差异
a = [1, 2, 3]
b = [4, 5, 6]
try:
    print(a * 3)  # 列表重复
    print(a + b)  # 列表连接
    # print(a * b)  # 会报错
    
    a_np = np.array(a)
    b_np = np.array(b)
    print("数组乘法:", a_np * 3)  # 每个元素乘以3
    print("数组相加:", a_np + b_np)  # 对应元素相加
    print("数组相乘:", a_np * b_np)  # 对应元素相乘
except Exception as e:
    print("错误:", e)
```

## 1.2 核心对象

### ndarray

ndarray是NumPy的核心对象，表示N维数组。

```python
# 创建ndarray的各种方法
# 1. 从Python列表创建
arr1 = np.array([1, 2, 3, 4])
print("一维数组:", arr1)

# 2. 从嵌套列表创建多维数组
arr2 = np.array([[1, 2, 3], [4, 5, 6]])
print("二维数组:\n", arr2)

# 3. 使用arange创建
arr3 = np.arange(10)  # 类似range
print("arange创建:", arr3)

# 4. 使用linspace创建
arr4 = np.linspace(0, 1, 5)  # 0到1之间均匀分布的5个数
print("linspace创建:", arr4)

# 5. 特殊数组创建
zeros_arr = np.zeros((2, 3))  # 全0数组
ones_arr = np.ones((2, 2))    # 全1数组
eye_arr = np.eye(3)           # 单位矩阵
random_arr = np.random.rand(2, 2)  # 随机数组

print("全0数组:\n", zeros_arr)
print("全1数组:\n", ones_arr)
print("单位矩阵:\n", eye_arr)
print("随机数组:\n", random_arr)

# ndarray属性
print("数组形状:", arr2.shape)
print("数组维度:", arr2.ndim)
print("数组元素总数:", arr2.size)
print("数组数据类型:", arr2.dtype)
print("数组元素大小(字节):", arr2.itemsize)
print("数组总字节数:", arr2.nbytes)
```

### dtype

dtype描述数组中元素的类型。

```python
# 指定dtype创建数组
int_arr = np.array([1, 2, 3], dtype=np.int32)
float_arr = np.array([1, 2, 3], dtype=np.float64)
complex_arr = np.array([1, 2, 3], dtype=np.complex128)
bool_arr = np.array([0, 1, 0], dtype=np.bool_)
string_arr = np.array(['a', 'bb', 'ccc'], dtype=np.str_)

print("int32数组:", int_arr, int_arr.dtype)
print("float64数组:", float_arr, float_arr.dtype)
print("complex数组:", complex_arr, complex_arr.dtype)
print("bool数组:", bool_arr, bool_arr.dtype)
print("string数组:", string_arr, string_arr.dtype)

# dtype转换
arr = np.array([1.5, 2.7, 3.1])
print("原始数组:", arr, arr.dtype)

int_arr = arr.astype(np.int32)  # 转换为整数(截断小数部分)
print("转换为int32:", int_arr, int_arr.dtype)

bool_arr = arr.astype(np.bool_)  # 非零为True
print("转换为bool:", bool_arr, bool_arr.dtype)

# 检查dtype
print("float64是否数字类型:", np.issubdtype(arr.dtype, np.number))
print("bool_是否数字类型:", np.issubdtype(bool_arr.dtype, np.number))

# 自定义dtype
dt = np.dtype([('name', 'S10'), ('age', 'i4'), ('height', 'f4')])
data = np.array([('Alice', 25, 1.65), ('Bob', 30, 1.80)], dtype=dt)
print("结构化数组:\n", data)
print("访问name字段:", data['name'])
print("访问age字段:", data['age'])
```

### buffer

buffer是NumPy数组底层的数据缓冲区。

```python
# 访问数组的buffer
arr = np.array([1, 2, 3, 4, 5], dtype=np.int32)
print("数组:", arr)

# 使用data属性访问buffer(已废弃，建议使用__array_interface__)
print("缓冲区信息:", arr.__array_interface__)

# 使用内存视图
buffer = memoryview(arr)
print("内存视图:", buffer)

# 修改buffer会影响原始数组
buffer[1:3] = b'\x09\x00\x00\x00\x0A\x00\x00\x00'  # 修改第2和第3个元素为9和10
print("修改后的数组:", arr)

# 从buffer创建数组
buffer = bytearray(b'\x01\x00\x00\x00\x02\x00\x00\x00\x03\x00\x00\x00')
arr_from_buffer = np.frombuffer(buffer, dtype=np.int32)
print("从buffer创建的数组:", arr_from_buffer)

# 共享内存示例
original = np.array([1, 2, 3, 4])
view = original[:2]  # 视图共享内存
view[0] = 10
print("原始数组被修改:", original)  # 原始数组也被修改

copy = original.copy()  # 创建副本
copy[0] = 100
print("原始数组不受影响:", original)  # 原始数组不受影响
```

### 轴(axis)

轴是NumPy中表示数组维度的概念。

```python
# 理解轴的概念
arr = np.array([[1, 2, 3], [4, 5, 6]])
print("二维数组:\n", arr)
print("形状:", arr.shape)  # (2, 3)

# 轴0是行方向(垂直方向)
# 轴1是列方向(水平方向)

# 沿轴0求和(压缩行，保留列)
sum_axis0 = arr.sum(axis=0)
print("沿轴0求和:", sum_axis0)  # [5 7 9]

# 沿轴1求和(压缩列，保留行)
sum_axis1 = arr.sum(axis=1)
print("沿轴1求和:", sum_axis1)  # [6 15]

# 三维数组示例
arr_3d = np.array([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])
print("三维数组形状:", arr_3d.shape)  # (2, 2, 2)

# 轴0: 第一个维度(块)
# 轴1: 第二个维度(行)
# 轴2: 第三个维度(列)

# 沿不同轴求和
print("沿轴0求和:\n", arr_3d.sum(axis=0))
print("沿轴1求和:\n", arr_3d.sum(axis=1))
print("沿轴2求和:\n", arr_3d.sum(axis=2))

# 轴的应用示例
# 1. 矩阵转置
matrix = np.array([[1, 2], [3, 4], [5, 6]])
print("原始矩阵:\n", matrix)
print("转置矩阵:\n", matrix.T)  # 相当于交换轴0和轴1

# 2. 改变轴顺序
arr = np.random.rand(2, 3, 4)
print("原始形状:", arr.shape)
transposed = np.transpose(arr, (1, 0, 2))  # 交换前两个轴
print("转置后形状:", transposed.shape)

# 3. 广播机制中的轴
a = np.array([[1], [2], [3]])  # 形状(3,1)
b = np.array([4, 5, 6])        # 形状(3,)
print("广播加法:\n", a + b)     # b被广播到(3,3)
```

## 应试指南

### 典型例题

1. **将Python列表转换为NumPy数组并计算平均值**
   ```python
   data = [1, 2, 3, 4, 5]
   arr = np.array(data)
   mean = arr.mean()
   ```

2. **创建3x3的单位矩阵**
   ```python
   eye_matrix = np.eye(3)
   ```

3. **沿轴1求和**
   ```python
   arr = np.array([[1, 2, 3], [4, 5, 6]])
   sum_axis1 = arr.sum(axis=1)  # 结果: array([6, 15])
   ```

4. **类型转换**
   ```python
   float_arr = np.array([1.1, 2.2, 3.3])
   int_arr = float_arr.astype(np.int32)  # 结果: array([1, 2, 3])
   ```

5. **广播机制**
   ```python
   a = np.array([[1], [2], [3]])  # (3,1)
   b = np.array([4, 5, 6])        # (3,)
   c = a + b  # b被广播为(3,3)
   ```

通过理解这些基础概念和大量练习，可以掌握NumPy的核心功能，为科学计算和数据分析打下坚实基础。

## 2. 数组创建
   - 2.1 从已有数据创建
     - array()
     - asarray()
   - 2.2 特殊数组
     - zeros()
     - ones()
     - empty()
     - full()
     - identity()
   - 2.3 序列数组
     - arange()
     - linspace()
     - logspace()
   - 2.4 随机数组
     - random.rand()
     - random.randn()
     - random.randint()
   - 2.5 从磁盘加载
     - loadtxt()
     - genfromtxt()

## 3. 数组属性
   - ndim
   - shape
   - size
   - dtype
   - itemsize
   - flags
   - real/imag

## 4. 数据类型
   - 4.1 基本类型
     - bool_
     - int8/int16/int32/int64
     - uint8/uint16/uint32/uint64
     - float16/float32/float64
     - complex64/complex128
   - 4.2 类型转换
     - astype()
     - dtype参数
   - 4.3 结构化数组
     - 字段定义
     - 记录数组

## 5. 数组操作
   - 5.1 索引
     - 基本索引
     - 布尔索引
     - 花式索引
   - 5.2 切片
     - 基本切片
     - 步长切片
     - 多维切片
   - 5.3 形状操作
     - reshape()
     - resize()
     - flatten()
     - ravel()
     - transpose()
   - 5.4 组合/分割
     - concatenate()
     - stack()
     - hstack/vstack/dstack
     - split()
     - hsplit/vsplit/dsplit

## 6. 广播机制
   - 广播规则
   - 广播应用
   - 广播陷阱

## 7. 通用函数(ufunc)
   - 7.1 数学运算
     - add/subtract
     - multiply/divide
     - power
     - sqrt/exp/log
   - 7.2 三角函数
     - sin/cos/tan
   - 7.3 比较函数
     - greater/less
     - equal/not_equal
   - 7.4 逻辑函数
     - logical_and/or/not

## 8. 统计计算
   - sum/mean
   - std/var
   - min/max
   - argmin/argmax
   - cumsum/cumprod
   - percentile
   - median

## 9. 线性代数
   - dot()
   - matmul()
   - inner()
   - trace()
   - det()
   - eig()
   - inv()
   - svd()
   - solve()

## 10. 输入输出
   - 10.1 文本文件
     - savetxt()
     - loadtxt()
   - 10.2 二进制文件
     - save()/load()
     - savez()
   - 10.3 内存映射
     - memmap()

## 11. 性能优化
   - 向量化操作
   - 避免循环
   - 预分配内存
   - 视图vs副本
   - C/F顺序优化

## 12. 高级特性
   - 12.1 掩码数组
   - 12.2 结构化数组
   - 12.3 日期时间处理
   - 12.4 自定义dtype
   - 12.5 与C/Fortran交互

## 13. 与其他库集成
   - 13.1 与Pandas交互
   - 13.2 与Matplotlib配合
   - 13.3 与SciPy关系
   - 13.4 与TensorFlow/PyTorch转换