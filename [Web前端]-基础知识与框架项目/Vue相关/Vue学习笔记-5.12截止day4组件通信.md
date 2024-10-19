

# 一.Vue是什么：

概念：Vue是一个用于**构建用户界面**的**渐进式**的**框架**

以下的内容是自里向外的

1. 声明式渲染(Vuejs核心包)
2. 组件系统(Vuejs核心包)
3. 客户端路由VueRouter
4. 大规模状态管理Vuex
5. 构建工具Webpack/Vite

Vue的两种使用方式：

1. Vue核心包开发->局部模块改造
2. Vue核心包&Vue插件 工程化开发

# 二.创建Vue实例与初始化渲染

- 构建用户界面
- 创建Vue实例，初始化渲染
  - 准备容器
  - 引包-开发版本/生产版本
  - 创建Vue new Vue();
  - 指定配置项，渲染数据
    - el指定挂载点 -#id
    - data提供数据

```javascript
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
</head>

<body>
    <div id="app">
        <p>{{ message }}</p>
        <button v-on:click="changeMessage">改变消息</button>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
        const app = new Vue({
            el: '#app',
            data: {
                message: '这是一个简单的 Vue 实例'
            },
            methods: {
                changeMessage: function () {
                    this.message = '消息已改变！';
                }
            }
        });
    </script>
</body>

</html>

```

![image-20240507231942569](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240507231942569.png)

# 三.Vue指令

Vue指令的定义：有v-前缀的**标签属性**

Vue根据不同的【指令】，针对【标签】实现不同的【功能】

```vue
<!--Vue指令： v-前缀的标签属性 -->
<div v-html="str"></div>
<!--普通标签属性-->
<div class="box"></div>
<div title="小张"></div>
```

## 1.v-html

插值表达式：{{msg}} 其中msg是在data中定义的变量 vue会将其渲染到html标签中 而{{msg}}插值表达式就在标签中

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
</head>

<body>
    <div id="app" v-html="msg">
        
        
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            msg:`<a href="http://www.baidu.com">测试内容</a>`
        }
       })
    </script>
</body>

</html>

```

- v-html="data中的属性"
- data中的属性要用``作为模板语法表示
- v-html等价于js中的innerHTML
- data中的属性必须是一个完整的html标签

## 2.v-show与v-if

### v-show(条件渲染)

1. 作用：控制元素显示隐藏
2. 语法：v-show="表达式" 表达式的值true显示 false隐藏
3. 原理：display:none(本质控制的css样式-适合频繁切换显示隐藏的场景)

### v-if(判断条件)

1. 作用：控制元素显示隐藏
2. 语法：v-if="表达式" 表达式值true显示 false隐藏
3. 原理：基于条件判断，是否创建或者移除元素节点（适合不频繁的场景）

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
    <style>
.box {
    display: flex; /* 使用 flexbox 布局 */
    justify-content: center; /* 在主轴上居中 */
    align-items: center; /* 在交叉轴上居中 */
    height: 200px;
    width: 200px;
    text-align: center;
    border-radius: 5px;
    border: 2px solid black;
    background-color: white;
    padding: 10px;
    margin: 10px;
    box-shadow: none;
}

    </style>
</head>

<body>
    <div id ="app">
        <div v-show="flag" class="box">我是v-show控制的盒子</div>
        
        <div v-if="flag" class="box">我是v-if控制的盒子</div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            flag:false
        }
       })
    </script>
</body>

</html>

```

## 3.v-else v-else-if

1. 作用：辅助v-if进行判断渲染
2. v-else v-else-if="表达式"
3. 必须结合v-if使用

```java
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <p v-if="gender==1">性别：男</p>
        <p v-if="gender==2">性别：女</p>
        <p v-if="score>=90">成绩评定为A等因为其>90</p>
        <p v-else-if="score>=70">成绩评定为B等，因为其>70</p>
        <p v-else-if="score>=60">成绩评定C等，因为其>60</p>
        <p v-else>成绩评定D等，你的问题很大</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            gender:2,
            score:89
        }
       })
    </script>
</body>

</html>

```

上述为完整例子，p可以是任意标签，接下来抽取抽象概念

```vue
<p v-if="">xxx</p>
<p v-else-if="xxx">xxx</p>
<p v-else>xxx</p>
```

## 4.v-on基础

1. 作用：注册事件 = 添加监听+提供处理逻辑

2. 语法：

   1. v-on:事件名=”内联语句“

   2. v-on:事件名="methods中的函数名"

   3. v-on：可以用@替代

   4. ```vue
      <button v-on:click="count++">
          点我自增
      </button>
      
      <button @click-"count++">
          点我自增
      </button>
      ```

### 实例一：内联语句

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <button v-on:click="count--">点我做减法</button>
        <br>
        <button v-on:click="count++">点我做加法</button>
        <br>
        <span>{{count}}</span>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            count:0
        }
       })
    </script>
</body>

</html>

```

### 实例二：methods函数

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <button @click="fn">切换显示隐藏</button>
        <h1 v-show="isShow">测试内容</h1>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            isShow:true
        },
        methods:{
            fn(){
                this.isShow=!this.isShow
            }
        }
       })
    </script>
</body>

</html>

```

## 5.v-on调用传参

- 场景需求：点击按钮购买道具需要扣除一定的资金
- 点击按钮发生响应可以通过v-on:事件=”命令“来实现
- 但是，如何传递扣除资金的参数呢？我们引入v-on调用传参来实现
- v-on:click="函数名(传入的参数)"
- 你是否会想：那我如果希望点击按钮传递input框的值呢？这个答案会在v-model中揭晓

### 售货机扣钱案例来学习调用传参

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
    <style>
        .box{
            border: 2px solid black;
            width: 200px;
            height: 200px;
            text-align: center;
        }
    </style>
</head>

<body>
    <div id ="app">
        <div class="box">
            <h3>自动售货机</h3>
            <button @click="buy(5)">可乐5元</button>
            <button @click="buy(10)">咖啡10元</button>
        </div>
        <p>银行卡余额：{{deposit}}元</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            deposit:5000
        },
        methods:{
            buy(price){
                this.deposit=this.deposit-price
                window.alert("购买成功！您的余额是"+deposit);
            }
        }
       })
    </script>
</body>

</html>

```

## 6.v-bind

1. 作用：动态的设置html的**标签属性**
2. 语法： v-bind:属性名="表达式"
3. 省略语法：v-bind:src="xxx" => :src="xxx"

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <img v-bind:src="imgUrl">
        <img :src="imgUrl">
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            imgUrl: 'D:/desklop/OIP-C.jpg'
        },
       
       })
    </script>
</body>

</html>

```

## 7.数组概念-切换图片案例

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <button v-on:click="index++">下一张</button>
        <button v-on:click="index--">上一张</button>
        <br>
        <img v-bind:src="list[index]">
        
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            index:0,
            list:[
            'D:/desklop/OIP-C.jpg',
            'D:/desklop/testpng.png',
            'D:/desklop/OIP-C.jpg',
            'D:/desklop/testpng.png',
            ]
        },
       
       })
    </script>
</body>

</html>

```

## 8.v-for

1. 作用：基于数据循环，多次渲染整个元素
2. 语法：v-for="(item,index) in 数组" ps:item是每一项
3. 大多数时候和<ul>与<li>一起使用

```vue
<p v-for="...">我是一个内容</p>
```

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <h3>水果店</h3>
        <ul>
            <li v-for="(item,index) in list">
                {{item}} --{{index}}
            </li>
            <li v-for="item in list">
                {{item}}
            </li>
        </ul>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            list:['西瓜','苹果','鸭梨','榴莲']
        },
       
       })
    </script>
</body>

</html>

```

## 9.v-for+v-on实战-书架

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
        <h3>书架</h3>
        <ul>
            <li v-for="(item,index) in booklist" :key="item.id">
                <span>{{item.name}}</span>
                <span>{{item.author}}</span>
                <button v-on:click="del(item.id)">删除</button>
            </li>
        </ul>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            booklist:[
                {id:1,name:"《红楼梦》",author:'曹雪芹'},
                {id:2,name:"《西游记》",author:'吴承恩'},
                {id:3,name:"《水浒传》",author:'施耐庵'},
                {id:4,name:"《三国演义》",author:'罗贯中'},
            ]
        },
        methods:{
            del(id){
                this.booklist = this.booklist.filter(item => item.id!==id)
            }
        }
       
       })
    </script>
</body>

</html>

```

> 这段代码是用来过滤掉 `booklist` 数组中 `id` 与给定 `id` 相同的元素。它使用了 JavaScript 中的数组 `filter` 方法，该方法会创建一个新数组，其中包含通过指定函数测试的所有元素。在这里，指定的函数是一个箭头函数，它会检查每个元素的 `id` 是否与给定的 `id` 不相同，如果不相同，则保留该元素。所以最终item.id==id的部分都保留下来了

## 10.v-for:key

```vue
 <ul>
            <li v-for="(item,index) in booklist" :key="item.id">
                <span>{{item.name}}</span>
                <span>{{item.author}}</span>
                <button v-on:click="del(item.id)">删除</button>
            </li>
        </ul>
```

1. 语法：key属性=”唯一标识"
2. 给列表项添加的唯一标识。便于Vue进行列表项的**正确排序复用**

> 如果不加key v-for默认行为是**原地修改元素**（就地复用）
>
> 给元素添加唯一标识，便于Vue进行列表的正确排序复用

- key只能是**字符串**或者**数字类型**
- key必须要有唯一性
- 推荐使用id作为key,不推荐使用index作为key(会变化不对应)

## 11.v-model

1. 作用：给**表单元素**使用，**双向数据绑定** ->可以快速**获取**或**设置**表单元素内容
2. 语法：v-model='变量'

- 数据变化——>视图自动更新
- 视图变化——>数据自动更新

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>

</head>

<body>
    <div id ="app">
       账户:<input type="text" v-model="username"><br><br>
       密码:<input type="password" v-model="password"><br><br>
       <button @click="login">登陆</button>
       <button @click="reset">重置</button>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
           username:"",
           password:"",
        },
        methods:{
          login(){
            console.log(this.username,this.password)
          },
          reset(){
            this.username="",
            this.password=""
          }
        }
       
       })
    </script>
</body>

</html>

```

## 12.记事本项目

- 功能需求：
  - 列表渲染
  - 删除功能
  - 添加功能
  - 底部统计与清空

```vue
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="./css/index.css" />
<title>记事本</title>
</head>
<body>

<!-- 主体区域 -->
<section id="app">
  <!-- 输入框 -->
  <header class="header">
    <h1>小黑记事本</h1>
    <input v-model="todoName"  placeholder="请输入任务" class="new-todo" />
    <button @click="add" class="add">添加任务</button>
  </header>
  <!-- 列表区域 -->
  <section class="main">
    <ul class="todo-list">
      <li class="todo" v-for="(item, index) in list" :key="item.id">
        <div class="view">
          <span class="index">{{ index + 1 }}.</span> <label>{{ item.name }}</label>
          <button @click="del(item.id)" class="destroy"></button>
        </div>
      </li>
    </ul>
  </section>
  <!-- 统计和清空 → 如果没有任务了，底部隐藏掉 → v-show -->
  <footer class="footer" v-show="list.length > 0">
    <!-- 统计 -->
    <span class="todo-count">合 计:<strong> {{ list.length }} </strong></span>
    <!-- 清空 -->
    <button @click="clear" class="clear-completed">
      清空任务
    </button>
  </footer>
</section>

<!-- 底部 -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script>
  // 添加功能
  // 1. 通过 v-model 绑定 输入框 → 实时获取表单元素的内容
  // 2. 点击按钮，进行新增，往数组最前面加 unshift
  const app = new Vue({
    el: '#app',
    data: {
      todoName: '',
      list: [
        { id: 1, name: '跑步一公里' },
        { id: 2, name: '跳绳200个' },
        { id: 3, name: '游泳100米' },
      ]
    },
    methods: {
      del (id) {
        // console.log(id) => filter 保留所有不等于该 id 的项
        this.list = this.list.filter(item => item.id !== id)
      },
      add () {
        if (this.todoName.trim() === '') {
          alert('请输入任务名称')
          return
        }
        this.list.unshift({
          id: +new Date(),
          name: this.todoName
        })
        this.todoName = ''
      },
      clear () {
        this.list = []
      }
    }
  })

</script>
</body>
</html>

```

