# 1.ArrayList的简单介绍

- 可调整大小的数组实现了 List 接口。实现了所有可选的列表操作，并允许所有元素，包括 null。除了实现 List 接口外，此类还提供了用于操作内部存储列表的数组大小的方法。（此类大致相当于 Vector，只是它是非同步的。）

- size、isEmpty、get、set、iterator 和 listIterator 操作的运行时间为常量时间。add 操作的摊销时间复杂度为常量时间，也就是说，添加 n 个元素需要 O(n) 的时间。所有其他操作的时间复杂度大致为线性时间。与 LinkedList 实现相比，常数因子较低。

- 每个 ArrayList 实例都有一个容量。容量是用于存储列表中元素的数组的大小。它总是至少与列表大小相等。随着元素的添加，ArrayList 的容量会自动增长。增长策略的具体细节未作说明，唯一说明的是添加元素的摊销时间复杂度为常量时间。

- 应用程序可以在添加大量元素之前，通过 ensureCapacity 操作来增加 ArrayList 实例的容量。这可能会减少增量重新分配的次数。

- 请注意，此实现不是同步的。如果多个线程同时访问一个 ArrayList 实例，并且至少有一个线程对列表进行结构性修改，则必须在外部进行同步。（结构性修改是指任何添加或删除一个或多个元素的操作，或者显式调整后备数组的大小；仅仅设置元素的值并不算作结构性修改。）通常通过对某个自然封装列表的对象进行同步来实现。如果没有这样的对象，应使用 Collections.synchronizedList 方法将列表“包装”起来。最好在创建时进行，以防止意外的非同步访问列表：

- ```java
  List list = Collections.synchronizedList(new ArrayList(...));
  ```

- 该类的 iterator 和 listIterator 方法返回的迭代器是快速失败的：如果列表在迭代器创建后的任何时间以任何方式发生结构性修改（除了通过迭代器自身的 remove 或 add 方法），迭代器将抛出 ConcurrentModificationException。因此，在面对并发修改时，迭代器快速且干净地失败，而不是冒险在未来某个不确定的时间出现任意的、非确定性的行为。

- 请注意，迭代器的快速失败行为不能得到保证，因为在未同步的并发修改情况下，通常不可能做出任何严格的保证。快速失败的迭代器在尽力而为的基础上抛出 ConcurrentModificationException。因此，依赖此异常来保证程序正确性是错误的：迭代器的快速失败行为应仅用于检测错误。

# 2.ArrayList的元信息

```java
public class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable

```

