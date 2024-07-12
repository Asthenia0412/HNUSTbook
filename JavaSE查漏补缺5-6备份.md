# 一.Java基础-泛型详解

## 1.为什么会引入泛型

泛型的本质是为了参数化类型（在**不创建新的**类型的情况下，通过泛型指定的不同类型来**控制**形参**具体限制的类型**）。在泛型的使用过程中，操作的数据类型被指定为一个参数，这种参数类型可以用在类，接口，方法中。被称为**泛型类**，**泛型接口**，**泛型方法**

### 适用于多种数据类型执行相同的代码（代码复用）

```java
private static int add(int a,int b){
    System.out.println(a+"+"+b+"="(a+b));
    return a+b;
}
private static float add(float a,float b){
    System.out.println(a+"+"+b+"="(a+b));
    return a+b;
}
private static double add(double a,double b){
    System.out.println(a+"+"+b+"="(a+b));
    return a+b;
}
```

如果没有泛型，要实现不同类型的加法，每种类型都需要重载一个add方法，通过泛型，我们可以复用为一个方法。

其中：

1. <T extends Number>double 泛型类型T必须是Number类或者其子类。extends表示类型边界，确保传入的类型，具有Number的方法和属性
2. a.doubleValue();和b.doubleValue()是Number类的方法,用于将Number对象转化为double类型的值。因为T被限定为Number的子类型，因此可以保证a和b对象有doubleValue();的方法

```java
private static <T extends Number>double add(T a,T b){
    System.out.println(a+"+"+b+"="+(a.doubleValue()+b.doubleValue()));
    return a.doubleValue()+b.doubleValue();
}
```

### 泛型中的类型在使用时指定，不需要强制类型转化（因此类型安全）

```java
List list = new ArrayList();
list.add("xxxString");
list.add(100d);
list.add(new Person());
```

使用上述集合，list中的元素都是Object类型（无法约束其中的类型），所以在取出集合元素时，需要人为强制转化为具体的目标类型，容易出现 **java.lang.ClassCastException异常**

引入泛型，它将提供类型的约束，提供编译前的检查

```
List<String> list = new ArrayList<String>();
```



## 2.泛型的基本使用

### A.泛型类

简单泛型类

```java
class Point<T>{
private T var;
    public T getVar(){
        return var;
    }
    public void setVar(T var){
        this.var = var;
    }
}
public class GenericsDemo06{
    public static void main(String[] args){
        Point<String> p = new Point<String>();
        p.setVar("it");
        System.out.println(p.getVar().length());
    }
    
}
```

多元泛型类

```java
class Notepad<K,V>{
    private K key;
    private V value;
    public K getKey(){
        return this.key;
    }
    public V getValue(){
        return this.value;
    }
    public void setKey(K key){
        this.key = key;
    }
    public void setValue(V value){
        this.value = value;
    }
}
public class GenericsDemo09{
    public static void main(String[] args){
        Notepad<String,Integer> t = null;
        t = new Notepad<String,Integer>();
        t.setKey("tom");
        t.setValue(20);
        System.out.println(t.getKey());
        System.out.println(t.getValue());
    }
}
```

### B.泛型接口

```java
interface Info<T>{
    public T getVar();//定义抽象方法，抽象方法返回值就是泛型类型
}
class InfoImpl<T> implements Info<T>{
    private T var;
    public InfoImpl(T var){
        this.setVar(var);
    }
    public void setVar(T var){
        this.var = var;
    }
    public T getVar(){
        return this.var;
}
public class GenericsDemo24{
    public static void main(String[] args){
        Info<String> i = null;
        i = new InfoImpl<String>("Tom");
        System.out.println(i.getVar());
    }
}
```



### C.泛型方法

- 定义泛型方法的语法格式

```java
public <T>T getObject(Class<T> c) throws InstanceException,IllegalAccessException{
    T t = t.newInstance();
    return t;
} 
```

- 调用泛型方法语法格式

```java
Generic generic = new Generic();
Object obj = generic.getObject(Class.ForName("com.cnblogs.test.User"));

```

1. 定义泛型方法，必须在返回值前加一个<T>，来声明这是一个泛型方法，持有一个泛型T,然后才可以用泛型T作为方法返回值
2. Class<T>的作用是指明泛型的具体类型，而Class<T>类型的变量c，可以用来创建泛型类的对象。
3. 为什么需要c来创建对象：泛型方法：意味着不清楚具体类型是什么。也不知道构造方法如何。因此没有办法去new一个对象，但可以利用变量c的newinstance方法取常见对象。也就是用**反射创建对象**
4. 为什么要用泛型方法呢？因为泛型类要在实例化时候就指明类型，如果想换一种类型，就得重新new,不够灵活，泛型方法可以在调用时候指明类型，比较灵活

