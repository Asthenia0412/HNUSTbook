## 一：Built-ins

## 1.Dom传送门：

```vue
<script setup>
const msg = "Hello World";
</script>

<template>
  <!-- 使用 teleport 将内容渲染到 body 的子元素中 -->
  <teleport to="body">
    <span>{{ msg }}</span>
  </teleport>
</template>

```

## 2.优化性能的指令

```vue
<template>
  <span v-once>使它从不更新: {{ count }}</span>
</template>

<script setup>
import { ref } from "vue"
const count = ref(0)
setInterval(() => {
  count.value++
}, 1000)
</script> 
```

# 二.CSS Features

## 1.动态CSS

```vue
<script setup>
import {ref} from 'vue'
const theme = ref('red');
const colors = ['blue','yellow','red','green'];
setInterval(()=>{
  theme.value = colors[Math.floor(Math.random()*4)];
},1000);
</script>
<template>
  <p>Hello</p>
</template>
<style scoped>
p{
color: v-bind(theme);
}
</style>
```

## 2.全局CSS

```vue
<template>
  <p>Hello Vue.js</p>
</template>

<style scoped>
p{
  font-size:20px;
  color: red;
  text-align: center;
  line-height: 50px;
}
:global(body){
  width: 100vw;
  height: 100vh;
  background-color: burlywood;
}
</style>
```

- `vw` 表示视窗宽度的百分比。例如，`width: 100vw;` 表示元素的宽度将会是整个视窗宽度的百分之百。
- `vh` 表示视窗高度的百分比。例如，`height: 100vh;` 表示元素的高度将会是整个视窗高度的百分之百。

`:global(body)` 是一个在 Vue.js 的单文件组件中使用的 CSS 选择器，它的作用是指定一个全局作用域的样式规则，可以直接影响到整个页面的 `<body>` 元素，而不受到组件作用域的限制。

在 Vue.js 的单文件组件中，通常会使用 `<style scoped>` 标签来限定样式的作用域，这意味着样式只会应用于当前组件内部的元素，不会影响到其他组件或全局样式。但是有时候我们可能需要修改全局样式，这时就可以使用 `:global` 来声明全局作用域的样式规则。

在你提供的代码中，`:global(body)` 用于指定对全局的 `<body>` 元素进行样式设置，例如设置了页面的宽度、高度和背景颜色。这样无论在哪个组件中，都能够直接影响到整个页面的 `<body>` 元素样式，而不受到组件作用域的限制。

总之，`:global` 是一个很有用的特性，它能够帮助我们在需要的时候直接操作全局样式，而不必受到组件作用域的限制。

# 三.Component

## 1.Dom传送门

```vue

<template>
  <div>
    <input v-model="message" />
    <p>{{ message }}</p>
  </div>
</template> 
<script setup>
import { ref } from 'vue';
const message = ref('Hello World');
</script>

```

## 2.prop验证

请验证`Button`组件的`Prop`类型 ，使它只接收: `primary | ghost | dashed | link | text | default` ，且默认值为`default`。

```vue
// 你的答案
<script setup lang="ts">
defineProps({
  type: {
  type: String,
  validator(value: string){
    return ['primary', 'ghost','dashed','link','text','default'].includes(value)
  },
  default: 'default'
  }
})
</script>

<template>
  <button>Button</button>
</template>
```

## 3.函数式组件

```vue
<script setup lang='ts'>

import { h, ref } from "vue"

/**
 * Implement a functional component :
 * 1. Render the list elements (ul/li) with the list data
 * 2. Change the list item text color to red when clicked.
*/
const ListComponent = (p, { emit }) => {
  return h(
    'ul',
    {},
    p.list.map((x, i) => {
      return h('li', {
        style: { color: (p['active-index'] == i) ? 'red' : null },
        onClick: () => { emit('toggle', i) }
      }, x.name)
    })
  )
}

const list = [{
  name: "John",
}, {
  name: "Doe",
}, {
  name: "Smith",
}]

const activeIndex = ref(0)

function toggle(index: number) {
  activeIndex.value = index
}

</script>

<template>
  <list-component :list="list" :active-index="activeIndex" @toggle="toggle" />
</template>

```