# 四:指令补充/计算属性/监听器

## 1.指令的修饰符

指令修饰符：通过"."指明的指令后缀，不同后缀封装了不同的处理操作->简化代码

- 按键修饰符

  - @keyup.enter ->键盘回车监听

  - ```vue
    <header class="header">
        <h1>记事本</h1>
        <input @keyup.enter="add" v-model="todoName"  placeholder="请输入任务" class="new-todo" />
        <button @click="add" class="add">添加任务</button>
      </header>
    <!--输入框注册了事件 keyup按键弹起 enter为回车 实现在输入框内回车即可添加-->
    ```

    我们思考v-on:keyup.enter的内在逻辑：=“”中的函数若空参，可以用e承接事件名，然后以事件来调用方法

    ```javascript
    <script>
        const app = new Vue({
            el:'#app',
            data:{
                username: ''
            },
            methods:{
                fn(e){
                    console.log(e);
                    console.log("键盘回车时候触发",this.username)
                }
            }
        })
        </script>
    ```

    

- v-model修饰符

  - v-model.trim ->去除首尾空格
  - v-model.number->转数字

- 事件修饰符

  - @事件名.stop ->阻止冒泡
    - 存在两个div嵌套，点击内部div命令会执行外部div方法与内部div方法，使用stop可以避免这种现象
  - @事件名.prevent ->阻止默认行为

  ```vue
  <!DOCTYPE html>
  <html lang="zh">
  
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>简单的 Vue 实例</title>
      <style>
          .father{
              width: 200px;
              height: 200px;
              background-color: aqua;
          }
          .son{
              width: 50px;
              height: 50px;
              background-color: blanchedalmond;
          }
      </style>
  </head>
  
  <body>
      <div id="app">
          <h3>v-model修饰符.trim .number</h3>
          姓名：<input v-model.trim="username" type="text"><br>
          年龄：<input v-model.number="age" type="text"><br>
  
          <h3>@事件名.stop ->阻止冒泡</h3>
          <div @click.stop ="fatherFn" class="father">
              <div @click.stop="sonFn" class="son">儿子</div>
          </div>
  
          <h3>@事件名.prevent ->阻止默认行为</h3>
          <a @click.prevent href="https://www.baidu.com">阻止默认行为</a>
          <!--在被.prevent修饰后 无法跳转链接 因为herf是a的一个默认行为-->
  
      </div>
  
      <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
      <script>
         const app = new Vue({
          el:'#app',
          data:{
              username: '',
              age:'',
          },
          methods:{
              fatherFn(){
                  alert("父亲被点击了")
              },
              sonFn(){
                  alert("儿子被点击了")
              }
  
          }
         })
      </script>
  </body>
  
  </html>
  
  ```

  

## 2.v-bind操作class(样式控制增强)

语法:v-bind="对象/数组"

1. 对象->键就是类名，值是布尔值。如果值是true，有这个类，否则无这个类。第一类特征在于v-bind修饰的就是class本身，而非是class中的某个具体属性。在于决定某个class是否被启用

   ```vue
   <div class="box" v-bind:class="{类名1:布尔值,类名2:布尔值}"></div>
   
   ```

   

   ```vue
   <a :class="{active:index===activeIndex}" href="#">{{item.name}}
   ```

   

2. 数组->数组中的所有类，都会添加到盒子上，本质是一个class列表.第二类是有特征的：第一个class样式是不绑定vue的，只有这个class里面的某个具体属性会绑定到vue。在于决定已经存在的class中的具体属性修改

   ```vue
   <div class="box" v-bind:class="{类名1,类名2,类名3}"
   ```

   ```vue
    <div class="inner" v-bind:style="{width:percent + '%'}">
   ```

   ```vue
   <div class:"box" :style="{width:'400px',height:'400px',background:'green'}"
   ```

   

### A.导航栏案例->v-bind应用

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
    <style>
        *{
            margin: 0;
            padding: 0;
        }
        ul{
            display: flex;
            border-bottom: 2px solid #e01222;
            padding: 0 10px;
        }
        li {
            width: 100px;
            height: 50px;
            line-height: 50px;
            list-style: none;
            text-align: center;
        }
        li a{
            display: block;
            text-decoration: none;
            font-weight: bold;
            color:#333333;
        }
        li a.active{
            background-color: #e01222;
            color: #fff;
        }
    </style>
</head>

<body>
    <div id="app">
       <ul>
        <li v-for="(item,index) in list" v-bind:key="item.id" @click="activeIndex = index">
            <a :class="{active:index===activeIndex}" href="#">{{item.name}}
        </li>
       </ul>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
       const app = new Vue({
        el:'#app',
        data:{
            activeIndex:1,
            list:[
                {Id:1,name:'秒杀窗口'},
                {id:2,name:'每日特价'},
                {id:3,name:'品类秒杀'}
            ]
        }
       })
    </script>
</body>

</html>

```

### B.进度条案例-v-bind绑定样式

```vue
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简单的 Vue 实例</title>
    <style>
       .progress{
        height: 25px;
        width: 400px;
        border-radius: 15px;
        background-color: #272425;
        border: 3px solid #272425;
        box-sizing: border-box;
        margin-bottom: 30px;
       }
       .inner{
        width: 50%;
        height: 20px;
        border-radius: 10px;
        text-align: right;
        position: relative;
        background-color: #409eff;
        background-size: 20px,20px;
        box-sizing: border-box;
        transition: all 1s; 
       }
       .inner span{
        position: absolute;
        right: -20px;
        bottom: -25px;
       }
    </style>
</head>
<!--
.inner中的 transition:all 1s是丝滑变化的原理


-->
<body>
    <div id="app">
        <div class="progress">
            <div class="inner" v-bind:style="{width:percent + '%'}"><!--这里必须把%引用 因为width后面要接一个数值-->
                <span>{{percent}}</span>
            </div>
        </div>
        <button @click="percent = 25">设置25%</button>
        <button @click="percent=50">设置50%</button>
        <button @click="percent = 75">设置75%</button>
        <button @click="percent =100">设置100%</button>
    </div>
   

    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script>
      const app = new Vue({
        el:'#app',
        data:{
            percent: 30
        }
      })
    </script>
</body>

</html>

```



## 3.v-model应用其他表单元素

作用：获取/设置表单元素的值

v-model会根据**控件类型**自动选择**正确的方法**来更新元素

```
input:text ->value
textarea ->value
intput:checkbox ->checked
input:radio ->checked
select ->value
```

*前置理解：*

​    *1. name:  给单选框加上 name 属性 可以分组 → 同一组互相会互斥*

​    *2. value: 给单选框加上 value 属性，用于提交给后台的数据*

   *结合 Vue 使用 → v-model*

*前置理解：*

​    *1. option 需要设置 value 值，提交给后台*

​    *2. select 的 value 值，关联了选中的 option 的 value 值*

   *结合 Vue 使用 → v-model*

```vue
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style>
    textare{
      display: block;
      width: 240px;
      height: 100px;
      margin: 10px 0;
    }
  </style>
</head>
<body>
  <div id="app">
    <h1>学习网站</h1>
    
    姓名：
    <input type="text" v-model="username">
    <br><br>

    是否单身:
    <input type="checkbox" v-model="isSingle">
    <br><br>
<!-- 
      前置理解：
        1. name:  给单选框加上 name 属性 可以分组 → 同一组互相会互斥
        2. value: 给单选框加上 value 属性，用于提交给后台的数据
      结合 Vue 使用 → v-model
    -->
    性别:
    <input v-model="gender" type="radio" name="gender" value="1">男
    <input v-model="gender" type="radio" name="gender" value="2">女
    <br><br>
<!-- 
      前置理解：
        1. option 需要设置 value 值，提交给后台
        2. select 的 value 值，关联了选中的 option 的 value 值
      结合 Vue 使用 → v-model
    -->
    所在城市：
    <select v-model="cityId">
      <option value="101">北京</option>
      <option value="102">上海</option>
      <option value="103">成都</option>
      <option value="104">南京</option>
    </select>
    <br><br>
    <button>立刻注册</button>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
  <script>
    const app = new Vue({
      el: '#app',
      data: {
        username:'',
        isSingle:false,
        gender:"2",
        cityId:'102',
        desc:""
      }
    })
  </script>
</body>
</html>
```



## 4.计算属性computed

概念：基于**现有的数据**，计算出来的**新属性**。**依赖**的数据变化，**自动**重新计算。

语法：

1.声明在computed配置项中，一个计算属性对应**一个函数**

2.使用起来和普通属性一样 {{计算属性名}}

计算属性->可以将一段**求值的代码**进行封装

3.如果在computed写了 xxx()这个方法 你就可以在html中{{xxx}} 至于xxx到底是怎么来的 交给xxx() 这里通常是this来调用data中的值+回调函数进行计算 



```vue
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style>
    table {
      border: 1px solid #000;
      text-align: center;
      width: 240px;
    }
    th,td{
      border: 1px solid #000;
    }
    h3{
      position: relative;
    }
  </style>
</head>
<body>
  <div id="app">
    <h1>礼物清单</h1>
    <table>
      <tr>
        <th>名字</th>
        <th>数量</th>
      </tr>
      <tr v-for="(item,index) in list" :key="item.id">
        <td>{{item.name}}</td>
        <td>{{item.num}}</td>
      </tr>
    </table>
    <p>礼物总数 {{totalCount}}</p>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
  <script>
    const app = new Vue({
      el: '#app',
      data: {
       list:[
        {id:1,name:'篮球',num:1},
        {id:2,name:'玩具',num:2},
        {id:3,name:'铅笔',num:5},
       ]
      },
      computed:{
        totalCount(){
          // 基于现有的数据，编写求值逻辑
          // 计算属性函数内部，可以直接通过 this 访问到 app 实例
          // console.log(this.list)

          // 需求：对 this.list 数组里面的 num 进行求和 → reduce
          let total=this.list.reduce((sum,item)=>sum+item.num,0)
          return total;
          /*this.list 是一个数组，其中包含了一些对象或元素。
reduce 方法是数组对象的一个高阶函数，用于将数组中的每个元素执行一个指定的回调函数，并将结果汇总成单个值。在这个例子中，reduce 会对 this.list 数组中的每个元素执行回调函数。
回调函数接受两个参数，第一个参数是累积值（通常命名为 accumulator，在这里命名为 sum），第二个参数是当前正在处理的元素（在这里命名为 item）。
回调函数执行的操作是将当前元素的 num 属性值加到累积值上。
初始值为 0，作为累积值的起始值。*/
        }
      }
    })
  </script>