### D.泛型的上下限

在使用泛型的时候，我们可以为传入的泛型类型进行上下边界的限制。如:类型实参只准传入某种类型的父类或者某种类型的子类

- 上限

```java
class Info<T extends Number>{
    private T var;
    public void setVar(T var){
        this.var = var;
    }
    public T getVar(){
        return this.var;
    }
    public String toString(){
        return this.var.toString();
    }
}
public class demo1{
    public static void main(String[] args){
        Info<Integer> i1 = new Info<Integer>();
        
    }
}
```

- 下限:

```java
class info<T>{
    private T var;
    public void setVar(T var){
        this.var = var;
    }
    public T getVar(){
        return this.var;
    }
    public String toString(){
        return this.var.toString();
    }
}
public class GenericsDemo21{
    public static void main(String[] args){
        Info<String> i1= new Info<String>();
        Info<Object> i2= new Info<Object>();
        i1.setVar("Hello");
        i2.setVar(new Object());
        fun(i1);
        fun(i2);
        
    }
    public static void fun(Info<? super String> temp){
        System.out.println(temp);
    }
}
```

- 小结:

```
<?>无限制通配符
List<?> list = new ArrayList<Object>(); 无边界通配符
List<? extends Number> list = new ArrayList<Integer>(); 上界通配符
List<? super Integer> list = new ArrayList<Number>(); 下界通配符

<? extends E>extends关键字声明了类型的上界，表示参数化的类型可能是所指定的类型/次类的子类
<? super E>super关键词声明了类型的下界，或者是此类的父类
E 是一个类型参数，用于定义泛型类型时使用，它会在使用泛型类型时被具体的类型替换。
? 是一个通配符，用于指定泛型类型的未知部分，它不会在编译时被替换为具体的类型，而是在运行时代表任意类型。
```

- 再来一个例子加深印象

```java
private <E extends Comparable<? Super E>> E max(List<? extends E>e1){
    if(e1==null){
        return null;
    }
    Iterator<? extends E>iterator = e1.iterator();
    E result = iterator.next();
    while(iterator.hasNext()){
        E next = iterator.next();
        if(next.compareTo(result)>0){
            result = next;
        }
    }
    return result;
}
```

1. 类型参数的范围：<E extends Comparable<? super E>>分步骤来分析
2. E是类型参数 指示方法操作的元素类型
3. 要进行比较，所以 E 需要是可比较的类，因此需要 extends Comparable<…>（注意这里不要和继承的 extends 搞混了，不一样）
4. Comparable< ? super E> 要对 E 进行比较，即 E 的消费者，所以需要用 super
5. 而参数 List< ? extends E> 表示要操作的数据是 E 的子类的列表，指定上限，这样容器才够大

- 使用&符号

```java
public class Client{
    public static <T extends Staff & Passenger> void discount(T t){
        if(t.getSalary()<2500 && t.isStanding()){
            System.out.println("恭喜您，您的车票是八折");
        }
    }
    public static void main(String[] args){
        discount(new Me());
    }
}
```



### E.泛型数组

```java
List<String>[] list11 = new ArrayList<String>[10]; //编译错误，非法创建 
List<String>[] list12 = new ArrayList<?>[10]; //编译错误，需要强转类型 
List<String>[] list13 = (List<String>[]) new ArrayList<?>[10]; //OK，但是会有警告 
List<?>[] list14 = new ArrayList<String>[10]; //编译错误，非法创建 
List<?>[] list15 = new ArrayList<?>[10]; //OK 
List<String>[] list6 = new ArrayList[10]; //OK，但是会有警告

```



## 3.深入理解泛型

### A.如何理解Java中的泛型是伪泛型？泛型中类型擦除

> Java泛型的概念是从JDK1.5开始加入的
>
> 伪泛型是为了兼容之前的版本
>
> 伪泛型是：Java在语法上支持泛型，但是编译阶段会进行（Type Erasure），将所有泛型表示（尖括号中内容）替换为原生态类型-就好像完全没有泛型

- 擦除**类定义**中的类型参数 - 无限制类型擦除

当类定义中的类型参数没有任何限制时，在类型擦除中直接被替换为Object,例形如<T>和<?>的类型参数都被替换为Object

