# 一.函数分析

## 1.基本函数

```js
function f(a,b){
    const sum = a+b;
    return sum;
}
```

## 2.匿名函数

```javascript
var f = function(a,b){
    const sum = a+b;
    return sum;
}
console.log(f(3,4));

```

## 3.IIFE函数-立即执行函数

### A.简单例子

```js
const result = (function(a,b){
    const sum = a+b;
    return sum;
})(3,4);
//我们关注最外层的()()两个括号
/*
第一个()中放置匿名函数
第二个()中放置与匿函数对应的相应参数



*/
```

### B.通过立即执行函数简化代码

```js
var compose = function(functions) {
    //传入函数数组,实现符合函数的累计作用
	return function(x) {
        for(let i = functions.length-1;i>=0;i--){
            x = functions[i](x);//这里简化 将上一个函数处理完的值交给下一个函数处理
        }
        return x;
    }
};
```



## 4.函数内创建函数

> 1.我们要关注 “创建” 因为在C/Cpp/Java等语言中,我们可以在函数内 <strong>调用</strong>函数实现<strong>递归</strong>但是无法<strong>创建新的函数</strong>
>
> 2.**而JavaScript可以在A函数内继续创建B函数**
>
> 3.内层函数最好不要用 **匿名函数**

```js
function createFunction(){
    function f(a,b){//普通函数 无匿名表达
        const sum = a+b;
        return sum;
    }
    return f;
}
const f = createFunction();
console.log(f(3,4));
```

## 5.函数提升

> 1.只有在`function`声明函数时可用
>
> 2.函数可以在**初始化**之前使用

```js
function createFunction(){
    return f;
    function f(a,b){
        const sum = a+b;
        return sum;
    }
}
const f = createFunction();
console.log(f(3,4));//返回值是7
```

## 6.闭包

### A.什么是闭包

> 1.创建函数,函数可以访问周围声明的所有变量,这些变量是**词法环境**
>
> 2.**函数**与其**词法环境**的**组合**是**闭包**

```javascript
function createAdder(a){
    functin f(b){
        const sum = a+b;
        return sum;
    }
    return f;
}
const f = createAdder(3);
console.log(f(4));
```

### B.闭包实战

在JavaScript中，闭包是指那些能够访问自由变量的函数。“自由变量”是指在函数中使用的，但既不是函数参数也不是函数的局部变量的变量。简单来说，闭包让你能够保存状态——即，它们可以记住并访问创建它们时作用域中的变量。

闭包的创建通常发生在嵌套函数中，即函数内部定义了另一个函数。在上面的例子中，`createCounter` 函数返回了一个对象，这个对象包含了三个方法：`increment`、`decrement` 和 `reset`。这些方法都是闭包，因为它们都能够访问到它们被创建时作用域中的变量 `n`。

让我们逐行分析代码来理解闭包是如何工作的：

```js
var createCounter = function(init) {
    let n = init; // n 是一个局部变量，初始化为 init
```

这里，`createCounter` 函数接受一个参数 `init` 并定义了一个局部变量 `n`，它被初始化为 `init` 的值。

```js
    return {
        increment:()=>++n, // 闭包 increment
        decrement:()=>--n, // 闭包 decrement
        reset:()=>(n=init) // 闭包 reset
    }
};
```

`createCounter` 函数返回一个对象，这个对象有三个方法，每个方法都是一个箭头函数。这些箭头函数都是闭包，因为它们访问了它们被定义时的作用域中的变量 `n`。即使 `createCounter` 函数执行完毕后，局部变量 `n` 的引用仍然被这三个闭包保持着，因此 `n` 的值可以在这三个方法中被修改和访问。

这里是一个使用 `createCounter` 函数的例子：

```js
var counter = createCounter(5);
console.log(counter.increment()); // 输出 6
console.log(counter.decrement()); // 输出 5
counter.reset();
console.log(counter.increment()); // 输出 6
```

在这个例子中，我们首先创建了一个计数器，初始值为 5。然后我们调用 `increment` 方法，它将 `n` 的值增加 1 并返回新的值。接着我们调用 `decrement` 方法，它将 `n` 的值减少 1 并返回新的值。最后，我们调用 `reset` 方法将 `n` 的值重置为初始值，然后再次调用 `increment` 方法。

由于闭包，每个 `createCounter` 实例都有自己的 `n` 变量，所以多个计数器实例之间不会共享状态。这就是闭包的一个强大特性——它们可以用来创建私有状态。

### C.只允许一次函数调用（闭包例子）

```js
var once = function(fn) {
    let isCalled = false;
    return function(...args){
        if(isCalled){
            return undefined;
        }
        isCalled = true;
        return fn(...args);
    }
};
```



