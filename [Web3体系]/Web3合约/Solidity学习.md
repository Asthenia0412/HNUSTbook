# 一、基本语法结构

## 1.入门案例：简单储存合约

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SimpleStorage{
	//声明一个状态量
	uint256 storedData;
	//改变状态量的函数
	function set(uint256 x) public {
	storedData = x;
	}
	//获取状态量的函数
	function get() public view returns(uint256){
	return storedData;
	}
}
```

- `SPDX-License-Identifier`：指定了源代码的许可证。
- `pragma solidity`：指定了编译器版本，这里使用的是0.8.0或更高版本。
- `contract` 关键字：用来定义一个智能合约，这里是 `SimpleStorage`。
- `uint256`：一个256位的无符号整数类型。
- `storedData`：合约的一个状态变量，用于存储一个数字。
- `set` 函数：允许任何人（`public`）调用这个函数来改变 `storedData` 的值。
- `get` 函数：一个视图（`view`）函数，它不修改区块链的状态，仅返回 `storedData` 的值。

## 2.基本语法

### A.数据类型(整型，布尔型，地址，字符串)

### B.变量(状态变量,局部变量)

### C.函数(可见性,状态可变性)

### D.控制结构(if,else,for,while)

## 3.入门概念

### A.函数修饰符

#### A.1修饰符的定义与使用

#### A.2view函数与pure函数

#### A.3require与assert

### B.事件

#### B.1声明与触发

#### B.2参数与索引

### C.结构体与映射

#### C.1结构体的定义与使用

#### C.2映射的声明与操作

### D.继承

#### E.2继承的基本概念

#### E.3多重继承与接口

### E.库

#### E.1库的定义与使用

#### E.2库的链接

## 4.高级概念

### A.**安全最佳实践**

#### A.1重入攻击与防护措施

#### A.2检查时间与使用时间

#### A.3事务顺序依赖性

### B.高级数据结构

#### B.1动态数组

#### B.2字节数组操作

#### B.3字典树

### C.代币标准

### D.Gas优化

### E.测试和部署

### F.新特性

## 5.实际应用

### A.去中心化应用

### B.案例研究