1. `import { h, ref } from "vue"`：这里使用了 Vue 3 提供的 `h` 函数来创建虚拟 DOM 节点，并且引入了 `ref` 函数用于创建响应式数据。
2. `ListComponent` 函数：这是一个接受参数 `p` 和上下文对象的函数，通过调用 `h` 函数来创建一个 `ul` 元素，然后根据 `list` 数组的内容动态生成 `li` 元素。当列表项被点击时，会触发 `emit('toggle', i)` 来发出 `toggle` 事件，从而实现改变列表项文本颜色的功能。
3. `list` 数组和 `activeIndex` 变量：定义了一个包含姓名的列表数组 `list`，以及一个响应式变量 `activeIndex`，它用来追踪当前被点击的列表项索引。
4. `toggle` 函数：当列表项被点击时，会调用 `toggle` 函数来更新 `activeIndex` 的值，从而实现改变列表项颜色的效果。

在模板中使用了自定义的 `list-component` 组件，并将 `list`、`activeIndex` 以及 `toggle` 事件作为参数传递给该组件。

总的来说，这段代码演示了如何使用 Vue 3 中的 Composition API 和 JSX 语法来创建一个功能性的列表组件，实现了根据点击状态改变列表项文本颜色的功能。希望这能帮助到您理解这段代码的含义。如果您有其他问题，也欢迎随时向我提问。



这段代码是一个函数式组件，使用了 Vue 3 的渲染函数 `h` 来创建虚拟 DOM 元素。让我们逐步分析代码的细节：

```js
const ListComponent = (p, { emit }) => {

```

这是一个接收两个参数的箭头函数组件。参数 `p` 是传入的属性对象，包含了组件的属性值。`{ emit }` 是解构赋值语法，用于从上下文对象中提取 `emit` 方法。

```js
return h(
  'ul',
  {},
  p.list.map((x, i) => {
    return h('li', {
      style: { color: (p['active-index'] == i) ? 'red' : null },
      onClick: () => { emit('toggle', i) }
    }, x.name)
  })
)
```

这里使用 `h` 函数来创建虚拟 DOM 元素。首先，创建了一个 `<ul>` 元素作为父容器，然后通过 `p.list.map` 对 `p.list` 数组进行遍历，生成多个 `<li>` 元素。

在 `<li>` 元素中，使用了动态绑定 `style` 属性来设置样式。当 `p['active-index']` 的值等于当前索引 `i` 时，将文本颜色设置为红色，否则设置为默认颜色。

具体来说，`p.list.map((x, i) => { ... })` 中的箭头函数用于处理数组中的每个元素。在这个箭头函数中，`x` 表示数组中的当前元素，而 `i` 则表示当前元素的索引。在这个例子中，`x` 表示列表项的内容，`i` 表示列表项的索引。

同时，给每个 `<li>` 元素绑定了 `onClick` 事件，当元素被点击时，调用 `emit` 方法触发名为 `'toggle'` 的事件，并传递当前索引 `i` 作为参数。

最后，整个组件返回了由 `<ul>` 和多个 `<li>` 元素组成的虚拟 DOM 树。

这段代码实现了一个简单的列表组件，根据传入的 `list` 数组生成对应的列表项，并根据 `active-index` 属性来设置活动项的样式。当列表项被点击时，会触发一个自定义的 `'toggle'` 事件，并传递点击项的索引作为参数。

## 4.渲染函数h

> 在这个挑战中，你需要使用`h`渲染函数来实现一个组件。
>
> 请注意: 你应该确保参数被正确传递、事件被正常触发和插槽内容正常渲染。让我们开始吧。

```js
import { defineComponent, h } from "vue"

export default defineComponent({
  name: 'MyButton',
  props: {
    disabled: Boolean
  },

  render() {
    const customClick = () => {
      this.$emit('custom-click')
    }
    return h(
      'button',
      {
        disabled: this.$props.disabled,
        onClick: customClick
      },
      this.$slots.default()
    )
  }
})
```