</body>
</html>
```



## 5.computed计算属性vs方法methods

**computed计算属性：**

**作用：**封装了一段对于数据的处理，求得一个结果

**语法：**

1.写在**computed**的配置项中

2.作为属性，直接使用->**this.计算属性**{{计算属性}}



**methods方法：**

作用：给实例提供一个**方法**，调用以处理**业务逻辑**

**语法：**

1.写在**methods**配置项中

2.作为方法，需要调用 —> **this.方法名()** {{**方法名()**}} @事件名="**方法名**"

> 八股部分：
>
> 计算属性会对计算出来的**结果缓存**，再次使用直接读取缓存
>
> 依赖项变化了，会**自动**重新计算 ->并且**再次缓**存 （缓存特性-提升性能）

## 6.计算属性的完整写法

计算属性默认的简写，只能访问**读取**，不能**修改**

如果要**修改**，需要写计算属性的**完整写法**

一种常用逻辑：

1.Input中v-model绑定一个变量

2.展示部分以计算属性表示{{xxx}}

3.定义动态属性:xxx的get和set方法：return xxx (这里的xxx是data中的属性xxx)

以上操作完成就可以实现输入框的内容实时反馈到标签表现中

```js
computed:{
    计算属性名(){
        代码逻辑(计算逻辑)
        return 结果
    }
}

computed:{
    计算属性名：{
        get(){
            一段代码逻辑(计算逻辑)
            return 结果
        },
         set(修改的值)
        一段代码逻辑(修改逻辑)
}
```

```vue
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style>
    input{
      width: 30px;
    }
  </style>
</head>
<body>
  <div id="app">
   姓 <input type="text" v-model="firstName">+
   名 <input type="text" v-model="lastName">=
   <span>{{fullName}}</span><br><br>
   <button @click="changeName">改名卡</button>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
  <script>
    const app = new Vue({
      el:'#app',
      data:{
        firstName:'刘',
        lastName:'备',
      },
      methods:{
        changeName(){
          this.fullName = '黄忠'
        }
      },
      computed:{
        fullName:{
          get(){
            return this.firstName+this.lastName
          },
          set(value){
            this.firstName = value.slice(0,1)
            this.lastName=value.slice(1)
          }
        }
      }
    })
  </script>
</body>
</html>
```



## 7.成绩案例

要点分析：

- 计算属性中的方法

  - ```js
    this.list.reduce((sum,item)=>sum+list.score,0)
    //是指 用sum来储存累加变量 item表示当前处理的数组元素 类似于增强for中定义的第三方变量 0表示从0开始积累
    //这里是在对list数组中每个元素的score进行累加
    ```

  - ```js
    
    
    ```

- 函数中的方法

  - ```js
    this.list=this.list.filter(item=>item.id!==id)
    //非常经典的删除行
    //filter实质上会生成一个新的数组，这个数组的元素是满足 第三方变量的id不等于id,也就是说 我传入的id不会被添加到新的数组中
    ```

  - ```js
    this.list.unshift({
                        id:+new Date(),
                        subject : this.subject,
                        score: this.score
                    })
    this.subject='',
                    this.score=''
    //list.unshift作用是：修改数组更新视图 说白了就是往[]中添加一个{}
    //这里是用作<tr>的v-for中的元素
    //id用时间戳来代替 并且在标签中设定为:key
    //subject和score都取data中的 最后记得重置为空
    ```

    

```vue
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="./styles/index.css" />
    <title>Document</title>
  </head>
  <body>
   <div id="app" class="score-case">
    <div class="table">
        <table>
            <thead>
                <tr>
                    <th>编号</th>
                    <th>科目</th>
                    <th>成绩</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody v-if="list.length>0">
                <tr v-for="(item,index) in list" v-bind:key="item.id">
                    <td>{{index+1}}</td>
                    <td>{{item.subject}}</td>
                    <td :class="{red:item.score<60}">{{item.score}}</td>
                    <td><a @click.prevent="del(item.id)" href="https://www.baidu.com">删除</td>
                </tr>
            </tbody>
            <tbody v-else>
                <tr>
                    <td colspan="5">
                        <span>总分：{{totalScore}}</span>
                        <span style="margin-left: 50px">平均分:{{averageScore}}</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="form">
        <div class="form-item">
            <div class="label">科目:</div>
            <div class="input">
                <input type="text"
                placeholder="请输入科目"
                v-model.trim="subject"/>
            </div>
        </div>
        <div class="form-item">
            <div class="label">分数：</div>
            <div class="input">
                <input type="text" placeholder="请输入分数"
                v-model.number="score">
            </div>
        </div>
        <div class="form-item">
            <div class="label"></div>
            <div class="input">
                <button @click="add" class="submit">添加</button>
            </div>
        </div>
    </div>
   </div>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>

    <script>
      const app = new Vue({
        el:'#app',
        data:{
            list:[
                {id:1,subject:'语文',score:62},
                {id:7,subject:'数学',score:89},
                {id:12,subject:'英语',score:70},
            ],
            subject:'',
            score:''
        },
        computed:{
            totalScore(){
                return this.list.reduce((sum,item)=>sum+list.score,0)
            },
            averageScore(){
                if(this.list.length==0){
                    return 0
                }
                return (this.totalScore/this.list.length).toFixed(2)
            }
        },
        methods:{
            del(id){
                this.list=this.list.filter(item=>item.id!==id)
            },
            add(){
                if(!this.subject){
                    alert("请输入科目")
                    return
                }
                if(typeof this.score!=='number'){
                    alert("请输入正确的成绩")
                    return
                }
                this.list.unshift({
                    id:+new Date(),
                    subject : this.subject,
                    score: this.score
                })

                this.subject='',
                this.score=''
            
            }
        }
      })
    </script>
  </body>
</html>

```

## 8.watch-简写-语法

作用：**监视数据变化**，执行**业务逻辑**或者**异步操作**

语法：

- 1.简单写法->简单类型数据，直接监视

- 2.完整写法->添加额外配置项
  - **deep:true** 对复杂类型深度监视
  - **immediate:true** 初始化立刻执行一次**handler**方法
  - **handler**就是简单写法中的监视发生变化执行的代码

**简单写法**：

```js
data:{
    words:'苹果',
    obj:{
        words:'苹果'
    }
     
},
    watch{
        //该方法会在数据变化时触发执行
        数据属性名(newValue,oldValue){
            //业务逻辑
        },
        '对象.属性名'(newValue,OldValue){
            //业务逻辑
        }
    }
```

完整写法：

```javascript
const app = new Vue({
    el:'#app',
    data:{
        obj:{
            words:'苹果',
            lang:'italy'
        },
    },
    watch:{
        数据属性名:{
            deep:true//深度监视
            handler(newValue){
        console.log(newValue)
    }
        }
    }
})
```

## 9.watch-简写-业务实现

```js
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-size: 18px;
      }
      #app {
        padding: 10px 20px;
      }
      .query {
        margin: 10px 0;
      }
      .box {
        display: flex;
      }
      textarea {
        width: 300px;
        height: 160px;
        font-size: 18px;
        border: 1px solid #dedede;
        outline: none;
        resize: none;
        padding: 10px;
      }
      textarea:hover {
        border: 1px solid #1589f5;
      }
      .transbox {
        width: 300px;
        height: 160px;
        background-color: #f0f0f0;
        padding: 10px;
        border: none;
      }
      .tip-box {
        width: 300px;
        height: 25px;
        line-height: 25px;
        display: flex;
      }
      .tip-box span {
        flex: 1;
        text-align: center;
      }
      .query span {
        font-size: 18px;
      }

      .input-wrap {
        position: relative;
      }
      .input-wrap span {
        position: absolute;
        right: 15px;
        bottom: 15px;
        font-size: 12px;
      }
      .input-wrap i {
        font-size: 20px;
        font-style: normal;
      }
    </style>
  </head>
  <body>
    <div id="app">
      <!-- 条件选择框 -->
      <div class="query">
        <span>翻译成的语言：</span>
        <select>
          <option value="italy">意大利</option>
          <option value="english">英语</option>
          <option value="german">德语</option>
        </select>
      </div>

      <!-- 翻译框 -->
      <div class="box">
        <div class="input-wrap">
          <textarea v-model="obj.words"></textarea>
          <span><i>⌨️</i>文档翻译</span>
        </div>
        <div class="output-wrap">
          <div class="transbox">{{ result }}</div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script>
      // 接口地址：https://applet-base-api-t.itheima.net/api/translate
      // 请求方式：get
      // 请求参数：
      // （1）words：需要被翻译的文本（必传）
      // （2）lang： 需要被翻译成的语言（可选）默认值-意大利
      // -----------------------------------------------
      
      const app = new Vue({
        el: '#app',
        data: {
          // words: ''
          obj: {
            words: ''
          },
          result: '', // 翻译结果
          // timer: null // 延时器id
        },
        // 具体讲解：(1) watch语法 (2) 具体业务实现
        watch: {
          // 该方法会在数据变化时调用执行
          // newValue新值, oldValue老值（一般不用）
          // words (newValue) {
          //   console.log('变化了', newValue)
          // }

          'obj.words' (newValue) {
            // console.log('变化了', newValue)
            // 防抖: 延迟执行 → 干啥事先等一等，延迟一会，一段时间内没有再次触发，才执行
            clearTimeout(this.timer)
            this.timer = setTimeout(async () => {
              const res = await axios({
                url: 'https://applet-base-api-t.itheima.net/api/translate',
                params: {
                  words: newValue
                }
              })
              this.result = res.data.data
              console.log(res.data.data)
            }, 300)
          }
        }
      })
    </script>
  </body>
</html>

```



## 10.watch-完整写法

```javascript
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-size: 18px;
      }
      #app {
        padding: 10px 20px;
      }
      .query {
        margin: 10px 0;
      }
      .box {
        display: flex;
      }
      textarea {
        width: 300px;
        height: 160px;
        font-size: 18px;
        border: 1px solid #dedede;
        outline: none;
        resize: none;
        padding: 10px;
      }
      textarea:hover {
        border: 1px solid #1589f5;
      }
      .transbox {
        width: 300px;
        height: 160px;
        background-color: #f0f0f0;
        padding: 10px;
        border: none;
      }
      .tip-box {
        width: 300px;
        height: 25px;
        line-height: 25px;
        display: flex;
      }
      .tip-box span {
        flex: 1;
        text-align: center;
      }
      .query span {
        font-size: 18px;
      }

      .input-wrap {
        position: relative;
      }
      .input-wrap span {
        position: absolute;
        right: 15px;
        bottom: 15px;
        font-size: 12px;
      }
      .input-wrap i {
        font-size: 20px;
        font-style: normal;
      }
    </style>
  </head>
  <body>
    <div id="app">
      <!-- 条件选择框 -->
      <div class="query">
        <span>翻译成的语言：</span>
        <select v-model="obj.lang">
          <option value="italy">意大利</option>
          <option value="english">英语</option>
          <option value="german">德语</option>
        </select>
      </div>

      <!-- 翻译框 -->
      <div class="box">
        <div class="input-wrap">
          <textarea v-model="obj.words"></textarea>
          <span><i>⌨️</i>文档翻译</span>
        </div>
        <div class="output-wrap">
          <div class="transbox">{{ result }}</div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script>
      // 需求：输入内容，修改语言，都实时翻译

      // 接口地址：https://applet-base-api-t.itheima.net/api/translate
      // 请求方式：get
      // 请求参数：
      // （1）words：需要被翻译的文本（必传）
      // （2）lang： 需要被翻译成的语言（可选）默认值-意大利
      // -----------------------------------------------
   
      const app = new Vue({
        el: '#app',
        data: {
          obj: {
            words: '小黑',
            lang: 'italy'
          },
          result: '', // 翻译结果
        },
        watch: {
          obj: {
            deep: true, // 深度监视
            immediate: true, // 立刻执行，一进入页面handler就立刻执行一次
            handler (newValue) {
              clearTimeout(this.timer)
              this.timer = setTimeout(async () => {
                const res = await axios({
                  url: 'https://applet-base-api-t.itheima.net/api/translate',
                  params: newValue
                })
                this.result = res.data.data
                console.log(res.data.data)
              }, 300)
            }
          }


          // 'obj.words' (newValue) {
          //   clearTimeout(this.timer)
          //   this.timer = setTimeout(async () => {
          //     const res = await axios({
          //       url: 'https://applet-base-api-t.itheima.net/api/translate',
          //       params: {
          //         words: newValue
          //       }
          //     })
          //     this.result = res.data.data
          //     console.log(res.data.data)
          //   }, 300)
          // }
        }
      })
    </script>
  </body>