```java
//原本
public class Info<T>{
    private T value;
    private T getValue(){
        return value;
    }
}
//擦除后
public class Info{
    private Object value;
    public Object getValue(){
        return value;
    }
}
```

- 擦除**类定义**中的类型参数 - 有限制类型擦除

当类定义中的类型参数有上下界时，在类型擦除中替换为类型参数的上界或者下界，比如<T extends Number>和<? extends Number>的参数类型都替换为Number,<? super Number>被替换为Object

```java
//原本
public Info<T extends Number>{
    private T value;
    public T getValue(){
        return value;
    }
}
//擦除后
public Info{
    private Number value;
    public Number getValue(){
        return value;
    }
}

```

- 擦除**方法定义**中的类型参数

擦除方法定义中的类型参数原则和擦除类定义中的类型参数是一样的，这里仅擦除方法定义中的有限制类型参数为例

```java
//原本的
public <T extends Number>T foo(T value){
    return value;
}
//擦除后
public Number Foo(Number value){
    return value;
}
```

### B.如何证明类型的擦除呢？

#### 原始类型相等

```java
public class Test{
    public static void main(String[] args){
        ArrayList<String> list1 = new ArrayList<String>();
        list1.add("abc");
        ArrayList<Integer> list2 = new ArrayList<Integer>();
        list2.add(123);
        System.out.println(list1.getClass()==list2.getClass());
    }
}
```

我们定义了两个ArrayList数组，但是一个是ArrayList<String>泛型类型，只能储存字符串。一个是ArrayList<Integer>类型，只能储存整数。最后我们通过list1对象和list2对象的getClass()方法，来获取其类的信息。最后发现结果都是true.原因在于经过类型擦除后，String和Integer都被擦除掉了，只剩下了原始类型Object;

#### 通过反射添加其他元素

```java
public class Test{
    public static void main(String[] args){
        ArrayList<Integer> list = new ArrayList<Integer>();
        list.add(1);
        list.getClass().getMethod("add",Object.class).invoke(list,"asd");
      for(int i=0;i<list.size();i++){
          System.out.println(list.get(i));
      }
    }
}
```

在程序中定义了一个ArrayList泛型类型实例化为Integer对象，如果直接调用add()方法，只能储存整型数据，不过当我们利用反射调用add()方法时候，却可以储存字符串，说明了Integer泛型实例在编译后就被擦除掉了。只保留了原始类型。



### C.如何理解类型擦除后保留的原始类型?

#### **原始类型**

就是擦除取了泛型信息，最后在字节码中的类型变量的真正类型，无论何时定义一个泛型，相应的原始类型都会被提供，类型变量擦除，并且用其限定类型替换（无限定类型，用Object来替换）

```java
//泛型情况
class Pair<T>{
    private T value;
    public T getValue(){
        return value;
    }
    public void setValue(T value){
        this.value = value;
    }
}
//原始类型：
class Pair{
    private Object value;
    public Object getValue(){
        return value;
    }
    public void setValue(Object value){
        this.value = value;
    }
}
```

因为Pair<T>,T是一个无限定的类型变量，所以用Object替换。其结果就是一个普通的类，如同泛型加入Java语言之前的已经实现的样子。在程序中可以包含不同的Pair，如Pair<String>,Pair<Integer>，但是擦除后他们就成了原始的Pair类型，原始类型都是Object.



#### 如果说，类型变量有限定，那么原始类型就要用第一个边界的类型变量来替换

```java
public class Pair<T extends Comparable>{
    private T value;
};
public class Pair{
    private Comparable value;
}
```



#### 在调用泛型方法时候，可以指定泛型，也可以不指定泛型

```java
public class Test{
    public static void main(String[] args){
        /*不指定泛型的时候*/
        int i = Test.add(1,2);//两个参数都是Integer，因此T为Integer
        Number f = Test.add(1,1.2);//一个参数是Integer,一个是Float，取同一父类的最小级。Number
        Number o = Test.add(1,"asd");//一个参数是Integer,一个是String。取同一父类的最小级，为Object
        /*指定泛型的时候*/
        int a = Test.<Integer>add(1,2);//指定了Integer,因此只能为Integer类
        int b = Test.<Integer>add(1,2.2);//编译错误，指定了Integer,不能为Float
        Number c = Test.<Number>add(1,2.2);//指定为Number,可以为Integer和Float
        
    }
    //简单的泛型方法
}
```



### D.如何理解泛型的编译期检查？