```vue
<script setup lang="ts">
import MyButton from "./MyButton"

const onClick = () => {
  console.log("onClick")
}

</script>

<template>
  <MyButton :disabled="false" @custom-click="onClick">
    my button
  </MyButton>
</template>

```

1. `import { defineComponent, h } from "vue"`：从 Vue 中导入 `defineComponent` 和 `h`，`defineComponent` 用于定义一个组件，`h` 用于创建虚拟节点。
2. `export default defineComponent({`：使用 `defineComponent` 定义一个组件，并通过 `export default` 将其导出。
3. `name: 'MyButton',`：指定组件的名称为 `'MyButton'`。
4. `props: { disabled: Boolean },`：定义组件的 prop，这里只有一个名为 `disabled` 的 prop，类型为布尔型。
5. `render() {`：使用 `render()` 方法来定义组件的渲染函数。
6. `const customClick = () => { this.$emit('custom-click') }`：定义了一个名为 `customClick` 的函数，在按钮被点击时触发 `custom-click` 事件。
7. `return h(`：开始返回一个虚拟节点。
8. `'button',`：指定这个虚拟节点是一个 `<button>` 元素。
9. `{ disabled: this.$props.disabled, onClick: customClick },`：设置 `<button>` 元素的属性，`disabled` 属性值为 `this.$props.disabled`，`onClick` 事件处理函数为 `customClick`。
10. `this.$slots.default()`：插槽内容，默认插槽的内容会显示在按钮内部。
11. `)`：结束创建虚拟节点。

整体来说，这段代码定义了一个名为 `MyButton` 的 Vue 组件，它接受一个名为 `disabled` 的 prop，根据传入的 `disabled` prop 值来决定按钮是否为禁用状态。当按钮被点击时，会触发 `custom-click` 事件。

## 5.树组件

> 在这个挑战中，你需要实现一个树组件，让我们开始吧。

```vue
<script setup lang="ts">
import { ref } from "vue"
import TreeComponent from "./TreeComponent.vue"
const treeData = ref([{
  key: '1',
  title: 'Parent 1',
  children: [{
    key: '1-1',
    title: 'child 1',
  }, {
    key: '1-2',
    title: 'child 2',
    children: [{
      key: '1-2-1',
      title: 'grandchild 1',
    }, {
      key: '1-2-2',
      title: 'grandchild 2',
    },]
  },]
}, {
  key: '2',
  title: 'Parent 2',
  children: [{
    key: '2-1',
    title: 'child 1',
    children: [{
      key: '2-1-1',
      title: 'grandchild 1',
    }, {
      key: '2-1-2',
      title: 'grandchild 2',
    },]
  }, {
    key: '2-2',
    title: 'child 2',
  },]
}])
</script>

<template>
  <TreeComponent :data="treeData" />
</template>

```



```vue
<script setup lang="ts">
import { h } from 'vue'
interface TreeData {
  key: string
  title: string
  children: TreeData[]
}
const props = defineProps<{data: TreeData[]}>()
  
const render = () => {
  function makeTree(data?: TreeData, depth: number) {
    if (!data) return
    const nodes = []

    for(let i = 0; i < data.length; i++) {
      const node = h('ul', [
        h('li', { key: data[i].key }, `${data[i].title} - depth (${depth})`), 
        makeTree(data[i].children, depth + 1) // recursion for depth traversion
      ])
      nodes.push(node)
    }

    return nodes  
  }
  
  return makeTree(props.data, 0)
}
  
</script>

<template>
  <render />
</template>

```

# 四.Composable Function

## 1.切换器

## 2.计数器

## 3.实现本地储存函数

## 4.鼠标坐标

# 五.Vue3简介

## 1.WebPack构建与Vite构建

```
传统的webpack打包：
			  ->module
		routes->module 
		      ->module
entry ->routes			->Bundle ->Server Ready
						
		routes
		
使用Vite打包：						  ->module		
				HTTP request	route->module				
Server ready	 ->		entry ->route
								route
```

> webpack是先获取不同routes的不同module，最后打包，然后启动项目
>
> Vite是先启动项目，等Http发起request时候，根据访问到的route加载module.这样运行速度更快