</html>

```



## 11.项目实战

- 方法集锦：

  - ```js
    this.fruitList.every(item=>item.isChecked)
    //every方法：检查fruitList数组中每个元素是否都有isChecked为true,只有全部满足则返回false
    //返回 true/false
    
    this.fruitList.array.forEach(item=>item.isChecked=value)
    //将item.isChecked设置为你想设置的值 value是外部传入的参数
    //返回true/false;
    
    this.fruitList.reduce((sum,item)=>{
                            if(item.isChecked){
                                return sum+item.num*item.price;{
                                    return sum;
                                }
                            }
    /*
    reduce是JavaScript提供的高阶函数,对数组中的每一个元素,执行一个提供的回调函数
    通常用于数组累加+汇总+转换
    
    reduce函数有两个parameters 回调函数+初始值（初始值是放在外面的,并且是累加器）
    回调函数有四个参数: 累加器(sum),当前元素(item),当前索引,原数组
    返回值
    */
        
    const fruit = this.fruitList.find(item=>item.id===id)
    //find是返回一个值
    ```

- 监视器实现本地储存

  - ```js
    watch:{
                    fruitlist:{
                        deep:true,
                        handler(newValue){
                            localStorage.setItem('list',JSON.stringify(newValue))
                        }
                    }
                }
    ```

    

```vue
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="./css/inputnumber.css" />
    <link rel="stylesheet" href="./css/index.css" />
    <title>购物车</title>
  </head>
  <body>
    <div class="app-container" id="app">
      <!-- 顶部banner -->
      <div class="banner-box"><img src="D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/fruit.jpg" alt="" /></div>
      <!-- 面包屑 -->
      <div class="breadcrumb">
        <span>🏠</span>
        /
        <span>购物车</span>
      </div>
      <!-- 购物车主体 -->
      <div class="main" v-if="fruitList.length > 0">
        <div class="table">
          <!-- 头部 -->
          <div class="thead">
            <div class="tr">
              <div class="th">选中</div>
              <div class="th th-pic">图片</div>
              <div class="th">单价</div>
              <div class="th num-th">个数</div>
              <div class="th">小计</div>
              <div class="th">操作</div>
            </div>
          </div>
          <!-- 身体 -->
          <div class="tbody">
            <div v-for="(item, index) in fruitList" :key="item.id" class="tr" :class="{ active: item.isChecked }">
              <div class="td"><input type="checkbox" v-model="item.isChecked" /></div>
              <div class="td"><img :src="item.icon" alt="" /></div>
              <div class="td">{{ item.price }}</div>
              <div class="td">
                <div class="my-input-number">
                  <button :disabled="item.num <= 1" class="decrease" @click="sub(item.id)"> - </button>
                  <span class="my-input__inner">{{ item.num }}</span>
                  <button class="increase" @click="add(item.id)"> + </button>
                </div>
              </div>
              <div class="td">{{ item.num * item.price }}</div>
              <div class="td"><button @click="del(item.id)">删除</button></div>
            </div>
          </div>
        </div>
        <!-- 底部 -->
        <div class="bottom">
          <!-- 全选 -->
          <label class="check-all">
            <input type="checkbox" v-model="isAll"/>
            全选
          </label>
          <div class="right-box">
            <!-- 所有商品总价 -->
            <span class="price-box">总价&nbsp;&nbsp;:&nbsp;&nbsp;¥&nbsp;<span class="price">{{ totalPrice }}</span></span>
            <!-- 结算按钮 -->
            <button class="pay">结算( {{ totalCount }} )</button>
          </div>
        </div>
      </div>
      <!-- 空车 -->
      <div class="empty" v-else>🛒空空如也</div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script>
      const defaultArr = [
            {
              id: 1,
              icon: 'D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/火龙果.png',
              isChecked: true,
              num: 2,
              price: 6,
            },
            {
              id: 2,
              icon: 'D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/荔枝.png',
              isChecked: false,
              num: 7,
              price: 20,
            },
            {
              id: 3,
              icon: 'D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/榴莲.png',
              isChecked: false,
              num: 3,
              price: 40,
            },
            {
              id: 4,
              icon: 'D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/鸭梨.png',
              isChecked: true,
              num: 10,
              price: 3,
            },
            {
              id: 5,
              icon: 'D:/desklop/湖科大计算机科学与技术系/Vue/Vue2+3入门到实战-配套资料/01-随堂代码&素材/day02/day02/code/15-综合案例-购物车/img/樱桃.png',
              isChecked: false,
              num: 20,
              price: 34,
            },
          ]
      const app = new Vue({
        el: '#app',
        data: {
          // 水果列表
          fruitList: JSON.parse(localStorage.getItem('list')) || defaultArr,
        },
        computed: {
          // 默认计算属性：只能获取不能设置，要设置需要写完整写法
          // isAll () {
          //   // 必须所有的小选框都选中，全选按钮才选中 → every
          //   return this.fruitList.every(item => item.isChecked)
          // }
          
          // 完整写法 = get + set
          isAll: {
            get () {
              return this.fruitList.every(item => item.isChecked)
            },
            set (value) {
              // 基于拿到的布尔值，要让所有的小选框 同步状态
              this.fruitList.forEach(item => item.isChecked = value)
            }
          },
          // 统计选中的总数 reduce
          totalCount () {
            return this.fruitList.reduce((sum, item) => {
              if (item.isChecked) {
                // 选中 → 需要累加
                return sum + item.num
              } else {
                // 没选中 → 不需要累加
                return sum
              }
            }, 0)
          },
          // 总计选中的总价 num * price
          totalPrice () {
            return this.fruitList.reduce((sum, item) => {
              if (item.isChecked) {
                return sum + item.num * item.price
              } else {
                return sum
              }
            }, 0)
          }
        },
        methods: {
          del (id) {
            this.fruitList = this.fruitList.filter(item => item.id !== id)
          },
          add (id) {
            // 1. 根据 id 找到数组中的对应项 → find
            const fruit = this.fruitList.find(item => item.id === id)
            // 2. 操作 num 数量
            fruit.num++
          },
          sub (id) {
            // 1. 根据 id 找到数组中的对应项 → find
            const fruit = this.fruitList.find(item => item.id === id)
            // 2. 操作 num 数量
            fruit.num--
          }
        },
        watch: {
          fruitList: {
            deep: true,
            handler (newValue) {
              // 需要将变化后的 newValue 存入本地 （转JSON）
              localStorage.setItem('list', JSON.stringify(newValue))
            }
          }
        }
      })
    </script>
  </body>
</html>

```

# 五:生命周期/综合案例/工程化开发入门/工程化案例

## 1.生命周期&生命周期四个阶段

**思考：**什么时候可以发送**初始化渲染请求**（越早越好）什么时候可以开始**操作dom**(至少dom得渲染出来)

**Vue生命周期：**一个**Vue实例**从**创建**到**销毁**的整个过程

**四个阶段：**

- 创建阶段（new Vue()）

  - ```js
    data:{
        title:;计数器,
        count:100
    }//响应式数据
    //发送初始化渲染请求
    ```

    

- 挂载阶段

  - ```html
    <div id="#app">
        <h3>
            {{title}}
        </h3>
        <div>
            <button>-</button>
            <span>{{count}}</span>
            <button>+</button>
        </div>
    </div>
    <!--渲染模板同时操作Dom-->
    ```

    

- 更新阶段

  - 点击网页的加减号，修改数据的同时就会更新视图

- 销毁阶段

  - 销毁实例

## 2.生命周期钩子

**定义：**Vue生命周期过程中，会**自动运行一些函数**，被称为**生命周期钩子**->开发者在**特定阶段**运行**自己的代码**

地位：在Vue实例内部是最高的一批，和el与data是平级的

```js
1.创建阶段：
beforeCreate
created//主要作用
2.挂载阶段（渲染模板）
beforeMount
mounted//主要作用
3.更新阶段:修改数据，更新视图
beforeUpdate
updated//主要作用
4.销毁阶段:销毁实例:释放Vue外的资源，清除定时器，延时器
beforeDestory
destoryed//主要作用
```

具体的函数例子：

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
    <div id="app">
        <h3>{{title}}</h3>
        <div>
            <button @click="count--">-</button>
            <span>{{count}}</span>
            <button @click="count++">+</button>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script>
        const app=new Vue({
            el:'#app',
            data:{
                count:100,
                title:'计数器'
            },
            beforeCreate(){
                console.log("beforeCreate响应式数据准备好以前",this.count)
            },
            created(){
                console.log("created响应式数据准备好之后",this.count)

            },
            beforeMount(){
                console.log("beforeMount模板渲染之前",document.querySelectorAll('h3').innerHTML)

            },
            mounted(){
                console.log("mounted模板渲染之后")
            },
            beforeUpdate(){
                console.log("beforeUpdate")
            },
            updated(){
                console.log("updated")
            },
            beforeDestory(){
                console.log('beforeDestory定时器')
            },
            destoryed(){
                console.log('destoryed')
            }
        })
    </script>
</body>
```



## 3.生命周期案例

### A.created新闻案例

- created()->获取data

- 本案例的data是额外储存的，因此需要通过created获取，然后将data储存到本地vue的data属性中

- ```js
  async created () {
          // 1. 发送请求获取数据
          const res = await axios.get('http://hmajax.itheima.net/api/news')
          // 2. 更新到 list 中，用于页面渲染 v-for
          this.list = res.data.data
        }
      })
  ```

- async标识意味着created是一个异步方法

- 使用了axios库来获取网址中的data包

- 并且通过.data方法进行解包,下面为网址中的包

- ```js
  {
      "message": "获取新闻列表成功",
      "data": [
          {
              "id": 1,
              "title": "5G渗透率持续提升，创新业务快速成长",
              "source": "新京报经济新闻",
              "cmtcount": 58,
              "img": "http://ajax-api.itheima.net/images/0.webp",
              "time": "2222-10-28 11:50:28"
          },
          {
              "id": 5,
              "title": "为什么说中美阶段性协议再近一步，读懂周末的这些关键信息",
              "source": "澎湃新闻",
              "cmtcount": 131,
              "img": "http://ajax-api.itheima.net/images/4.webp",
              "time": "2222-10-24 09:08:34"
          },
          {
              "id": 6,
              "title": "阿根廷大选结果揭晓：反对派费尔南德斯有话要说",
              "source": "海外网",
              "cmtcount": 99,
              "img": "http://ajax-api.itheima.net/images/5.webp",
              "time": "2222-10-23 17:41:15"
          },
          {
              "id": 8,
              "title": "LV母公司当年史上最大并购：报价145亿美元购Tiffany",
              "source": "澎湃新闻",
              "cmtcount": 119,
              "img": "http://ajax-api.itheima.net/images/7.webp",
              "time": "2222-10-22 03:59:44"
          },
          {
              "id": 9,
              "title": "黄峥当年1350亿蝉联80后白手起家首富：1年中财富每天涨1个亿",
              "source": "胡润百富",
              "cmtcount": 676,
              "img": "http://ajax-api.itheima.net/images/8.webp",
              "time": "2222-10-21 06:19:37"
          }
      ]
  }
  ```

  

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      list-style: none;
    }
    .news {
      display: flex;
      height: 120px;
      width: 600px;
      margin: 0 auto;
      padding: 20px 0;
      cursor: pointer;
    }
    .news .left {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding-right: 10px;
    }
    .news .left .title {
      font-size: 20px;
    }
    .news .left .info {
      color: #999999;
    }
    .news .left .info span {
      margin-right: 20px;
    }
    .news .right {
      width: 160px;
      height: 120px;
    }
    .news .right img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  </style>
</head>
<body>

  <div id="app">
    <ul>
      <li v-for="(item, index) in list" :key="item.id" class="news">
        <div class="left">
          <div class="title">{{ item.title }}</div>
          <div class="info">
            <span>{{ item.source }}</span>
            <span>{{ item.time }}</span>
          </div>
        </div>
        <div class="right">
          <img :src="item.img" alt="">
        </div>
      </li>
    </ul>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
  <script>
    // 接口地址：http://hmajax.itheima.net/api/news
    // 请求方式：get
    const app = new Vue({
      el: '#app',
      data: {
        list: []
      },
      async created () {
        // 1. 发送请求获取数据
        const res = await axios.get('http://hmajax.itheima.net/api/news')
        // 2. 更新到 list 中，用于页面渲染 v-for
        this.list = res.data.data
      }
    })
  </script>
</body>
</html>
```

### B.焦点的获取

- 焦点获取，是对标签的操作，因此是渲染过程，因此通过mounted进行

- ```js
  
      // 核心思路：
      // 1. 等input框渲染出来 mounted 钩子
      // 2. 让input框获取焦点 inp.focus()
      mounted () {
        document.querySelector('#inp').focus()
      }
  ```

  

```js

<!DOCTYPE html>
<html lang="zh-CN">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>示例-获取焦点</title>
  <!-- 初始化样式 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reset.css@2.0.2/reset.min.css">
  <!-- 核心样式 -->
  <style>
    html,
    body {
      height: 100%;
    }
    .search-container {
      position: absolute;
      top: 30%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }
    .search-container .search-box {
      display: flex;
    }
    .search-container img {
      margin-bottom: 30px;
    }
    .search-container .search-box input {
      width: 512px;
      height: 16px;
      padding: 12px 16px;
      font-size: 16px;
      margin: 0;
      vertical-align: top;
      outline: 0;
      box-shadow: none;
      border-radius: 10px 0 0 10px;
      border: 2px solid #c4c7ce;
      background: #fff;
      color: #222;
      overflow: hidden;
      box-sizing: content-box;
      -webkit-tap-highlight-color: transparent;
    }
    .search-container .search-box button {
      cursor: pointer;
      width: 112px;
      height: 44px;
      line-height: 41px;
      line-height: 42px;
      background-color: #ad2a27;
      border-radius: 0 10px 10px 0;
      font-size: 17px;
      box-shadow: none;
      font-weight: 400;
      border: 0;
      outline: 0;
      letter-spacing: normal;
      color: white;
    }
    body {
      background: no-repeat center /cover;
      background-color: #edf0f5;
    }
  </style>
</head>

<body>
<div class="container" id="app">
  <div class="search-container">
    <img src="https://www.itheima.com/images/logo.png" alt="">
    <div class="search-box">
      <input type="text" v-model="words" id="inp">
      <button>搜索一下</button>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
<script>
  const app = new Vue({
    el: '#app',
    data: {
      words: ''
    },
    // 核心思路：
    // 1. 等input框渲染出来 mounted 钩子
    // 2. 让input框获取焦点 inp.focus()
    mounted () {
      document.querySelector('#inp').focus()
    }
  })
</script>

</body>

</html>
```



## 4.综合案例：记账本

### A.列表渲染：

​    **   (1) 立刻发送请求获取数据 created*

​    **   (2) 拿到数据，存到data的响应式数据中*

​    **   (3) 结合数据，进行渲染 v-for*

​    **   (4) 消费统计 => 计算属性*

> `toFixed()` 是 JavaScript 中用于将数字转换为指定小数位数的字符串的方法。
>
> 具体来说，`toFixed(2)` 方法会将数字四舍五入到指定的小数位数，并返回一个字符串表示结果。

```js
         computed:{
            totalPrice(){
                return this.list.reduce((sum,item)=>sum+item.price,0)
            },
mounted(){

          
```



### B.添加

​    **   (1) 收集表单数据 v-model*

​    **   (2) 给添加按钮注册点击事件，发送添加请求*

​    **   (3) 需要重新渲染*

```js
 async add () {
            if (!this.name) {
              alert('请输入消费名称')
              return
            }
            if (typeof this.price !== 'number') {
              alert('请输入正确的消费价格')
              return
            }

            // 发送添加请求
            const res = await axios.post('https://applet-base-api-t.itheima.net/bill', {
              creator: '小黑',
              name: this.name,
              price: this.price
            })
            // 重新渲染一次
            this.getList()

            this.name = ''
            this.price = ''
          },
```



### C.删除

​    **   (1) 注册点击事件，传参传 id*

​    **   (2) 根据 id 发送删除请求*

​    **   (3) 需要重新渲染*

```js
async del (id) {
            // 根据 id 发送删除请求
            const res = await axios.delete(`https://applet-base-api-t.itheima.net/bill/${id}`)
            // 重新渲染
            this.getList()
          }
```



### D.饼图渲染

​    **   (1) 初始化一个饼图 echarts.init(dom)  mounted钩子实现*

​    **   (2) 根据数据实时更新饼图 echarts.setOption({ ... })*

```
  this.myChart = echarts.init(document.querySelector('#main'))
          this.myChart.setOption({
            // 大标题
            title: {
              text: '消费账单列表',
              left: 'center'
            },
            // 提示框
            tooltip: {
              trigger: 'item'
            },
            // 图例
            legend: {
              orient: 'vertical',
              left: 'left'
            },
            // 数据项
            series: [
              {
                name: '消费账单',
                type: 'pie',
                radius: '50%', // 半径
                data: [
                  // { value: 1048, name: '球鞋' },
                  // { value: 735, name: '防晒霜' }
                ],
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          })
      },
```

E.整体工程

```vue
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <!-- CSS only -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    />
    <style>
      .red {
        color: red!important;
      }
      .search {
        width: 300px;
        margin: 20px 0;
      }
      .my-form {
        display: flex;
        margin: 20px 0;
      }
      .my-form input {
        flex: 1;
        margin-right: 20px;
      }
      .table > :not(:first-child) {
        border-top: none;
      }
      .contain {
        display: flex;
        padding: 10px;
      }
      .list-box {
        flex: 1;
        padding: 0 30px;
      }
      .list-box  a {
        text-decoration: none;
      }
      .echarts-box {
        width: 600px;
        height: 400px;
        padding: 30px;
        margin: 0 auto;
        border: 1px solid #ccc;
      }
      tfoot {
        font-weight: bold;
      }
      @media screen and (max-width: 1000px) {
        .contain {
          flex-wrap: wrap;
        }
        .list-box {
          width: 100%;
        }
        .echarts-box {
          margin-top: 30px;
        }
      }
    </style>
  </head>
  <body>
    <div id="app">
      <div class="contain">
        <!-- 左侧列表 -->
        <div class="list-box">

          <!-- 添加资产 -->
          <form class="my-form">
            <input v-model.trim="name" type="text" class="form-control" placeholder="消费名称" />
            <input v-model.number="price" type="text" class="form-control" placeholder="消费价格" />
            <button @click="add" type="button" class="btn btn-primary">添加账单</button>
          </form>

          <table class="table table-hover">
            <thead>
              <tr>
                <th>编号</th>
                <th>消费名称</th>
                <th>消费价格</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in list" :key="item.id">
                <td>{{ index + 1 }}</td>
                <td>{{ item.name }}</td>
                <td :class="{ red: item.price > 500 }">{{ item.price.toFixed(2) }}</td>
                <td><a @click="del(item.id)" href="javascript:;">删除</a></td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <td colspan="4">消费总计： {{ totalPrice.toFixed(2) }}</td>
              </tr>
            </tfoot>
          </table>
        </div>
        
        <!-- 右侧图表 -->
        <div class="echarts-box" id="main"></div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.0/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script>
      /**
       * 接口文档地址：
       * https://www.apifox.cn/apidoc/shared-24459455-ebb1-4fdc-8df8-0aff8dc317a8/api-53371058
       * 
       * 功能需求：
       * 1. 基本渲染
       *    (1) 立刻发送请求获取数据 created
       *    (2) 拿到数据，存到data的响应式数据中
       *    (3) 结合数据，进行渲染 v-for
       *    (4) 消费统计 => 计算属性
       * 2. 添加功能
       *    (1) 收集表单数据 v-model
       *    (2) 给添加按钮注册点击事件，发送添加请求
       *    (3) 需要重新渲染
       * 3. 删除功能
       *    (1) 注册点击事件，传参传 id
       *    (2) 根据 id 发送删除请求
       *    (3) 需要重新渲染
       * 4. 饼图渲染
       *    (1) 初始化一个饼图 echarts.init(dom)  mounted钩子实现
       *    (2) 根据数据实时更新饼图 echarts.setOption({ ... })
       */
      const app = new Vue({
        el: '#app',
        data: {
          list: [],
          name: '',
          price: ''
        },
        computed: {
          totalPrice () {
            return this.list.reduce((sum, item) => sum + item.price, 0)
          }
        },
        created () {
          // const res = await axios.get('https://applet-base-api-t.itheima.net/bill', {
          //   params: {
          //     creator: '小黑'
          //   }
          // })
          // this.list = res.data.data

          this.getList()
        },
        mounted () {
          this.myChart = echarts.init(document.querySelector('#main'))
          this.myChart.setOption({
            // 大标题
            title: {
              text: '消费账单列表',
              left: 'center'
            },
            // 提示框
            tooltip: {
              trigger: 'item'
            },
            // 图例
            legend: {
              orient: 'vertical',
              left: 'left'
            },
            // 数据项
            series: [
              {
                name: '消费账单',
                type: 'pie',
                radius: '50%', // 半径
                data: [
                  // { value: 1048, name: '球鞋' },
                  // { value: 735, name: '防晒霜' }
                ],
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          })
        },

        methods: {
          async getList () {
            const res = await axios.get('https://applet-base-api-t.itheima.net/bill', {
              params: {
                creator: '小黑'
              }
            })
            this.list = res.data.data

            // 更新图表
            this.myChart.setOption({
              // 数据项
              series: [
                {
                  // data: [
                  //   { value: 1048, name: '球鞋' },
                  //   { value: 735, name: '防晒霜' }
                  // ]
                  data: this.list.map(item => ({ value: item.price, name: item.name}))
                }
              ]
            })
          },
          async add () {
            if (!this.name) {
              alert('请输入消费名称')
              return
            }
            if (typeof this.price !== 'number') {
              alert('请输入正确的消费价格')
              return
            }

            // 发送添加请求
            const res = await axios.post('https://applet-base-api-t.itheima.net/bill', {
              creator: '小黑',
              name: this.name,
              price: this.price
            })
            // 重新渲染一次
            this.getList()

            this.name = ''
            this.price = ''
          },
          async del (id) {
            // 根据 id 发送删除请求
            const res = await axios.delete(`https://applet-base-api-t.itheima.net/bill/${id}`)
            // 重新渲染
            this.getList()
          }
        }
      })
    </script>
  </body>
</html>

```



## 5.工程化开发入门

### A.工程化开发和脚手架

1.核心包传统开发模式:基于html/css/js文件，直接引入核心包，开发Vue

**2.工程化开发模式：基于构建工具(webpack)的环境中开发Vue**

> es6语法/typescript/less/sass ->(webpack自动化 编译压缩组合) js(es3/es5) css
>
> 问题：
>
> 1. webpack配置复杂
> 2. 雷同的基础配置
> 3. 缺乏统一标准
>
> 我们需要工具，生成标准化的配置

**基本介绍：**

Vue CLI是Vue官方提供的命令行工具，可以帮助我们**快速创建**一个开发Vue项目的**标准化基础架子**

**好处：**

1. 开箱即用
2. 内置babel等工具
3. 标准化

**使用步骤：**

1. 全局安装：yarn global add @vue/cli 或者 npm @vue/cli -g
2. 查看vue版本： vue --version
3. 创建项目架子： vue create project-name(项目名不能用中文)
4. 启动项目：yarn serve 或者npm run serve (找package.json)



### B.目录介绍与项目运行流程

```
Vue-demo
|-node_modules 第三方包文件夹
|-public 放html的地方
| |-favicon.ico 网站图标
| |-index.html index.html模板文件
|-src 源代码目录->以后写代码的文件夹
| |-assets:静态资源目录-存放图片与字体等
| |-components 组件目录->存放通用组件
| |-App.vue App根组件->项目运行看到的内容就在这里编写
| |-main.js 入口文件->打包或者运行第一个执行的文件
|-.gitignore git忽视文件
|-babel.config.js babel配置文件
|-package.json 项目配置文件->项目名，版本号，script,依赖包
|-README.md 项目说明文档
|-vue.config.js vue-cli配置文件
|-yarn.lock yarn锁文件，由yarn自动生成的，用来锁定安装版本

//Babel是JavaScript编译器，作用是ECMAScript2015+(ES6+)转化为向后版本的JavaScript版本，方便在旧版本的浏览器或者环境执行
//yarn.lock是yarn包管理器自动生成的锁定文件，用于确保项目的依赖项在不同环境中有一致的版本。
```

**项目运行过程：**

yarn serve->main.js(App.vue注入到main.js 过程如下)->index.html

```js
import Vue from 'vue'
import App from './App.vue'
new Vue({
    render:h=>h(App)
}).$mount('#app')
//描述的是App注入到main.js的过程
/*
new Vue({}): 这部分是创建一个新的 Vue 实例。Vue 实例是 Vue.js 应用程序的核心。通过 new Vue({})，我们实例化了一个 Vue 对象，用于管理应用的数据、状态和行为。

render: h => h(App): 这里是 Vue 实例的配置选项之一，它定义了 Vue 实例如何渲染内容。在这个例子中，render 函数接受一个参数 h，它是一个用来创建虚拟 DOM 元素的函数。h(App) 表示使用 h 函数创建一个 App 组件的虚拟 DOM 元素。

.$mount('#app'): 这是将 Vue 实例挂载到 HTML 页面上的一种方式。$mount 方法用于手动挂载 Vue 实例到一个特定的 DOM 元素上。'#app' 是一个 CSS 选择器，它指定了要挂载到的 HTML 元素的 id，这里表示挂载到 id 为 app 的元素上。

*/
```

### C.组件化

**1.组件化：**一个页面可以拆分成**若干组件**，每个组件都有独立的**结构**，样式，**行为**

- 好处：便于维护，利于复用，提升开发效率
- 组件分类：普通组件、根组件

**2.根组件：**整个应用最上层的组件，包裹所有普通小组件

![image-20240510230852069](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240510230852069.png)

![image-20240510230859759](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240510230859759.png)

**App.vue文件（单文本组件）的三个组成成分**：

- template:结构（有且只有一个根元素：所有的html元素包含在一个元素内部）
- script:js逻辑
- style：样式（可支持less，需要装包）

**让组件支持Less:**

1. style标签，lang="less"开启less功能
2. 装包:yarn add less less-loader

#### less代是一种css预处理器，扩展了css语言，我们给出一个例子。

Less 是一种功能强大的 CSS 预处理器，它提供了许多有用的功能来简化和优化 CSS 的编写。以下是一些 Less 中常用的代码示例：

1. **变量（Variables）**：使用变量来存储颜色、尺寸、字体等重复使用的值，以便统一管理和调整。

```less
lessCopy Code@primary-color: #3498db;
@font-stack: Arial, sans-serif;
@base-padding: 10px;
```

1. **嵌套规则（Nested Rules）**：可以在选择器内部嵌套其他选择器，提高样式的可读性和维护性。

```less
lessCopy Code.nav {
  ul {
    list-style: none;
  }
  li {
    display: inline-block;
    margin-right: 10px;
    a {
      text-decoration: none;
    }
  }
}
```

1. **混合器（Mixins）**：类似于函数，可以将一组 CSS 属性集合定义为一个混合器，然后在需要的地方调用。

```less
lessCopy Code.rounded-corners(@radius: 5px) {
  border-radius: @radius;
}
```

1. **运算（Operations）**：可以在 Less 中执行数学运算，如加法、减法、乘法和除法。

```less
lessCopy Code@base-padding: 10px;
@extra-padding: 5px;
.padding {
  padding: @base-padding + @extra-padding;
}
```

1. **导入其他 Less 文件（Import）**：可以将一个 Less 文件导入到另一个 Less 文件中，以便将样式模块化管理。

```less
lessCopy Code@import "variables.less";
@import "mixins.less";
```

1. **条件语句（Conditionals）**：可以使用条件语句根据条件设置样式。

```less
lessCopy Code@background-color: #fff;
body {
  background-color: @background-color;
  @media screen and (max-width: 600px) {
    background-color: #f5f5f5;
  }
}
```

1. **循环（Loops）**：可以使用循环生成重复的样式，减少重复代码。

```less
lessCopy Code.columns(@n) when (@n > 0) {
  .column-@{n} {
    width: 100% / @n;
  }
  .columns(@n - 1);
}
.columns(12);
```

这些是 Less 中一些常用的代码示例，它们使得样式表更加灵活、易维护，并提高了开发效率。

### D.组件注册

#### A.分类

1.局部注册

- 创建.vue文件（三个组成部分）
- 在使用的组件内导入并且注册



![image-20240510232940607](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240510232940607.png)

```vue
<template>
  <div class="hm-footer">
    我是hm-footer
  </div>
</template>

<script>
export default {

}
</script>

<style>
.hm-footer {
  height: 100px;
  line-height: 100px;
  text-align: center;
  font-size: 30px;
  background-color: #4f81bd;
  color: white;
}
</style>
```

```vue
<template>
  <div class="hm-header">
    我是hm-header
  </div>
</template>

<script>
export default {

}
</script>

<style>
.hm-header {
  height: 100px;
  line-height: 100px;
  text-align: center;
  font-size: 30px;
  background-color: #8064a2;
  color: white;
}
</style>
```

```vue
<template>
  <div class="hm-main">
    我是hm-main
  </div>
</template>

<script>
export default {

}
</script>

<style>
.hm-main {
  height: 400px;
  line-height: 400px;
  text-align: center;
  font-size: 30px;
  background-color: #f79646;
  color: white;
  margin: 20px 0;
}
</style>
```

```vue
<template>
  <div class="App">
    <!-- 头部组件 -->
    <HmHeader></HmHeader>
    <!-- 主体组件 -->
    <HmMain></HmMain>
    <!-- 底部组件 -->
    <HmFooter></HmFooter>

    <!-- 如果 HmFooter + tab 出不来 → 需要配置 vscode
         设置中搜索 trigger on tab → 勾上
    -->
  </div>
</template>

<script>
import HmHeader from './components/HmHeader.vue'
import HmMain from './components/HmMain.vue'
import HmFooter from './components/HmFooter.vue'
export default {
  components: {
    // '组件名': 组件对象
    HmHeader: HmHeader,
    HmMain,
    HmFooter
  }
}
</script>

<style>
.App {
  width: 600px;
  height: 700px;
  background-color: #87ceeb;
  margin: 0 auto;
  padding: 20px;
}
</style>
```

```js
// 文件核心作用：导入App.vue，基于App.vue创建结构渲染index.html
// 1. 导入 Vue 核心包
import Vue from 'vue'

// 2. 导入 App.vue 根组件
import App from './App.vue'

// 提示：当前处于什么环境 (生产环境 / 开发环境)
Vue.config.productionTip = false

// 3. Vue实例化，提供render方法 → 基于App.vue创建结构渲染index.html
new Vue({
  // el: '#app', 作用：和$mount('选择器')作用一致，用于指定Vue所管理容器
  // render: h => h(App),
  render: (createElement) => {
    // 基于App创建元素结构
    return createElement(App)
  }
}).$mount('#app')

```

**当三个Vue组件都定义好了，接下来要到App.vue中进行注册：注意：Components和标签都要注册**

我们注意三个点即可：以HmHeader为例子

- <HmHeader></HmHeader>

- import HmHeader from './components/HmHeader.vue'

-  components:{
          HmHeader:HmHeader,

  ​		}

```vue
<template>
<div class="App">
    <HmHeader></HmHeader>
    <HmMain></HmMain>
    <HmFooter></HmFooter>
    </div>
</template>
<script>
import HmHeader from './components/HmHeader.vue'
import HmMain from './components/HmMain.vue'
import HmFooter from './components/HmFooter.vue'
export default{
    components:{
        HmHeader:HmHeader,
        HmMain,
        HmFooter
    }
}
</script>
<style>
.App {
  width: 600px;
  height: 700px;
  background-color: #87ceeb;
  margin: 0 auto;
  padding: 20px;
}
</style>
```

2.全局注册：所有组件内都能使用

#### B.使用：

- 当成html标签使用`<组件名></组件名>`
- 大驼峰命名法

现在于局部注册基础上添加一个按钮HmFooter.vue，对于它我们采取全局注册的方式

```vue
<template>
  <button class="hm-button">通用按钮</button>
</template>

<script>
export default {

}
</script>

<style>
.hm-button {
  height: 50px;
  line-height: 50px;
  padding: 0 20px;
  background-color: #3bae56;
  border-radius: 5px;
  color: white;
  border: none;
  vertical-align: middle;
  cursor: pointer;
}
</style>
```

这一次我们不考虑App.vue，而是把目光投向main.js

```js
// 文件核心作用：导入App.vue，基于App.vue创建结构渲染index.html
import Vue from 'vue'
import App from './App.vue'
// 编写导入的代码，往代码的顶部编写(规范)
import HmButton from './components/HmButton'
Vue.config.productionTip = false

// 进行全局注册 → 在所有的组件范围内都能直接使用
// Vue.component(组件名，组件对象)
Vue.component('HmButton', HmButton)


// Vue实例化，提供render方法 → 基于App.vue创建结构渲染index.html
new Vue({
  // render: h => h(App),
  render: (createElement) => {
    // 基于App创建元素结构
    return createElement(App)
  }
}).$mount('#app')

```

# 六：组件三大组成部分（结构/样式/逻辑）/组件通信/综合案例分析/进阶语法

## 1.组件三大组成部分（结构/样式/逻辑）

- <template> 只能有一个根元素：也就是所有的标签都必须包含在一个<div></div>中
  
  </template>

- <style>组件：
      全局样式（默认）：影响所有组件
      局部样式:scoped下样式，只作用于当前组件
  
  
- <script>逻辑：其中注意： 
  
  </script>

  - el是根实例独有的，其他的都没有el，都不能绑定div

  - data是一个函数：

    - ```js
      <template>
        <div class="base-count">
          <button @click="count--">-</button>
          <span>{{ count }}</span>
          <button @click="count++">+</button>
        </div>
      </template>
      
      <script>
      export default {
        // data() {
        //   console.log('函数执行了')
        //   return {
        //     count: 100,
        //   }
        // },
        data: function () {
          return {
            count: 100,
          }
        },
      }
      </script>
      
      <style>
      .base-count {
        margin: 20px;
      }
      </style>
      ```

### A.组件的样式冲突Scoped

> 此处展示一种项目开发的问题：
>
> ```js
> //一定要确定你是Vue2还是Vue3，其中的main.js的导入方式不一样
> //下面以Vue3举例
> import{createApp} from 'vue'
> import App from './App.vue'
> const app = createApp(App);
> app.mount('#app')
> ```
>
> 

**默认情况**：写在组件中的样式会**全局生效** ->因此多个子组件之间样式容易冲突

1.全局样式：默认组件中的样式会作用到全局

2.局部样式：可以给组件加上scoped属性,可以让样式只作用于当前组件 例如<style scoped>

```vue
<script>
export default {

}
</script>

<template>
<div class="base-one">
  <span>BaseOne</span>
</div>
</template>

<style scoped>
div{
  border:3px solid blue;
  margin:30px
}
</style>
```

```vue
<script>
export default{

}
</script>

<template>
  <div class="base-one">
    BaseTwo
  </div>
</template>

<style scoped>
div{
  border: 3px solid red;
  margin:30px;
}
</style>
```



> scoped原理：
>
> 1.当前组件内标签都被添加**data-v-hash**值的属性
>
> 2.css选择器都被添加**data-v-hash值**的属性选择器
>
> ```html
> <template>
>     <div data-v-che7c9bc>
>         <p data-v-che7c9bc>
>             我是hm-header
>             
>         </p>
>     </div>
> </template>
> <style>
>     div[data-v-che7c9bc]{
>         border:1px solid #000,
>         margin:10px,0;
>     }
> </style>
> <script>
>     export default{
>         data(){
>             return{
>                 msg:'1111';
>             }
>         }
>     }
> </script>
> ```



> 一个组件的data选项为什么必须是一个函数？
>
> 答：保证每个组件实例，维护独立的一份数据对象
>
> 每次创建新的属性实例，都会重新执行一次data函数，得到一个新对象
>
> ```js
> data(){
>     return {
>         count: 100
> }
> ```
>
> 

## 2.组件通信

### A.什么是组件通信

- 组件通信，就是指**组件与组件**之间的**数据传递**
- 组件的数据是**独立的**，无法直接访问其他组件的数据
- 想用其他组件的数据->组件通信

### B.不同的组件关系和组件通信方案分类

1. 父子关系
2. 非父子关系

解决方案：

- 父子关系：props和$emit
- 非父子关系用provide&inject&eventbus
- 通用解决方案：Vuex(适合复杂业务场景)

#### B.1父子通信流程

1. 父组件通过**props**将数据传递给子组件
2. 子组件通过**$emit**通知父组件修改更新

#### B.2父子通信方案的核心流程

**2.1：父传子props**

- 父中给子添加属性传值
- 子props接收
- 子组件使用

```vue
<script>
import Son from "@/components/Son.vue";
export default {
  name:'App',
  data(){
    return{
      myTitle:'测试title',
      gg:'公告'
    }
  },
  components:{
    Son,
  }
}
</script>

<template>
<div class="app" style="border: 3px solid #000;margin: 10px">
  我是App组件
  <Son v-bind:title="myTitle" v-bind:gg="gg"></Son>

</div>
</template>

<style>

</style>
```

```vue
<script>
export default{
  name:'Son-Child',//组件的名称
  props:['title','gg']
}
</script>

<template>
<div class="son">
  我是son组件 {{title}}
  公告：{{gg}}
</div>
</template>

<style scoped>

</style>
```

**2.2子传父$emit:**

- 子$emit发送信息
- 父中给子添加消息监听
- 父中实现处理函数

```vue
<script>
export default{
  name:'Son-child',
  props:['title'],
  methods:{
    changeFn(){
      this.$emit('changeTitle','修改后的title')
    }
  }
}
</script>

<template>
<div class="son">
  我是son组件 {{title}}
  <button @click="changeFn">修改title</button>
</div>
</template>

<style scoped>

</style>
```



```vue
<script>
import Son from "@/components/Son.vue";
export default {
  name:'App',
  data(){
    return{
      myTitle:'测试title',
      gg:'公告'
    }
  },
  components:{
    Son,
  },
  methods:{
    handleChange(newTitle){
      this.myTitle=newTitle;
    }
  }
}
</script>

<template>
<div class="app" style="border: 3px solid #000;margin: 10px">
  我是App组件
  <Son v-bind:title="myTitle" @changeTitle="handleChange"></Son>

</div>
</template>

<style>

</style>
```



### C.什么是prop

**定义：** **组件上**注册的一些自定义属性

**作用：**向子组件传递数据

**特点：**

- 可以传递任意数量的prop
- 可以传递任意类型的prop

```vue
props:{
    xxx:boolean
}//xxx是名称 boolean是类型 xxx在父组件中template调用子组件时在属性里v-bind:xxx="xxxa"

export default{
	data(){
	return{
	xxx:000
}
}
}
```



```vue
<script>
export default {
  props:['username','age','isSingle','car','hobby']
}
</script>

<template>
<div class="userInfo">
  <h3>我是个人信息组件</h3>
  <div>姓名:{{username}}</div>
  <div>年龄：{{age}}</div>
  <div>是否单身:{{isSingle}}</div>
  <div>座驾:{{car.brand}}</div>
  <div>兴趣爱好：{{hobby}}</div>
</div>
</template>

<style>
.userInfo{
  width: 300px;
  border: 3px solid #000;
  padding: 20px;
}
.userInfo > div{
  margin: 20px 10px;
}
</style>
```

```vue
<script>
import UserInfo from "@/components/UserInfo.vue";
export default{
  data(){
    return{
      username:'小帅',
      age:28,
      isSingle:true,
      car:{
        brand:'小米',
      },
      hobby:'唱，跳，rap,篮球'
    }
  },
  components:{
    UserInfo
  }
}
</script>

<template>
<div class="app">
  <UserInfo
  :username="username"
  :age="age"
  :is-single="isSingle"
  :car="car"
  :hobby="hobby"
  ></UserInfo>
</div>
</template>

<style>

</style>
```



### D.prop校验

**思考：**组件的prop可以乱传么

**作用：**为组件的prop指定验证要求，不符合要求，控制台就会有错误提示->类似于Java中的自定义异常，帮助开发者快速找到问题

**语法：**

- 类型校验
- 非空校验
- 默认值
- 自定义校验

```vue
<script>
import UserInfo from "@/components/UserInfo.vue";
export default {
  data(){
    return{
      width:10,
    }
  },
  components:{
    UserInfo,
  }
}
</script>

<template>
  <div class="app">
    <UserInfo :w="width"></UserInfo>
  </div>
</template>

<style>

</style>
```

```vue
<template>
  <div class="base-progress">
    <div class="inner" :style="{ width: w + '%' }">
      <span>{{ w }}%</span>
    </div>
  </div>
</template>

<script>
export default {
  // 1.基础写法（类型校验）
  // props: {
  //   w: Number,
  // },

  // 2.完整写法（类型、默认值、非空、自定义校验）
  props: {
    w: {
      type: Number,
      required: true,
      default: 0,
      validator(val) {
        // console.log(val)
        if (val >= 100 || val <= 0) {
          console.error('传入的范围必须是0-100之间')
          return false
        } else {
          return true
        }
      },
    },
  },
}
</script>

<style scoped>
.base-progress {
  height: 26px;
  width: 400px;
  border-radius: 15px;
  background-color: #272425;
  border: 3px solid #272425;
  box-sizing: border-box;
  margin-bottom: 30px;
}
.inner {
  position: relative;
  background: #379bff;
  border-radius: 15px;
  height: 25px;
  box-sizing: border-box;
  left: -3px;
  top: -2px;
}
.inner span {
  position: absolute;
  right: 0;
  top: 26px;
}
</style>
```



### E.prop&data、单向数据流

**共性：**都可以给组件提供数据

**区别：**

- data的数据是自己的->随便改
- prop的数据是外部的->不能直接改，要遵循单向数据流

**单向数据流是什么：**

父级prop的数据更新，会向下流动，影响子组件，这个数据流动是单向的。

```js
<template>
  <div class="base-count">
    <button @click="handleSub">-</button>
    <span>{{ count }}</span>
    <button @click="handleAdd">+</button>
  </div>
</template>

<script>
export default {
  // 1.自己的数据随便修改  （谁的数据 谁负责）
  // data () {
  //   return {
  //     count: 100,
  //   }
  // },
  // 2.外部传过来的数据 不能随便修改
  props: {
    count: {
      type: Number,
    },
  },
  methods: {
    handleSub() {
      this.$emit('changeCount', this.count - 1)
    },
    handleAdd() {
      this.$emit('changeCount', this.count + 1)
    },
  },
}
</script>

<style>
.base-count {
  margin: 20px;
}
</style>
```

```js
<template>
  <div class="app">
    <BaseCount :count="count" @changeCount="handleChange"></BaseCount>
  </div>
</template>

<script>
import BaseCount from './components/BaseCount.vue'
export default {
  components:{
    BaseCount
  },
  data(){
    return {
      count:100
    }
  },
  methods: {
    handleChange(newVal) {
      // console.log(newVal);
      this.count = newVal
    }
  }
}
</script>

<style>

</style>
```



### F.非父子通信- event bus事件总线

```
<template>
  <div class="base-a">
    我是A组件（接受方）
    <p>{{msg}}</p>  
  </div>
</template>

<script>
import Bus from '../utils/EventBus'
export default {
  data() {
    return {
      msg: '',
    }
  },
  created() {
    Bus.$on('sendMsg', (msg) => {
      // console.log(msg)
      this.msg = msg
    })
  },
}
</script>

<style scoped>
.base-a {
  width: 200px;
  height: 200px;
  border: 3px solid #000;
  border-radius: 3px;
  margin: 10px;
}
</style>
```

```html
<template>
  <div class="base-b">
    <div>我是B组件（发布方）</div>
    <button @click="sendMsgFn">发送消息</button>
  </div>
</template>

<script>
import Bus from '../utils/EventBus'
export default {
  methods: {
    sendMsgFn() {
      Bus.$emit('sendMsg', '今天天气不错，适合旅游')
    },
  },
}
</script>

<style scoped>
.base-b {
  width: 200px;
  height: 200px;
  border: 3px solid #000;
  border-radius: 3px;
  margin: 10px;
}
</style>
```

```html
<template>
  <div class="base-c">
    我是C组件（接受方）
    <p>{{msg}}</p>  
  </div>
</template>

<script>
import Bus from '../utils/EventBus'
export default {
  data() {
    return {
      msg: '',
    }
  },
  created() {
    Bus.$on('sendMsg', (msg) => {
      // console.log(msg)
      this.msg = msg
    })
  },
}
</script>

<style scoped>
.base-c {
  width: 200px;
  height: 200px;
  border: 3px solid #000;
  border-radius: 3px;
  margin: 10px;
}
</style>
```

```js
import Vue from 'vue'

const Bus  =  new Vue()

export default Bus
```

### G.provide&inject作用：**跨层级**共享数据



1.父组件：provide提供数据

```js
<template>
  <div class="app">
    我是APP组件
    <button @click="change">修改数据</button>
    <SonA></SonA>
    <SonB></SonB>
  </div>
</template>

<script>
import SonA from './components/SonA.vue'
import SonB from './components/SonB.vue'
export default {
  provide() {
    return {
      // 简单类型 是非响应式的
      color: this.color,
      // 复杂类型 是响应式的
      userInfo: this.userInfo,
    }
  },
  data() {
    return {
      color: 'pink',
      userInfo: {
        name: 'zs',
        age: 18,
      },
    }
  },
  methods: {
    change() {
      this.color = 'red'
      this.userInfo.name = 'ls'
    },
  },
  components: {
    SonA,
    SonB,
  },
}
</script>

<style>
.app {
  border: 3px solid #000;
  border-radius: 6px;
  margin: 10px;
}
</style>
```

2.子孙类型取用

```js
<template>
  <div class="SonA">我是SonA组件
    <GrandSon></GrandSon>
  </div>
</template>

<script>
import GrandSon from '../components/GrandSon.vue'
export default {
  components:{
    GrandSon
  }
}
</script>

<style>
.SonA {
  border: 3px solid #000;
  border-radius: 6px;
  margin: 10px;
  height: 200px;
}
</style>
```

```js
<template>
  <div class="SonB">
    我是SonB组件
  </div>
</template>

<script>
export default {

}
</script>

<style>
.SonB {
  border: 3px solid #000;
  border-radius: 6px;
  margin: 10px;
  height: 200px;
}
</style>
```

```js
<template>
  <div class="grandSon">
    我是GrandSon
    {{ color }} -{{ userInfo.name }} -{{ userInfo.age }}
  </div>
</template>

<script>
export default {
  inject: ['color', 'userInfo'],
}
</script>

<style>
.grandSon {
  border: 3px solid #000;
  border-radius: 6px;
  margin: 10px;
  height: 100px;
}
</style>
```



## 3.综合案例分析

## 4.进阶语法

### A.v-model原理

**原理：**v-model本质是一个**语法糖**。例如应用在**输入框**上，就是**value属性**和input属性的合写

**作用：**提供数据的双向绑定

1. 数据变，视图跟着变 v-bind:value
2. 视图变，数据跟着变：v-on:input
3. 注意：**$event**用于在模板中， 获取事件的形参

换句话说。你在子组件的方法里面this.$emit('input',e.target.value)

这里的input就必须要在父组件中的template里面引用子组件时候用v-on绑定上

比如：v-on:input="selectId=$event" 然后v-bind一个value值为"selected"

但是这样写太麻烦了 我们简化上述的v-on和v-bind以及value与input为v-model="selectID"属性

```html
<template>
<div id="app">
    <input v-model=“msg" type=text><
    <input v-bind:value="msg" @input="msg = $event.target.value" type="text">
    </div>
</template>
```

### B.表单类组件封装&v-model简化代码

1.表单类组件封装->实现子组件和父组件数据的 **双向绑定**

- 父传子 数据从父组件通过props传递过来 拆解v-model绑定数据
- 子传父 监听输入，子组件传值给父组件修改
- ```js
  <template>
    <div>
      <select :value="value" @change="selectCity">
        <option value="101">北京</option>
        <option value="102">上海</option>
        <option value="103">武汉</option>
        <option value="104">广州</option>
        <option value="105">深圳</option>
      </select>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      value: String,
    },
    methods: {
      selectCity(e) {
        this.$emit('input', e.target.value)
      },
    },
  }
  </script>
  
  <style>
  </style>
  ```

  ```vue
  <template>
    <div class="app">
      <BaseSelect
        v-model="selectId"
      ></BaseSelect>
    </div>
  </template>
  
  <script>
  import BaseSelect from './components/BaseSelect.vue'
  export default {
    data() {
      return {
        selectId: '102',
      }
    },
    components: {
      BaseSelect,
    },
  }
  </script>
  
  <style>
  </style>
  ```

  

### C.sync修饰符

**作用：**可以实现 子组件 与 父组件数据 的 双向绑定，简化代码 

**特点：**prop属性名，可以自定义，非固定为 value 

**场景：** **封装弹框类的基础组件**， visible属性 true显示 false隐藏 

**本质：**就是 :属性名 和 @update:属性名 合写

**痛点:**我们之前提到了 v-bind:value v-on:input这种例子。但是有时候我们希望v-bind的元素不被限定为value，比如我做一个弹窗，我希望可读性高一点。于是我希望用visible来替代value这个传值，对弹窗类进行封装

```js
<BaseDialog:visible.sync="isShow"/>
    //等价于
<BaseDialog :visible="isShow"
@update:visible="isShow=$event"/>
```

那如何接受呢？

```js
props:{
    visible:Boolean
},
this.$emit('update:visible',false);
```



```js
<template>
  <div class="base-dialog-wrap" v-show="isShow">
    <div class="base-dialog">
      <div class="title">
        <h3>温馨提示：</h3>
        <button class="close" @click="closeDialog">x</button>
      </div>
      <div class="content">
        <p>你确认要退出本系统么？</p>
      </div>
      <div class="footer">
        <button>确认</button>
        <button>取消</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isShow: Boolean,
  },
  methods:{
    closeDialog(){
      this.$emit('update:isShow',false)
    }
  }
}
</script>

<style scoped>
.base-dialog-wrap {
  width: 300px;
  height: 200px;
  box-shadow: 2px 2px 2px 2px #ccc;
  position: fixed;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  padding: 0 10px;
}
.base-dialog .title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 2px solid #000;
}
.base-dialog .content {
  margin-top: 38px;
}
.base-dialog .title .close {
  width: 20px;
  height: 20px;
  cursor: pointer;
  line-height: 10px;
}
.footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 26px;
}
.footer button {
  width: 80px;
  height: 40px;
}
.footer button:nth-child(1) {
  margin-right: 10px;
  cursor: pointer;
}
</style>
```

```js
<template>
  <div class="app">
    <button @click="openDialog">退出按钮</button>
    <!-- isShow.sync  => :isShow="isShow" @update:isShow="isShow=$event" -->
    <BaseDialog :isShow.sync="isShow"></BaseDialog>
  </div>
</template>

<script>
import BaseDialog from './components/BaseDialog.vue'
export default {
  data() {
    return {
      isShow: false,
    }
  },
  methods: {
    openDialog() {
      this.isShow = true
      // console.log(document.querySelectorAll('.box')); 
    },
  },
  components: {
    BaseDialog,
  },
}
</script>

<style>
</style>
```



### D.ref和$refs

作用：利用ref和$refs可以用于获取**dom元素**或者**组件实例**

原本echarts中获取图表，容易误取同名表

```
const myChart = echarts.init(document.querySelector(.box))
//现在进行了优化
var myChart = echarts.init(this.$refs.baseChartBox)
```

现在我们简化流程+减少错误

1.获取Dom:找到目标标签-添加ref属性

```
<div ref="chartRef">我是渲染图表的容器</div>
```

2.恰当时机，通过this.$refs.xxx获取目标标签

```
mounted(){
 console.log(this.$refs.chartRef)
}
```



```js
<template>
  <div class="base-chart-box" ref="baseChartBox">子组件</div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  mounted() {
    // 基于准备好的dom，初始化echarts实例
    // document.querySelector 会查找项目中所有的元素
    // $refs只会在当前组件查找盒子
    // var myChart = echarts.init(document.querySelector('.base-chart-box'))
    var myChart = echarts.init(this.$refs.baseChartBox)
    // 绘制图表
    myChart.setOption({
      title: {
        text: 'ECharts 入门示例',
      },
      tooltip: {},
      xAxis: {
        data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子'],
      },
      yAxis: {},
      series: [
        {
          name: '销量',
          type: 'bar',
          data: [5, 20, 36, 10, 10, 20],
        },
      ],
    })
  },
}
</script>