## 7.函数式编程思想的渗透->箭头函数语法

### A.基本语法

```js
const f = (a,b)=>{
    const sum = a+b;
    return sum;
}
console.log(f(3,4));
```



### B.对return的省略

```js
const f = (a,b)=>a+b;
console.log(f(3,4));//答案是7
```

### C.箭头语法和函数语法之间有三个区别

1. 语法更简洁
2. 没有自动提升,只有声明后方可使用函数
3. 无法绑定到 **this**/**super**/**arguments**,无法做**构造函数**

### D.箭头函数的本质以及容易出错的地方

箭头函数省略了return部分,因此一旦使用自增运算符和自减运算符,最好是前置的,因为如果你后置,直接返回了n,没有返回n++作用的内容，也就是返回了n之后 n自增了 可是如果我们要的是自增后的n 那么程序的执行就会和想的不一样，看例子

```js
var createCounter = function(init) {
    let n = init;
    return{
        increment:()=> ++n,
        decrement:()=>--n, //++n与--n的区别 因为箭头函数是直接return n 如果n++就是返回了没自增的n了
        reset:()=>(n=init)
    }
};
```



## 8.剩余参数

- 展开运算符： ...

- 剩余参数：...args

  - 作用：允许将不定数量的参数表示为一个数组
  - 例如,输入了3和4,那么将3放到args数组的0索引位置 4放到args数组的1索引位置

  

```javascript
function f(...args){
    const sum = args[0]+args[1];
    return sum;
}
console.log(f(3,4));//输出结果为7
```

- 更广泛的场景：
  - 设计通用的工厂函数,需要接受任何函数作为输入,并且返回有特定修改的新版本函数
  - 接受函数/返回函数的函数称为***高阶函数***

```js
function log(inputFunction){//传入的是一个函数
    return function(...args){
        console.log("输入",args);
        const result = inputFunction(...args);
        console.log("输出",result);
        return result
    }
}
const f = log((a,b)=>a+b); // (a,b)=>a+b 这个箭头函数就是我们的inputFunction 而下面的1和2是输入到箭头函数中的
f(1,2);输入[1,2]输出3
```

## 9.CallBack回调函数

```js
var map = function(arr, fn) {
    const newArr = [];//注意在JS中 数组的声明为空是 方括号
    for(let i =0;i<arr.length;i++){
        newArr[i] = fn(arr[i],i);
    }
    return newArr;
};
```



```js
var filter = function(arr, fn) {
    const nums = [];
    for(let i =0;i<arr.length;i++){
        if(fn(arr[i],i)){ //在js中 可以使用nums.push(x) 将x添加到数组nums的末尾
            nums.push(arr[i]);
        }
    }
    return nums;
};
```



```js
var reduce = function(nums, fn, init) {
    let res = init;//res会变 
    for(const num of nums){ //类似于Java中的增强for循环, for(int i:nums) 但是分隔符用的of 而不是:
        res = fn(res,num);//res和num都是不断变化的值
    }
    return res;
};
```



# 二.对象与函数综合

## 1.对象与有限方法链：

```js
let arr = [5,2,8,1];
let result = arr.sort().reverse().join("-");
/*
PS:类似于Java中的stream流
.sort().对数组对象排序
.reverse().对数组对象翻转顺序
.join("-")对数组对象的每一个元素之间加上"-
*/

console.log(result);//8-5-2-1
```

## 2.JavaScript错误处理

### A.抛出字符串

通过`throw`与`try...catch`块实现

```js
function checkName(name){
    if(name==''){
        throw "Name cant be empty";
    }
    return name;
}
try{
    console.log(checkName(''));
}catch(error){
    console.error(error);//"Name cant be empty"
}
```

### B.抛出Error实例

好处：利于调试：允许字啊错误中包含（堆栈跟踪的附加元数据,有利于调试）

```javascript
function divide(numerator,denominator){
    if(denominator===0){
        throw new Error("Cannot divide by zero")
    }
    return numerater / denominator
    
}
try{
    console.log(divide(5,0));
}catch(error){
    console.log(error.message);
}
```

### C.抛出聚合错误

有时候,你可能希望同时抛出多个错误.而JavaScript中有内置的`AggregateError`对象。该对象接受一个错误对象的可迭代集合与一个可选的消息作为参数

```js
let error1 = new Error("First Error");
let error2 = new Error("Second Error");
try{
    throw new AggregateError([error1,error2],"Two errors occured");
}catch(error){
    if(error instanceof AggregateError){
        console.error(error.message);"Two errors occurred."
     for(let e of error.errors){
         console.error(e.message);打印 "First Error" 和 "Second Error"
     }   
    }
}
```