- Vite是新一代前端构建工具
  - 轻量快速的热重载（HMR），极速服务启动
  - 对TypeScript,JSX,CSS的开箱就用
  - 按照需求编译，不用等待整个应用编译完成

## 2.Vue3项目初始化细节

### A.项目的创建与初始化

```
npm create vue@lastest 创建项目
```

在发现env.d.ts报错/// <reference types="vite/client" /> 标红表示无法找到依赖后

```
npm i 开始安装依赖//上述问题是因为没有node_modules文件夹无法找到依赖
```



这是成功的表现

### B.Vite项目的入口-index文件

传统webpack的入口是main.js或者main.ts

但是我们的Vite项目，是用index.html作为入口的

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vite App</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>

```

我们通过

```
npm run dev启动项目
```

### C.main.ts文件解析

```ts
import './assets/main.css'

import { createApp } from 'vue'//createApp是花盘 App就是根
import App from './App.vue'

createApp(App).mount('#app')//createApp创建一个根组件,组件是App 创建花盆 把花放入花盆
//.mount是挂在，将App挂在到index的id=app的标签中 ->摆花盆的位置
```

### D.开放给main.ts的import组件需要export

```ts
<template>
<div class="app">
  <h1>你好啊</h1>

</div>
</template>
<script lang="ts">
export default{
  name:'App'//组件名:我们在main.ts中通过export部分来读取App.vue
}
</script>
<style>
.app{
  background-color: #ddd;
  box-shadow: 0 0 10px;
  border-radius: 10px;
  padding: 20px;
}
</style>
```

### E.Vite项目初始化总结

- Vite项目中，`index.html`是项目入口文件，在项目最外层
- 加载index.html,Vite解析<script type="module" src="xxx">指向的JavaScript
- Vue3中通过createApp函数创建一个应用实例

## 3.选项式API与组合式API

### A.OptionsAPI和CompositionAPI

- Options类型的API，数据，方法，计算属性：是分散在data,methods,computed中的：如果要修改一个需求，就得分别修改data,methods,computed,不利于维护和复用



- Vue3的组合式：
  - 对于一个功能：所有的数据，计算属性，都被包含在一个函数中了。我们用不同的函数来区别不同的功能。相较于Vue2选项式API的分散和不易管理性，Vue3的组合式API更方便大型项目对于细微功能的快速调整



### B.setup的概述

> 前言：Vue3支持多个根标签，也就是在App中，可以出现多个子组件的标签



```ts
<template>
    <div class="Person">
        <h2>姓名:{{ name }}</h2>
        <h2>年龄:{{ age }}</h2>
        <button @click="showTel">查看联系方式</button>
    </div>
</template>
<script lang="ts">
export default{
    //console.log(this);//这里报的是undefined 
    name:'Person',
    setup(props, ctx) {
        //数据:
        let name = "张三";//不是响应式的
        let age = 18;//不是响应式的
        let tel ='138888888';
        
        //函数
        function showTel(){
            //这里不能用this setup函数中不可以用this.
            alert(tel)
        }
        return {name,age,showTel}
    },
}

</script>

<style>
.Person{
    background-color: skyblue;
    box-shadow: 0 0 10px;
    border-radius: 10px;
    padding: 20px;
}
</style>
```

- setup本身是一个配置项->表达成setup(){}即可
- 如果你直接let xxx = 12;这样定义数据，数据将不是响应式的，不会自动更新（自动更新:我在函数中让xxx自增，但是在template中{{xxx}}不会发生变化）-（原先写在data中的）
- setup()中的变量与方法都需要在return中返回，不交出去上述的数据和方法都是无效的
- 在setup()中不可以使用this来调用定义的数据，setup()中没有this，Vue3中开始弱化this的概念了
- setup()执行的时期是:在beforeCreate()这个钩子函数之前

### C.setup的返回值

- setup的返回值不一定是对象

```ts
return function()=>{
    return "哈哈"
}
//这里 哈哈会覆盖template中的内容 这是小部分情况