<style scoped>
.base-chart-box {
  width: 400px;
  height: 300px;
  border: 3px solid #000;
  border-radius: 6px;
}
</style>
```

```js
<template>
  <div class="app">
    <div class="base-chart-box">
      这是一个捣乱的盒子
    </div>
    <BaseChart></BaseChart>
  </div>
</template>

<script>
import BaseChart from './components/BaseChart.vue'
export default {
  components:{
    BaseChart
  }
}
</script>

<style>
.base-chart-box {
  width: 300px;
  height: 200px;
}
</style>
```



### E.Vue异步更新、$nextTick

> 在Vue.js开发过程中，我们经常需要关注数据的变化，以便进行相应的视图更新。然而，JavaScript的执行是单线程的，如果在数据更新时直接操作DOM，会导致页面渲染不及时，出现闪烁等问题。为了解决这个问题，Vue.js提供了一个名为nextTick的机制，它能够确保在下一个“tick”中执行延迟回调，从而实现异步更新DOM。



> nextTick是Vue.js中的一个内部方法，用于在下一个“tick”执行延迟回调。在Vue.js中，一个“tick”指的是JavaScript事件循环的一个完整周期。当调用nextTick时，Vue.js会将回调函数添加到队列中，等到当前操作完成（包括DOM更新）后，再执行回调函数。
>

#### 为什么要有nexttick

举个例子

```js
{{num}}
for(let i=0; i<100000; i++){
    num = i
}
```

如果没有 `nextTick` 更新机制，那么 `num` 每次更新值都会触发视图更新(上面这段代码也就是会更新10万次视图)，有了`nextTick`机制，只需要更新一次，所以`nextTick`本质是一种优化策略

## 

需求：编辑标题：**编辑框自动聚焦**

希望Dom在更新完成后做某事，可以用$nextTick

```javascript
new Vue({
    el:'#app',
    data:{
        message:'HelloWorld'
    },
    methods:{
        updateMessage(){
            this.message="HelloWorld";
            this.$nextTick(function(){
                console.log('Dom updated')
            })
        }
    }
})
```

在这个示例中，当我们调用updateMessage方法时，会首先更新数据，然后调用$nextTick方法。在下一个“tick”中，会执行回调函数，此时DOM已经更新完毕，我们可以执行相应的操作。 