> 既然说类型变量会在编译时擦除掉，那为什么我们往ArrayList创建的对象中添加整数会报错呢，不是说泛型变量String在编译的时候就会变成Object类型么，为什么不能存别的类型呢？既然类型擦除了，如何保证我们只能用泛型变量限定的类型呢？

#### 1.Java编译器是通过先检查代码中泛型的类型，然后再进行类型擦除，再进行编译

```java
public static void main(String[] args){
    ArrayList<String> list = new ArrayList<String>();
    list.add("123");
    list.add(123);//编译错误
}
```

在上面的程序中，使用add方法添加一个整型，在IDE中会直接报错，说明这就是在**编译之前的检查**。因为如果是在编译之后检查，类型擦除后，原始类型为Object,是应该允许任意引用类型添加的，可实际上不是这样，**这恰恰说明了关于泛型变量的使用，是会在编译之前检查的。**

#### 2.类型检查是针对谁的？

先用ArrayList来举例子,原先我们可能这样写

```java
ArrayList list = new ArrayList();

```

现在的写法：

```java
ArrayList<String> list = new ArrayList<String>();
```

如果是与以前的代码兼容，引用传值之间会出现如下的情况

```java
ArrayList<String> list1 = new ArrayList();//第一种情况
ArrayList list2 = new ArrayList<String>();//第二种情况
```

因为类型检查是在编译时完成的，new ArrayList()只是在内存中开辟了一个储存空间，可以储存任何类型的对象，**真正涉及类型检查的是它的引用**，因为我们是使用它来引用list1来调用它的方法，比如调用add方法。所以list1引用可以完成泛型类型的检查,而list2引用是不可以的。

什么是引用呢？下面的list1 list2 都是引用

```java
public class Test{
    public static void main(String[] args){
        ArrayList<String> list1 = new ArrayList();
        list1.add("1");//编译通过
        list2.add(1);//编译错误
        String str1 = list1.get(0);//返回类型就是String
        ArrayList list2 = new ArrayList<String>();
        list2.add("1");//编译通过
        list2.add(1);//编译通过
        Object object = list2.get(0);//返回类型是Object
        new ArrayList<String>().add("11");//编译通过
        new ArrayList<String>().add(22);//编译错误
        String str2 = new ArrayList<String>().get(0);//返回类型就是String
    }
}
```

通过上面的例子，就可以明白，类型检查是针对**引用**的，谁是一个引用，用这个引用调用泛型方法，就会对这个引用调用的方法进行类型检测。

#### 3.泛型中参数化类型为什么不考虑继承关系

在Java中，像下面形式的引用传递是不被允许的

```java
ArrayList<String> list1 = new ArrayList<Object>();//编译错误
ArrayList<Object> list2 = new ArrayList<String>();//编译错误
```

- 先看第一种情况，将第一种情况扩展

```java
ArrayList<Object> list1 = new ArrayList<Object>();
list1.add(new Object());
list1.add(new Object());
ArrayList<String> list2 = list1;//编译错误

```

第四行代码运行时候就会编译错误。我们假设其编译没错，那么当我们使用list2去调用get方法取值的时候，返回的都是String类型的对象，但是其实际已经被存放了Object类型的对象。为了避免出现ClassCastException，所以不允许这样的引用传递。（因此要有泛型）

### E.如何理解泛型的多态？泛型的桥接方法

> 类型的擦除会造成多态的重读，而JVM解决办法是 **桥接方法**

现在提供一个泛型类

```java
class Pair<T>{
    private T value;
    public T getValue(){
        return value;
    }
    public void setValue(T value){
        this.value = value;
    }
}
```

我们希望有一个子类继承它

```java
class DateInter extends Pair<Date>{
    @Override
    public void setValue(Date value){
        super.setValue(value);
    }
    @Override
    public Date getValue(){
        return super.getValue();
    }
}
```

但是实际上，类型擦除后，父类的泛型类型全部变成了原始的Object，所以父类编译后会变成如下样子

```java
class Pair{
    private Object value;
    public Object getValue(){
        return value;
    }
    public void setValue(Object value){
        this.value = value;
    }
}
```

**这明显和我们想象的不一样，是因为JVM进行了桥接**

我们可以用javap -c className方式来对DateInter进行反编译