return {name,age,showTel}//大部分的情况
```

### D.setup和OptionsAPI



- 我们发现：setup()和data()与methods()**可以同步存在**
- data()和methods可以通过`this.属性名`来调用在setup()中定义的变量：例如`this.name` 但是setup()中是不能使用`this.age`来调用属性的，这是因为setup()执行的时间较早。

### E.setup的语法糖

 

```js
1. npm i vite-plugin-vue-setup-extend -D 
//这个依赖用于实现 <script setup name="Person234">
2. import  VueSetupExtend from'vite-plugin-vue-setup-extend';
//这是在vite.config.ts中进行依赖的引入


//避免创建两个<script>
//使得一个额外的
<script>
export default{
	name:'Person234'
}
</script>
```

现在可以看到完整的例子：

```vue
<template>
    <div class="Person">
        <h2>姓名:{{ name }}</h2>
        <h2>年龄:{{ age }}</h2>
        <button @click="showTel">查看联系方式</button>
    </div>
</template>

<script lang="ts" setup name="Person234">


 //数据:
 let name = "张三";
        let age = 18;
        let tel ='138888888';
        
        //函数
        function showTel(){
            //这里不能用this setup函数中不可以用this.
            alert(tel)
        }
        
</script>

<style>
.Person{
    background-color: skyblue;
    box-shadow: 0 0 10px;
    border-radius: 10px;
    padding: 20px;
}
</style>
```

## 4.ref与reactive的响应式数据/对象

### A.ref创建基本类型的响应式数据



通过Vue工具可以发现：在Vue工具中，setup中一定是数据，而setup()中不一定是方法：说明在Vue中，数据的优先级是最高的。



1. 通过`import {ref} from 'vue'` 通过解构语法引入vue中的ref
2. `let age = ref(18)`让需要成为响应式数据的值放到ref中
3. 通过`age.value`也就是值.value的形式调用响应式结果

### B.reactive创建对象类型的响应式数据



1. 通过`import {reactive} from 'vue'`引入作用于对象的响应式符号
2. reactive修饰的对象不需要通过.value来获取值

> 补充：在<ul> <li>中 我们使用v-for(g in games) 来通过数组生成若干个li标签
>
> 再通过插值表达式{{g.name}}来表达具体的值

### C.ref创建对象类型的响应式数据



- 通过`import {ref} from 'vue'` 通过解构语法引入vue中的ref
- 切记即使调用数组中的对象，也要先.value再取[0]或者[x];

### D.ref与reactive的比较

- 宏观角度：

  - ref用于定义：基本数据类型，对象数据类型
  - reactive用于定义：对象数据类型

- 区别：

  - ref创建的变量必须用`.value`(使用volar插件自动添加.value)

    - ```js
       setup() {
                      // 创建一个响应式对象
                      const state = reactive({ count: 0 });
        
                      // 增加计数器
                      const increment = () => {
                          state.count++;
                      };
        
                      // 重置状态
                      const resetState = () => {
                          // 重新分配一个新对象
                          state = reactive({ count: 0 });
                      };//重置状态：resetState方法试图通过重新分配一个新对象给state来重置状态。
           //点击“Reset State”按钮时，期望能够重置state，但由于重新分配了一个新对象给state，导致新对象没有被代理，因此失去了响应性。此时，再点击“Increment”按钮将不会触发视图更新。
        
                      return {
                          state,
                          increment,
                          resetState
                      };
      ```

      

  - reactive重新分配一个对象，会失去响应式结果

- 使用原则

  - 需要一个**基本类型**响应式数据：必须用**ref**

  - 需要一个响应式**对象**，层级**不深**，**ref**,**reactive**均可以

    

  - 需要一个响应式**对象**，层级**很深**，推荐使用**reactive**:嵌套中不要重复使用reactive

### E.toRefs与toRef的比较



- 引入`import {toRefs} from 'vue'`
- 被toRefs修饰的应该是已经被reactive修饰的对象
- 被解构赋值的结果于toRefs中的内容建立了动态关联

## 5.computed与watch及watchEffect

### A.computed计算属性

### B.watch监视情况一

### C.watch监视情况二

### D.watch监视情况三

### E.watch监视情况四

### F.watch监视情况五

### G.watchEffect