```java
class com.tao.test.DateInter extends com.tao.test.Pair<java.util.Date> {  
  com.tao.test.DateInter();  
    Code:  
       0: aload_0  
       1: invokespecial #8                  // Method com/tao/test/Pair."<init>":()V  
       4: return  

  public void setValue(java.util.Date);  //我们重写的setValue方法  
    Code:  
       0: aload_0  
       1: aload_1  
       2: invokespecial #16                 // Method com/tao/test/Pair.setValue:(Ljava/lang/Object;)V  
       5: return  

  public java.util.Date getValue();    //我们重写的getValue方法  
    Code:  
       0: aload_0  
       1: invokespecial #23                 // Method com/tao/test/Pair.getValue:()Ljava/lang/Object;  
       4: checkcast     #26                 // class java/util/Date  
       7: areturn  

  public java.lang.Object getValue();     //编译时由编译器生成的桥方法  
    Code:  
       0: aload_0  
       1: invokevirtual #28                 // Method getValue:()Ljava/util/Date 去调用我们重写的getValue方法;  
       4: areturn  

  public void setValue(java.lang.Object);   //编译时由编译器生成的桥方法  
    Code:  
       0: aload_0  
       1: aload_1  
       2: checkcast     #26                 // class java/util/Date  
       5: invokevirtual #30                 // Method setValue:(Ljava/util/Date; 去调用我们重写的setValue方法)V  
       8: return  
}

```

可以发现，除去我们自己编写的两个方法外，实际上还存在两个新的方法，这些方法称为**桥方法**，是编译器提供给我们的。**桥方法的参数都是Object**.子类真正覆盖父类两个方法的是我们看不到的桥方法。**而@Override setvalue和getValue都只是假象**

### F.如何理解基本类型不能作为泛型类型？

> 比如，我们没有ArrayList<int>，只有ArrayList<Integer>

类型擦除后，ArrayList的原始类型变为Object，但是Object不能储存int值，只能引用Integer的值。
值得注意的是 list.add(1)是因为Java基础类型的自动装箱和拆箱操作

### G.如何理解泛型类型不能实例化？

> 泛型类型不能实例化是由于类型擦除

```java
T test = new T();
```

因为在Java编译期，没法确定泛型参数化类型，也就找不到对应的类字节码文件。

T被擦除为Object，如果可以new T()就变成了new Object();

**如何实例化一个泛型呢？可以考虑使用反射**

```java
static <T> T newTclass (Class < T > clazz) throws InstantiationException, IllegalAccessException {
    T obj = clazz.newInstance();
    return obj;
}
```



### H.泛型数组：能不能采用具体的泛型类型进行初始化？

先来学习Oracle官网给出的例子

```java
List<?>[] lsa = new List<?>[10]; // OK, array of unbounded wildcard type.
Object o = lsa;
Object[] oa = (Object[]) o;
List<Integer> li = new ArrayList<Integer>();
li.add(new Integer(3));
oa[1] = li; // Correct.
Integer i = (Integer) lsa[1].get(0); // OK
```



### I.泛型数组：如何正确的初始化泛型数组实例？

```java
public class ArrayWithTypeToken<T> {
    private T[] array;

    public ArrayWithTypeToken(Class<T> type, int size) {
        array = (T[]) Array.newInstance(type, size);
    }

    public void put(int index, T item) {
        array[index] = item;
    }

    public T get(int index) {
        return array[index];
    }

    public T[] create() {
        return array;
    }
}
//...

ArrayWithTypeToken<Integer> arrayToken = new ArrayWithTypeToken<Integer>(Integer.class, 100);
Integer[] array = arrayToken.create();
```



### J.如何理解泛型类中的静态方法和静态变量？

```java
public class Test2<T>{
    public static T one;
    public static T show(T one){
        return null;
    }
}
```

因为泛型类中的泛型参数的实例化是在定义对象的时候指定的，而静态变量和静态方法不需要使用对象来调用。对象都没有创建，如何确定这个泛型参数是何种类型，所以当然是错误的。

### K.如何理解异常中使用泛型？

- **不能抛出也不能捕获泛型类的对象**。事实上，泛型类扩展Throwable都不合法。例如：下面的定义将不会通过编译：

```java
public class Problem<T> extends Exception {

}
```



- **不能再catch子句中使用泛型变量**

  ```java
  try{
  
  } catch(Problem<Object> e1) {
  
  } catch(Problem<Object> e2) {
  
  }
  ```

  

- 但是在异常声明中可以使用类型变量。下面方法是合法的。

```java
public static<T extends Throwable> void doWork(T t) throws T {
    try{
        ...
    } catch(Throwable realCause) {
        t.initCause(realCause);
        throw t; 
    }
}

```



### L.如何获取泛型的参数类型？

# 二.Java基础-注解详解

# 三.Java基础-异常详解

# 四.Java基础-反射详解

# 五.Java基础-SPI详细解

