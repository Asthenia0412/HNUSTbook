## 一：字节码相关

## 二：类加载与JVM内存结构

## 三：JVM内存模型

## 四：垃圾回收机制

### B.G1垃圾收集器

#### 0.G1的运行逻辑

> G1（Garbage-First）垃圾回收器的工作过程，可以用一个城市规划的比喻来形象地讲解：
> 1. 初始标记（Initial Marking）：这个过程就像城市规划师开始规划前的初步考察。他们需要先标记出城市中的各个重要地标（即根集合），为后续的详细规划做准备。在这个阶段，G1会暂停所有应用线程，快速标记出根集合直接可达的对象。
> 2. 并发标记（Concurrent Marking）：这个过程类似于城市规划师在实地考察中，记录下各个区域的详细信息，包括居民的居住情况、商业活动等。G1在这个过程中，与应用线程并发执行，标记出所有存活的对象。
> 3. 最终标记（Final Marking）：这相当于城市规划师在完成实地考察后，对收集到的信息进行整理和补充。G1在这个阶段会暂停所有应用线程，处理剩余的少量标记工作，确保所有存活对象都被正确标记。
> 4. 清理（Cleanup）：这个过程就像城市规划师根据收集到的信息，对城市进行合理的布局调整。G1会根据标记结果，回收不活跃的区域（即垃圾对象所在的内存区域），并对内存进行整理，以减少内存碎片。
> 5. 复制（Copying）：这个阶段可以看作是城市规划师将原有居民搬迁到新的居住区。G1会将存活的对象从旧区域复制到新的内存区域，同时回收旧区域的内存空间。
> 6. 回收（Evacuation）：这个过程类似于城市规划师对废弃的建筑进行拆除，为新项目腾出空间。G1在这个阶段会根据用户设定的暂停时间目标，选择部分内存区域进行回收，以减少对应用线程的影响。
> 通过这个比喻，我们可以更形象地理解G1垃圾回收器的运行过程，它就像一个高效的城市规划师，不断地调整和优化内存空间，以确保Java应用程序的稳定运行。

#### 1.分区的概念

> 在Java中，实现JVM中分区的概念（Region）可以模拟G1（Garbage-First）垃圾回收器中的区域划分。G1垃圾回收器将堆内存分为多个固定大小的区域，以便更有效地回收垃圾。以下是一个简化的Java实现，用于展示区域的概念：
> ```java
> import java.util.ArrayList;
> import java.util.List;
> // 模拟区域（Region）
> class Region {
>     private final int id;
>     private List<Object> objects = new ArrayList<>();
>     public Region(int id) {
>         this.id = id;
>     }
>     public int getId() {
>         return id;
>     }
>     public void addObject(Object obj) {
>         objects.add(obj);
>     }
>     public List<Object> getObjects() {
>         return objects;
>     }
>     // 省略其他区域相关的方法...
> }
> // 模拟JVM中的分区
> class JVMPartition {
>     private List<Region> regions = new ArrayList<>();
>     // 创建分区
>     public void createPartition(int numRegions) {
>         for (int i = 0; i < numRegions; i++) {
>             regions.add(new Region(i));
>         }
>     }
>     // 向特定区域添加对象
>     public void addObjectToRegion(int regionId, Object obj) {
>         regions.get(regionId).addObject(obj);
>     }
>     // 获取所有区域
>     public List<Region> getRegions() {
>         return regions;
>     }
>     // 省略其他分区相关的方法...
> }
> public class JVMPartitionExample {
>     public static void main(String[] args) {
>         // 创建JVM分区，包含5个区域
>         JVMPartition jvmPartition = new JVMPartition();
>         jvmPartition.createPartition(5);
>         // 向不同区域添加对象
>         jvmPartition.addObjectToRegion(0, new Object());
>         jvmPartition.addObjectToRegion(1, new Object());
>         jvmPartition.addObjectToRegion(2, new Object());
>         jvmPartition.addObjectToRegion(3, new Object());
>         jvmPartition.addObjectToRegion(4, new Object());
>         // 获取所有区域
>         List<Region> regions = jvmPartition.getRegions();
>         for (Region region : regions) {
>             System.out.println("Region " + region.getId() + " contains objects: " + region.getObjects());
>         }
>     }
> }
> ```
> 在这个例子中，我们定义了两个类：`Region` 和 `JVMPartition`。`Region` 类代表一个区域，它包含一组对象。`JVMPartition` 类模拟了JVM中的分区，它包含多个区域。
> 以下是模拟的基本步骤：
>
> 1. **创建分区**：在 `createPartition` 方法中，我们创建了指定数量的区域。
> 2. **添加对象到特定区域**：在 `addObjectToRegion` 方法中，我们向特定区域添加对象。
> 3. **获取所有区域**：在 `getRegions` 方法中，我们获取所有区域。
> 请注意，这个模拟是非常简化的，它没有考虑垃圾回收器的许多复杂性和细节，例如：
> - 区域的动态分配。
> - 垃圾回收策略。
> - 跨区域引用的处理。
> 在真实的JVM中，分区的概念涉及到复杂的算法和数据结构，以及JVM内部对线程和内存的精细控制。

#### 2.分代的模型

> 在Java中，模拟JVM的分代模型，特别是G1（Garbage-First）垃圾回收器的分代模型，可以涉及多个阶段，包括年轻代、老年代和永久代（在Java 8之前）或元空间（在Java 8及以后）。以下是一个简化的Java实现，用于展示分代模型的基本概念：
> ```java
> import java.util.ArrayList;
> import java.util.List;
> // 模拟对象
> class MyObject {
>     // 模拟对象的一些属性
>     MyObject ref; // 引用其他对象
>     public MyObject(MyObject ref) {
>         this.ref = ref;
>     }
> }
> // 模拟JVM分代模型
> class JVMGenerationalModel {
>     private List<MyObject> youngGenObjects = new ArrayList<>();
>     private List<MyObject> oldGenObjects = new ArrayList<>();
>     // 模拟对象晋升到老年代
>     public void promoteToOldGeneration(MyObject obj) {
>         youngGenObjects.remove(obj); // 从年轻代移除
>         oldGenObjects.add(obj); // 添加到老年代
>     }
>     // 模拟应用程序运行，创建对象
>     public void simulateApplicationRunning() {
>         Random random = new Random();
>         for (int i = 0; i < 10; i++) {
>             MyObject obj = new MyObject(null); // 创建新对象
>             youngGenObjects.add(obj); // 添加到年轻代
>             if (random.nextBoolean()) {
>                 promoteToOldGeneration(obj); // 随机晋升到老年代
>             }
>         }
>     }
>     // 获取年轻代和老年代的对象列表
>     public List<MyObject> getYoungGenObjects() {
>         return youngGenObjects;
>     }
>     public List<MyObject> getOldGenObjects() {
>         return oldGenObjects;
>     }
> }
> public class JVMGenerationalModelExample {
>     public static void main(String[] args) {
>         JVMGenerationalModel model = new JVMGenerationalModel();
>         // 模拟应用程序运行
>         model.simulateApplicationRunning();
>         // 获取年轻代和老年代的对象列表
>         List<MyObject> youngGenObjects = model.getYoungGenObjects();
>         List<MyObject> oldGenObjects = model.getOldGenObjects();
>         System.out.println("Young Generation contains objects: " + youngGenObjects);
>         System.out.println("Old Generation contains objects: " + oldGenObjects);
>     }
> }
> ```
> 在这个例子中，我们定义了两个类：`MyObject` 和 `JVMGenerationalModel`。`MyObject` 类代表堆中的对象，而 `JVMGenerationalModel` 类模拟了JVM的分代模型。
> 以下是模拟的基本步骤：
> 1. **模拟对象晋升到老年代**：在 `promoteToOldGeneration` 方法中，我们模拟了对象从年轻代晋升到老年代的过程。
> 2. **模拟应用程序运行**：在 `simulateApplicationRunning` 方法中，我们模拟了应用程序的运行，创建新对象并将它们添加到年轻代。随机地，一些对象会被晋升到老年代。
> 3. **获取年轻代和老年代的对象列表**：在 `main` 方法中，我们获取了年轻代和老年代的对象列表。
> 请注意，这个模拟是非常简化的，它没有考虑垃圾回收器的许多复杂性和细节，例如：
> - 对象的可达性分析。
> - 垃圾回收过程中的暂停时间。
> - 跨代引用的处理。
> - 垃圾回收的性能优化。
> 在真实的JVM中，分代模型涉及到复杂的算法和数据结构，以及JVM内部对线程和内存的精细控制。

#### 3.分区模型

> 在Java中，分区模型（Region Model）是G1垃圾回收器的核心概念之一。G1垃圾回收器将堆内存划分为多个固定大小的区域（Region），每个区域都独立进行垃圾回收。对象在G1中是以卡片（Card）为单位进行分配的，卡片是一种用于追踪跨区域引用的数据结构。
> 以下是一个简化的Java实现，用于展示G1的分区模型和对象分配的基本概念：
>
> ```java
> import java.util.ArrayList;
> import java.util.List;
> // 模拟卡片（Card）
> class Card {
>     private final int id;
>     private boolean hasReferences;
>     public Card(int id) {
>         this.id = id;
>         this.hasReferences = false;
>     }
>     public int getId() {
>         return id;
>     }
>     public boolean hasReferences() {
>         return hasReferences;
>     }
>     public void setHasReferences(boolean hasReferences) {
>         this.hasReferences = hasReferences;
>     }
> }
> // 模拟区域（Region）
> class Region {
>     private final int id;
>     private List<Object> objects = new ArrayList<>();
>     private List<Card> cards = new ArrayList<>();
>     public Region(int id) {
>         this.id = id;
>     }
>     public int getId() {
>         return id;
>     }
>     public void addObject(Object obj) {
>         objects.add(obj);
>     }
>     public List<Object> getObjects() {
>         return objects;
>     }
>     public void addCard(Card card) {
>         cards.add(card);
>     }
>     public List<Card> getCards() {
>         return cards;
>     }
> }
> // 模拟G1垃圾回收器
> class G1GarbageCollector {
>     private List<Region> regions = new ArrayList<>();
>     // 创建分区模型，包含5个区域
>     public void createPartitionModel(int numRegions) {
>         for (int i = 0; i < numRegions; i++) {
>             regions.add(new Region(i));
>         }
>     }
>     // 向特定区域添加对象
>     public void addObjectToRegion(int regionId, Object obj) {
>         Region region = getRegion(regionId);
>         if (region != null) {
>             region.addObject(obj);
>         }
>     }
>     // 获取指定区域
>     private Region getRegion(int regionId) {
>         for (Region region : regions) {
>             if (region.getId() == regionId) {
>                 return region;
>             }
>         }
>         return null;
>     }
>     // 获取所有区域
>     public List<Region> getRegions() {
>         return regions;
>     }
> }
> // 模拟对象分配
> class ObjectAllocator {
>     private G1GarbageCollector g1;
>     public ObjectAllocator(G1GarbageCollector g1) {
>         this.g1 = g1;
>     }
>     // 向特定区域分配对象
>     public void allocateObjectToRegion(int regionId, Object obj) {
>         g1.addObjectToRegion(regionId, obj);
>         // 分配卡片
>         Region region = g1.getRegion(regionId);
>         Card card = new Card(regionId);
>         region.addCard(card);
>         // 设置卡片有引用
>         card.setHasReferences(true);
>     }
> }
> public class G1PartitionModelExample {
>     public static void main(String[] args) {
>         G1GarbageCollector g1 = new G1GarbageCollector();
>         g1.createPartitionModel(5); // 创建5个区域
>         ObjectAllocator allocator = new ObjectAllocator(g1);
>         // 向不同区域分配对象
>         allocator.allocateObjectToRegion(0, new Object());
>         allocator.allocateObjectToRegion(1, new Object());
>         allocator.allocateObjectToRegion(2, new Object());
>         allocator.allocateObjectToRegion(3, new Object());
>         allocator.

#### 4.收集集合Set

> 在Java中，模拟G1垃圾回收器的收集集合（CSet）涉及模拟年轻代、老年代和混合代的垃圾回收过程。收集集合是G1垃圾回收器中的一个概念，它表示在一次垃圾回收暂停中将要被回收的区域集合。
> 以下是一个简化的Java实现，用于展示收集集合的概念：
>
> ```java
> import java.util.ArrayList;
> import java.util.List;
> // 模拟区域（Region）
> class Region {
>     private final int id;
>     private List<Object> objects = new ArrayList<>();
>     public Region(int id) {
>         this.id = id;
>     }
>     public int getId() {
>         return id;
>     }
>     public void addObject(Object obj) {
>         objects.add(obj);
>     }
>     public List<Object> getObjects() {
>         return objects;
>     }
> }
> // 模拟G1垃圾回收器
> class G1GarbageCollector {
>     private List<Region> youngGenRegions = new ArrayList<>();
>     private List<Region> oldGenRegions = new ArrayList<>();
>     private List<Region> mixedGenRegions = new ArrayList<>();
>     // 创建分区模型，包含5个年轻代区域、5个老年代区域和1个混合代区域
>     public void createPartitionModel(int numYoungGenRegions, int numOldGenRegions, int numMixedGenRegions) {
>         for (int i = 0; i < numYoungGenRegions; i++) {
>             youngGenRegions.add(new Region(i));
>         }
>         for (int i = 0; i < numOldGenRegions; i++) {
>             oldGenRegions.add(new Region(i));
>         }
>         mixedGenRegions.add(new Region(i));
>     }
>     // 向特定区域添加对象
>     public void addObjectToRegion(int regionId, Object obj) {
>         Region region = getRegion(regionId);
>         if (region != null) {
>             region.addObject(obj);
>         }
>     }
>     // 获取指定区域
>     private Region getRegion(int regionId) {
>         for (Region region : youngGenRegions) {
>             if (region.getId() == regionId) {
>                 return region;
>             }
>         }
>         for (Region region : oldGenRegions) {
>             if (region.getId() == regionId) {
>                 return region;
>             }
>         }
>         for (Region region : mixedGenRegions) {
>             if (region.getId() == regionId) {
>                 return region;
>             }
>         }
>         return null;
>     }
>     // 获取所有区域
>     public List<Region> getYoungGenRegions() {
>         return youngGenRegions;
>     }
>     public List<Region> getOldGenRegions() {
>         return oldGenRegions;
>     }
>     public List<Region> getMixedGenRegions() {
>         return mixedGenRegions;
>     }
> }
> // 模拟对象分配
> class ObjectAllocator {
>     private G1GarbageCollector g1;
>     public ObjectAllocator(G1GarbageCollector g1) {
>         this.g1 = g1;
>     }
>     // 向特定区域分配对象
>     public void allocateObjectToRegion(int regionId, Object obj) {
>         g1.addObjectToRegion(regionId, obj);
>     }
> }
> public class G1PartitionModelExample {
>     public static void main(String[] args) {
>         G1GarbageCollector g1 = new G1GarbageCollector();
>         g1.createPartitionModel(5, 5, 1); // 创建5个年轻代区域、5个老年代区域和1个混合代区域
>         ObjectAllocator allocator = new ObjectAllocator(g1);
>         // 向不同区域分配对象
>         allocator.allocateObjectToRegion(0, new Object());
>         allocator.allocateObjectToRegion(1, new Object());
>         allocator.allocateObjectToRegion(2, new Object());
>         allocator.        allocator.allocateObjectToRegion(3, new Object());
>         allocator.allocateObjectToRegion(4, new Object());
>         allocator.allocateObjectToRegion(5, new Object());
>         allocator.allocateObjectToRegion(6, new Object());
>         allocator.allocateObjectToRegion(7, new Object());
>         allocator.allocateObjectToRegion(8, new Object());
>         allocator.allocateObjectToRegion(9, new Object());
>         allocator.allocateObjectToRegion(10, new Object());
> 
>         // 模拟垃圾回收过程
>         // 这里我们假设有一个固定的垃圾回收周期，并手动选择要回收的区域
>         // 实际中，G1会根据内存使用情况和用户指定的目标暂停时间来动态选择CSet
>         g1.getYoungGenRegions().get(0).getObjects().clear(); // 假设第一个年轻代区域被选中回收
>         g1.getOldGenRegions().get(0).getObjects().clear(); // 假设第一个老年代区域被选中回收
>         g1.getMixedGenRegions().get(0).getObjects().clear(); // 假设混合代区域被选中回收
> 
>         // 输出结果
>         System.out.println("Young Generation regions after collection: " + g1.getYoungGenRegions());
>         System.out.println("Old Generation regions after collection: " + g1.getOldGenRegions());
>         System.out.println("Mixed Generation region after collection: " + g1.getMixedGenRegions());
>     }
> }
> 
> ```
>
> 在这个例子中，我们定义了三个类：`Region`、`G1GarbageCollector` 和 `ObjectAllocator`。`Region` 类代表一个区域，它包含一组对象。`G1GarbageCollector` 类模拟了G1垃圾回收器的行为，包括年轻代、老年代和混合代的区域。`ObjectAllocator` 类模拟了对象的分配过程。
>
> 以下是模拟的基本步骤：
>
> 1. **创建分区模型**：在 `createPartitionModel` 方法中，我们创建了指定数量的年轻代、老年代和混合代区域。
> 2. **向特定区域分配对象**：在 `allocateObjectToRegion` 方法中，我们向特定区域分配对象。
> 3. **模拟垃圾回收过程**：在 `main` 方法中，我们模拟了垃圾回收过程，这里我们手动选择了要回收的区域。实际中，G1会根据内存使用情况和用户指定的目标暂停时间来动态选择CSet。
>
> 请注意，这个模拟是非常简化的，它没有考虑垃圾回收器的许多复杂性和细节，例如：
>
> - 对象的可达性分析。
> - 垃圾回收过程中的暂停时间。
> - 跨代引用的处理。
> - 垃圾回收的性能优化。
>
> 在真实的JVM中，分代模型涉及到复杂的算法和数据结构，以及JVM内部对线程和内存的精细控制。

#### 5.CollectionSet

> 在Java中，CSet（Collection Set）是G1垃圾回收器中的一个概念，它表示在一次垃圾回收暂停中将要被回收的区域的集合。由于CSet是G1垃圾回收器的内部实现细节，我们无法直接在Java代码中创建或操作CSet。不过，为了说明CSet的概念，我们可以编写一个模拟的例子，其中我们将手动选择哪些区域应该被回收。
> 以下是一个简化的例子，用于演示CSet的概念：
>
> ```java
> import java.util.ArrayList;
> import java.util.List;
> // 模拟区域（Region）
> class Region {
>     private final int id;
>     private long usedMemory; // 该区域已使用的内存量
>     public Region(int id, long usedMemory) {
>         this.id = id;
>         this.usedMemory = usedMemory;
>     }
>     public int getId() {
>         return id;
>     }
>     public long getUsedMemory() {
>         return usedMemory;
>     }
>     // 省略其他区域相关的方法...
> }
> // 模拟G1垃圾回收器选择CSet的过程
> class G1GarbageCollector {
>     private List<Region> regions; // 所有区域的列表
>     private long currentPauseTarget; // 当前垃圾回收暂停的目标时间
>     public G1GarbageCollector(List<Region> regions) {
>         this.regions = regions;
>         this.currentPauseTarget = 100; // 假设目标暂停时间为100ms
>     }
>     // 选择CSet的过程
>     public List<Region> selectCSet() {
>         List<Region> cSet = new ArrayList<>();
>         long estimatedPauseTime = 0;
>         // 假设我们按照内存使用量从大到小选择区域
>         regions.sort((r1, r2) -> Long.compare(r2.getUsedMemory(), r1.getUsedMemory()));
>         for (Region region : regions) {
>             if (estimatedPauseTime + region.getUsedMemory() / 1000 < currentPauseTarget) {
>                 cSet.add(region);
>                 estimatedPauseTime += region.getUsedMemory() / 1000; // 假设每KB内存需要1ms来回收
>             } else {
>                 break; // 如果超出暂停目标时间，停止选择
>             }
>         }
>         return cSet;
>     }
>     // 省略其他垃圾回收相关的方法...
> }
> public class CSetExample {
>     public static void main(String[] args) {
>         // 创建一些模拟区域
>         List<Region> regions = new ArrayList<>();
>         regions.add(new Region(1, 500)); // 区域1，使用500KB内存
>         regions.add(new Region(2, 300)); // 区域2，使用300KB内存
>         regions.add(new Region(3, 700)); // 区域3，使用700KB内存
>         regions.add(new Region(4, 200)); // 区域4，使用200KB内存
>         // 创建G1垃圾回收器实例
>         G1GarbageCollector g1 = new G1GarbageCollector(regions);
>         // 选择CSet
>         List<Region> cSet = g1.selectCSet();
>         // 输出选择的CSet
>         System.out.println("Selected CSet:");
>         for (Region region : cSet) {
>             System.out.println("Region " + region.getId() + " with " + region.getUsedMemory() + "KB memory");
>         }
>     }
> }
> ```
> 在这个例子中，我们定义了两个类：`Region` 和 `G1GarbageCollector`。`Region` 类代表一个区域，它包含一个ID和已使用的内存量。`G1GarbageCollector` 类模拟了G1垃圾回收器选择CSet的过程。在`selectCSet`方法中，我们按照内存使用量从大到小的顺序选择区域，直到达到预设的暂停目标时间。
> 请注意，这个例子仅用于说明CSet的概念，实际的G1垃圾回收器在选择CSet时会考虑更多因素，如区域中的垃圾比例、回收效率等。而且，CSet的选择和垃圾回收操作是由JVM内部自动完成的，Java应用程序无法直接干预。

#### 6.RememberSet的维护

> 在Java中，Remembered Set（RSet）是一种用于跟踪跨区域引用的数据结构，它使得垃圾回收器（如G1）能够在回收某个区域时，快速确定是否有外部引用指向该区域内的对象。由于RSet是JVM的内部实现细节，我们无法直接在Java代码中操作RSet。但是，我们可以通过一个模拟的例子来展示RSet的维护思路。
> 以下是一个简化的例子，用于说明RSet的维护过程：
>
> ```java
> import java.util.HashMap;
> import java.util.HashSet;
> import java.util.Map;
> import java.util.Set;
> // 模拟区域（Region）
> class Region {
>     private final int id;
>     private Set<Object> objects = new HashSet<>();
>     public Region(int id) {
>         this.id = id;
>     }
>     public void addObject(Object obj) {
>         objects.add(obj);
>     }
>     public int getId() {
>         return id;
>     }
>     // 省略其他区域相关的方法...
> }
> // 模拟Remembered Set
> class RememberedSet {
>     // 使用Map来模拟RSet，键是区域ID，值是引用该区域的对象集合
>     private Map<Integer, Set<Object>> rSet = new HashMap<>();
>     // 当一个对象被添加到某个区域时，更新RSet
>     public void addObjectReference(Region toRegion, Object obj) {
>         rSet.computeIfAbsent(toRegion.getId(), k -> new HashSet<>()).add(obj);
>     }
>     // 检查是否有其他区域的对象引用了当前区域
>     public boolean hasReferencesFromOtherRegions(Region region) {
>         return rSet.containsKey(region.getId());
>     }
>     // 获取引用了当前区域的所有对象
>     public Set<Object> getReferencesToRegion(Region region) {
>         return rSet.getOrDefault(region.getId(), new HashSet<>());
>     }
>     // 省略其他RSet相关的方法...
> }
> // 模拟对象引用更新
> class ObjectReferenceUpdater {
>     private RememberedSet rememberedSet;
>     public ObjectReferenceUpdater(RememberedSet rememberedSet) {
>         this.rememberedSet = rememberedSet;
>     }
>     // 假设objFrom在fromRegion，objTo在toRegion
>     public void updateReference(Object objFrom, Region fromRegion, Object objTo, Region toRegion) {
>         // 更新引用
>         // ...（这里省略实际更新引用的代码）
>         // 在引用更新后，更新RSet
>         rememberedSet.addObjectReference(toRegion, objFrom);
>     }
> }
> public class RSetMaintenanceExample {
>     public static void main(String[] args) {
>         // 创建两个区域
>         Region region1 = new Region(1);
>         Region region2 = new Region(2);
>         // 创建RSet
>         RememberedSet rSet = new RememberedSet();
>         // 创建对象引用更新器
>         ObjectReferenceUpdater updater = new ObjectReferenceUpdater(rSet);
>         // 假设region1中的对象obj1引用了region2中的对象obj2
>         Object obj1 = new Object(); // obj1在region1
>         Object obj2 = new Object(); // obj2在region2
>         region1.addObject(obj1);
>         region2.addObject(obj2);
>         // 更新引用，并通知RSet
>         updater.updateReference(obj1, region1, obj2, region2);
>         // 检查RSet，确认region2是否有来自region1的引用
>         if (rSet.hasReferencesFromOtherRegions(region2)) {
>             System.out.println("Region 2 has references from Region 1.");
>             Set<Object> references = rSet.getReferencesToRegion(region2);
>             System.out.println("Objects referencing Region 2: " + references);
>         }
>     }
> }
> ```
> 在这个例子中，我们定义了三个类：`Region`、`RememberedSet` 和 `ObjectReferenceUpdater`。`Region` 类代表一个区域，它包含一组对象。`RememberedSet` 类模拟了RSet，它使用一个Map来记录哪些外部对象引用了当前区域的对象。`ObjectReferenceUpdater` 类模拟了在对象引用更新时如何维护RSet。
> 以下是RSet维护的基本思路：
> 1. **引用更新**：每当一个对象引用了另一个区域的对象时，`ObjectReferenceUpdater` 会更新RSet，将引用者对象添加到被引用区域的RSet中。
> 2. **记录引用**：RSet通过一个Map来记录信息，其中键是被引用区域的ID，值是引用该区域的所有对象的集合。
> 3. **检查引用**：在垃圾回收时，可以通过RSet快速检查是否有外部引用指向特定区域的对象，从而确定该区域是否可达。
> 4. **维护操作**：在实际的JVM实现中，RSet的维护通常是通过写屏障（Write Barrier）来完成的，这是一种在对象字段更新时触发的轻量级操作。
>     请注意，这个

#### 7.Concurrent Marking Cycle

> 在Java中，并发标记周期是G1垃圾回收器（Garbage-First Garbage Collector）执行的一个阶段，其目的是标记堆中所有的活动对象。由于并发标记周期涉及到JVM的内部实现，直接用Java代码来分析这个过程是非常有限的。不过，我们可以编写一个模拟的例子来展示并发标记周期的大致流程。
> 以下是一个简化的例子，用于模拟并发标记周期：
> ```java
> import java.util.ArrayList;
> import java.util.List;
> import java.util.concurrent.atomic.AtomicBoolean;
> // 模拟对象
> class MyObject {
>     // 模拟对象的一些属性
>     MyObject ref; // 引用其他对象
>     public MyObject(MyObject ref) {
>         this.ref = ref;
>     }
> }
> // 模拟标记线程
> class MarkingThread extends Thread {
>     private final List<MyObject> objects;
>     private final AtomicBoolean keepRunning;
>     public MarkingThread(List<MyObject> objects, AtomicBoolean keepRunning) {
>         this.objects = objects;
>         this.keepRunning = keepRunning;
>     }
>     @Override
>     public void run() {
>         while (keepRunning.get()) {
>             for (MyObject obj : objects) {
>                 // 模拟标记过程
>                 mark(obj);
>             }
>         }
>     }
>     private void mark(MyObject obj) {
>         // 这里仅打印出标记的对象，实际标记过程会更复杂
>         System.out.println("Marking object: " + obj);
>     }
> }
> public class ConcurrentMarkingCycleExample {
>     public static void main(String[] args) throws InterruptedException {
>         // 创建一些对象
>         MyObject obj1 = new MyObject(null);
>         MyObject obj2 = new MyObject(obj1);
>         MyObject obj3 = new MyObject(null);
>         List<MyObject> objects = new ArrayList<>();
>         objects.add(obj1);
>         objects.add(obj2);
>         objects.add(obj3);
>         // 控制标记线程的运行
>         AtomicBoolean keepRunning = new AtomicBoolean(true);
>         // 创建并启动标记线程
>         MarkingThread markingThread = new MarkingThread(objects, keepRunning);
>         markingThread.start();
>         // 模拟应用程序运行一段时间
>         Thread.sleep(2000);
>         // 停止标记线程
>         keepRunning.set(false);
>         markingThread.join();
>     }
> }
> ```
> 在这个例子中，我们定义了两个类：`MyObject` 和 `MarkingThread`。`MyObject` 类代表堆中的对象，而 `MarkingThread` 类模拟了并发标记周期中的标记线程。
> 以下是并发标记周期的大致流程：
> 1. **初始化**：创建应用程序对象并构建它们的引用关系。
> 2. **启动标记线程**：创建一个标记线程，该线程将遍历所有对象并执行标记操作。
> 3. **标记过程**：在 `MarkingThread` 的 `run` 方法中，模拟了标记过程。在实际的G1垃圾回收器中，这个过程会遍历所有可达的对象，并将它们标记为活动状态。
> 4. **应用程序运行**：在主线程中，模拟应用程序的运行，与此同时，标记线程在后台并发执行。
> 5. **停止标记**：当标记周期结束时（例如，根据垃圾回收策略的决定或者应用程序的停止），标记线程被停止。
>     请注意，这个例子是非常简化的，它没有展示实际的并发标记算法的复杂性，也没有涉及到JVM如何处理线程同步、内存屏障、安全点等问题。在真实的JVM中，并发标记周期是由多个线程在多个阶段中协作完成的，且涉及到复杂的内存管理操作。

#### 8.年轻代收集/混合收集周期

> 在Java中，年轻代收集（Young Generation Collection）和混合收集周期（Mixed Collection Cycle）是G1垃圾回收器（Garbage-First Garbage Collector）中的两个重要概念。年轻代收集主要关注于清理年轻代中的垃圾，而混合收集周期则同时清理年轻代和老年代。
> 下面是一个简化的Java模拟实现，用于展示年轻代收集和混合收集周期的基本概念：
> ```java
> import java.util.ArrayList;
> import java.util.List;
> import java.util.Random;
> // 模拟对象
> class MyObject {
>     // 模拟对象的一些属性
>     MyObject ref; // 引用其他对象
>     public MyObject(MyObject ref) {
>         this.ref = ref;
>     }
> }
> // 模拟G1垃圾回收器
> class G1GarbageCollector {
>     private List<MyObject> youngGenObjects = new ArrayList<>();
>     private List<MyObject> oldGenObjects = new ArrayList<>();
>     // 模拟年轻代收集
>     public void youngGenerationCollection() {
>         System.out.println("Young Generation Collection started.");
>         youngGenObjects.clear(); // 清空年轻代
>         System.out.println("Young Generation Collection completed.");
>     }
>     // 模拟混合收集周期
>     public void mixedCollectionCycle() {
>         System.out.println("Mixed Collection Cycle started.");
>         youngGenerationCollection(); // 首先执行年轻代收集
>         oldGenObjects.clear(); // 清理老年代
>         System.out.println("Mixed Collection Cycle completed.");
>     }
>     // 模拟对象晋升到老年代
>     public void promoteToOldGeneration(MyObject obj) {
>         youngGenObjects.remove(obj); // 从年轻代移除
>         oldGenObjects.add(obj); // 添加到老年代
>     }
>     // 模拟应用程序运行，创建对象
>     public void simulateApplicationRunning() {
>         Random random = new Random();
>         for (int i = 0; i < 10; i++) {
>             MyObject obj = new MyObject(null); // 创建新对象
>             youngGenObjects.add(obj); // 添加到年轻代
>             if (random.nextBoolean()) {
>                 promoteToOldGeneration(obj); // 随机晋升到老年代
>             }
>         }
>     }
> }
> public class G1SimulationExample {
>     public static void main(String[] args) {
>         G1GarbageCollector g1 = new G1GarbageCollector();
>         // 模拟应用程序运行
>         g1.simulateApplicationRunning();
>         // 执行年轻代收集
>         g1.youngGenerationCollection();
>         // 执行混合收集周期
>         g1.mixedCollectionCycle();
>     }
> }
> ```
> 在这个模拟中，我们定义了两个类：`MyObject` 和 `G1GarbageCollector`。`MyObject` 类代表堆中的对象，而 `G1GarbageCollector` 类模拟了G1垃圾回收器的行为。
> 以下是模拟的基本步骤：
> 1. **模拟应用程序运行**：在 `simulateApplicationRunning` 方法中，我们模拟了应用程序的运行，创建新对象并将它们添加到年轻代。随机地，一些对象会被晋升到老年代。
> 2. **年轻代收集**：在 `youngGenerationCollection` 方法中，我们模拟了年轻代收集的过程，这里简单地清空了年轻代列表。
> 3. **混合收集周期**：在 `mixedCollectionCycle` 方法中，我们模拟了混合收集周期，首先执行年轻代收集，然后清理老年代。
> 请注意，这个模拟是非常简化的，它没有考虑垃圾回收器的许多复杂性和细节，例如：
> - 对象的可达性分析。
> - 垃圾回收过程中的暂停时间。
> - 跨代引用的处理。
> - 垃圾回收的性能优化。
> 在真实的JVM中，年轻代收集和混合收集周期涉及到复杂的算法和数据结构，以及JVM内部对线程和内存的精细控制。

#### 9.并发标记周期后的年轻代收集

> 在Java中，实现并发标记周期后的年轻代收集（Post-Concurrent Marking Cycle Young Generation Collection）需要模拟G1垃圾回收器的行为。这通常涉及到以下几个步骤：
> 1. **并发标记周期**：在并发标记周期中，垃圾回收器会标记所有可达的对象。
> 2. **筛选回收**：在筛选回收阶段，垃圾回收器会根据标记结果选择需要回收的年轻代区域。
> 3. **年轻代收集**：在年轻代收集阶段，垃圾回收器会回收筛选出来的年轻代区域的垃圾。
> 以下是一个简化的Java模拟实现，用于展示并发标记周期后的年轻代收集的基本概念：
> ```java
> import java.util.ArrayList;
> import java.util.List;
> import java.util.concurrent.atomic.AtomicBoolean;
> // 模拟对象
> class MyObject {
>     // 模拟对象的一些属性
>     MyObject ref; // 引用其他对象
>     public MyObject(MyObject ref) {
>         this.ref = ref;
>     }
> }
> // 模拟G1垃圾回收器
> class G1GarbageCollector {
>     private List<MyObject> youngGenObjects = new ArrayList<>();
>     private List<MyObject> oldGenObjects = new ArrayList<>();
>     private AtomicBoolean concurrentMarkingComplete = new AtomicBoolean(false);
>     // 模拟并发标记周期
>     public void concurrentMarking() {
>         System.out.println("Concurrent Marking started.");
>         // 这里可以模拟并发标记周期的工作，例如标记所有可达的对象
>         // 为了简化，我们直接设置并发标记周期完成
>         concurrentMarkingComplete.set(true);
>         System.out.println("Concurrent Marking completed.");
>     }
>     // 模拟筛选回收
>     public void selectiveCollection() {
>         System.out.println("Selective Collection started.");
>         // 这里可以模拟筛选回收的工作，例如根据标记结果选择需要回收的区域
>         // 为了简化，我们直接清理年轻代
>         youngGenObjects.clear();
>         System.out.println("Selective Collection completed.");
>     }
>     // 模拟年轻代收集
>     public void youngGenerationCollection() {
>         System.out.println("Young Generation Collection started.");
>         // 这里可以模拟年轻代收集的工作，例如回收年轻代的垃圾
>         // 为了简化，我们直接清空年轻代
>         youngGenObjects.clear();
>         System.out.println("Young Generation Collection completed.");
>     }
>     // 模拟对象晋升到老年代
>     public void promoteToOldGeneration(MyObject obj) {
>         youngGenObjects.remove(obj); // 从年轻代移除
>         oldGenObjects.add(obj); // 添加到老年代
>     }
>     // 模拟应用程序运行，创建对象
>     public void simulateApplicationRunning() {
>         Random random = new Random();
>         for (int i = 0; i < 10; i++) {
>             MyObject obj = new MyObject(null); // 创建新对象
>             youngGenObjects.add(obj); // 添加到年轻代
>             if (random.nextBoolean()) {
>                 promoteToOldGeneration(obj); // 随机晋升到老年代
>             }
>         }
>     }
> }
> public class G1SimulationExample {
>     public static void main(String[] args) {
>         G1GarbageCollector g1 = new G1GarbageCollector();
>         // 模拟应用程序运行
>         g1.simulateApplicationRunning();
>         // 执行并发标记周期
>         g1.concurrentMarking();
>         // 等待并发标记周期完成
>         while (!g1.concurrentMarkingComplete.get()) {
>             // 等待并发标记周期完成
>         }
>         // 执行筛选回收
>         g1.selectiveCollection();
>         // 执行年轻代收集
>         g1.youngGenerationCollection();
>     }
> }
> ```
> 在这个模拟中，我们定义了两个类：`MyObject` 和 `G1GarbageCollector`。`MyObject` 类代表堆中的对象，而 `G1GarbageCollector` 类模拟了G1垃圾回收器的行为。
> 以下是模拟的基本步骤：
> 1. **模拟应用程序运行**：在 `simulateApplicationRunning` 方法中
> 2. 中，我们模拟了应用程序的运行，创建新对象并将它们添加到年轻代。随机地，一些对象会被晋升到老年代。
> 3. **执行并发标记周期**：在 `concurrentMarking` 方法中，我们模拟了并发标记周期的工作，这里直接设置并发标记周期完成。
> 4. **等待并发标记周期完成**：在 `main` 方法中，我们使用一个循环来等待并发标记周期完成。在实际的G1垃圾回收器中，这个等待是通过垃圾回收器内部的同步机制来实现的。
> 5. **执行筛选回收**：在 `selectiveCollection` 方法中，我们模拟了筛选回收的工作，这里直接清理年轻
> 6. **执行年轻代收集**：在 `youngGenerationCollection` 方法中，我们模拟了年轻代收集的工作，这里直接清空年轻代。
>
> 请注意，这个模拟是非常简化的，它没有考虑垃圾回收器的许多复杂性和细节，例如：
>
> - 对象的可达性分析。
> - 垃圾回收过程中的暂停时间。
> - 跨代引用的处理。
> - 垃圾回收的性能优化。

### C.ZGC垃圾回收器

#### 0.指针染色与内存屏障

> ZGC（Z Garbage Collector）是Java虚拟机中的一个垃圾回收器，它旨在提供低延迟的垃圾回收，同时处理大堆内存（multi-terabyte heaps）而不会造成长时间的停顿。ZGC的核心原理是着色指针（Colored Pointers）和负载屏障（Load/Store Barriers）。
> ### 着色指针（Colored Pointers）
> 着色指针是一种将额外的信息存储在指针中的技术。在64位操作系统中，指针通常没有完全使用所有的位，因此可以利用这些未使用的位来存储额外的信息，这些信息可以用来标记对象的状态。ZGC使用以下几种颜色：
> - **白色**：表示未被垃圾回收器追踪的对象。
> - **黑色**：表示活动对象，即肯定不是垃圾的对象。
> - **灰色**：表示活动对象，但这些对象可能指向白色对象。
> 具体实现上，ZGC将指针分割成几个部分：
> 1. **标记位（Mark Bit）**：用于标记对象是否被访问过。
> 2. **转发位（Forwarding Bit）**：用于标记对象是否已经被移动。
> 3. **剩余的位**：用于指向对象的实际地址。
> ### 负载屏障（Load Barrier）和存储屏障（Store Barrier）
> 屏障是ZGC中用于维护指针染色一致性的机制。屏障不是实际的物理屏障，而是一段代码，它在特定的内存访问时插入执行。
> - **负载屏障（Load Barrier）**：当从堆中读取指针时触发。如果读取的指针是灰色或需要更新的，屏障会将其更新为正确的地址，并可能将对象标记为灰色以便进行后续的标记操作。
> - **存储屏障（Store Barrier）**：当向堆中写入指针时触发。存储屏障确保所有写入的指针都是正确的，并可能触发对象的重新标记。
> ### 实现例子
> 假设我们有以下对象：
> ```
> Object A -> Object B
> ```
> ZGC在进行垃圾回收时的步骤可能如下：
> 1. **标记开始**：所有对象的指针都被标记为白色。
> 2. **根对象标记**：从根集合开始，将根直接引用的对象标记为灰色。
> 3. **标记过程**：
>     - 通过灰色对象，访问所有白色对象的指针，将这些对象标记为灰色。
>     - 同时，将这些灰色对象标记为黑色，因为它们已经被访问过了。
> 4. **读写屏障的实际应用**：
>     - 当读取对象A的指针时，触发**负载屏障**。如果A是灰色的，屏障代码会将A标记为黑色，并继续扫描A指向的对象。
>     - 当对象A更新指向对象C时（A -> C），触发**存储屏障**，确保这个更新操作正确处理指针染色。
> 5. **清理**：最后，所有未被标记为黑色的对象（即白色对象）被认为是垃圾，并进行回收。
> 以一个简单的代码为例：
> ```java
> public class Example {
>     public static Object objB;
>     public static void main(String[] args) {
>         Object objA = new Object(); // objA 初始为白色
>         objB = new Object();        // objB 初始为白色
>         // 假设这里发生了垃圾回收
>         // 根集合包含objA，所以objA被标记为灰色
>         // 假设此时触发了一次负载屏障
>         Object objC = objB; // 读取objB，触发负载屏障
>                            // 如果objB是灰色的，屏障会将其标记为黑色，并继续扫描
>         // 假设这里发生了存储屏障
>         objA = new Object(); // 更新objA，触发存储屏障
>     }
> }
> ```
> 在这个例子中，当垃圾回收发生时，读写屏障确保了指针的正确染色，并且正确地处理了对象间的引用关系。通过这种方式，ZGC能够在几乎不影响程序运行的情况下，完成垃圾回收工作。

#### 1.ZGC工作流程

> ZGC（Z Garbage Collector）的工作顺序可以分为以下几个主要阶段，这些阶段通常与垃圾回收的并发标记-整理（Concurrent Mark-Sweep）算法类似，但ZGC特别注重减少停顿时间：
> ### 1. 初始标记（Initial Mark）
> - **停顿（Stop-The-World, STW）**：这是ZGC过程中唯一一个需要完全停顿应用程序的阶段，用于标记根集合（root set），即直接从应用程序的根（如线程栈、全局变量等）可达的对象。
> - 在这个阶段，ZGC标记所有直接可达的对象。
> ### 2. 并发标记（Concurrent Mark）
> - **并发执行**：在这个阶段，ZGC遍历堆中的对象，标记所有存活的对象。这个过程是并发进行的，应用程序线程可以继续运行。
> - ZGC使用标记位来标记对象，并且使用读写屏障来维护标记的准确性。
> ### 3. 最终标记（Final Mark）
> - **部分停顿（Partially STW）**：这个阶段是为了处理并发标记阶段可能遗漏的少量标记工作。
> - 它会标记所有在并发标记阶段开始时尚未完成的对象。
> ### 4. 并发预备重分配（Concurrent Prepare for Relocation）
> - **并发执行**：这个阶段准备重分配集合，确定哪些区域（pages）中的对象将被重定位。
> - 它会更新对象引用，确保指向重定位对象的指针在后续阶段可以被正确更新。
> ### 5. 并发重分配（Concurrent Relocate）
> - **并发执行**：这个阶段是ZGC进行垃圾回收的核心，它会移动存活对象到新的内存区域，并更新所有指向这些对象的引用。
> - 这个过程是并发进行的，ZGC使用转发指针（forwarding pointers）和存储屏障（store barriers）来确保应用程序线程能够访问到正确的对象。
> ### 6. 清理（Cleanup）
> - **部分停顿（Partially STW）**：这个阶段是可选的，用于清理不再需要的元数据，如撤销重定位的标记等。
> - 它可能会停顿虚拟机，但通常这个停顿时间非常短。
> 以下是ZGC工作顺序的简图：
> ```
> 初始标记 (STW)
>     |
>     v
> 并发标记
>     |
>     v
> 最终标记 (部分STW)
>     |
>     v
> 并发预备重分配
>     |
>     v
> 并发重分配
>     |
>     v
> 清理 (部分STW)
> ```
> 整个过程中，除了初始标记和最终标记阶段，ZGC几乎都是并发执行的，这极大地减少了停顿时间。ZGC的设计目标之一就是最小化停顿时间，使其适用于需要低延迟的大内存应用程序。

## 五：Java内存模型

### 0.纯八股问答部分

1. **问**：什么是Java内存模型（JMM）？
   **答**：JMM是Java内存模型的简称，它定义了Java程序中各种变量（实例域、静态域和数组元素）的访问规则，以及在JVM中各线程之间如何通过主内存进行交互，以保证内存一致性 。(实例域是对象实例特有的变量，静态域是类级别的变量，数组元素是数组对象中存储数据的位置，分别用Java表达就是：`private int instanceField;`、`static int staticField;` 和 `int[] array = new int[10];`。)

2. **问**：JMM存在的意义是什么？
   **答**：JMM的主要目的是解决多线程环境下的内存一致性问题，确保在不同硬件和操作系统下Java程序内存访问的一致性 。

3. **问**：请简述主内存和工作内存的区别？
   **答**：主内存是所有线程共享的内存区域，用于存储所有线程共享变量。工作内存是每个线程的私有内存区域，存储该线程使用的变量副本 。

4. **问**：线程如何进行变量的访问？
   **答**：线程不能直接访问主内存中的变量，必须通过工作内存来读取和写入变量值，然后与主内存进行同步 。

5. > **问**：JMM定义了哪些操作来完成主内存和工作内存的交互？
   > **答**：JMM定义了8种操作：lock、unlock、read、load、use、assign、store、write，来完成主内存和工作内存的交互 。
   >
   > 在Java中，这些操作是隐式发生的，并没有直接的语法来标记每个操作。但是，为了说明这些操作，我们可以通过注释来指明每个步骤可能对应的操作。以下是一个示例，其中我使用了`synchronized`块来显式地涉及`lock`和`unlock`操作，并使用`volatile`关键字来涉及`read`、`load`、`use`、`assign`、`store`、`write`操作。
   > ```java
   > public class JMMExample {
   >     // 使用volatile关键字保证变量的可见性和有序性
   >     private volatile int sharedVariable = 0;
   >     public void writeValue(int value) {
   >         // lock操作，当线程进入synchronized块时发生
   >         synchronized (this) {
   >             // assign操作，将值赋给共享变量
   >             sharedVariable = value; // assign + store + write
   >         }
   >         // unlock操作，当线程退出synchronized块时发生
   >     }
   >     public int readValue() {
   >         // lock操作，当线程进入synchronized块时发生
   >         synchronized (this) {
   >             // read操作，从主内存读取变量的值
   >             // load操作，将读取的值加载到工作内存
   >             // use操作，使用加载到工作内存的值
   >             int localVar = sharedVariable; // read + load + use
   >             return localVar;
   >         }
   >         // unlock操作，当线程退出synchronized块时发生
   >     }
   >     public static void main(String[] args) {
   >         JMMExample example = new JMMExample();
   >         // 创建一个线程来写入值
   >         Thread writerThread = new Thread(() -> {
   >             example.writeValue(1);
   >         });
   >         // 创建一个线程来读取值
   >         Thread readerThread = new Thread(() -> {
   >             int value = example.readValue();
   >             System.out.println("Read value: " + value);
   >         });
   >         // 启动线程
   >         writerThread.start();
   >         readerThread.start();
   >     }
   > }
   > ```
   > 在这个例子中：
   > - `lock`：当线程进入`synchronized`块时，隐式地发生。
   > - `assign`：`sharedVariable = value;` 这行代码执行赋值操作。
   > - `store`：赋值操作之后，新值被存储在主内存中。
   > - `write`：存储操作之后，新值被写入主内存。
   > 对于读取操作：
   > - `lock`：当线程进入`synchronized`块时，隐式地发生。
   > - `read`：从主内存读取`sharedVariable`的值。
   > - `load`：读取操作之后，值被加载到工作内存。
   > - `use`：加载到工作内存的值被线程使用。
   > 注意，这里使用`synchronized`块来确保操作的原子性和可见性，而`volatile`关键字确保了每次访问变量时都是直接操作主内存，这样我们可以把`read`、`load`、`use`、`assign`、`store`、`write`操作与`volatile`变量的读写关联起来。实际上，这些操作是由JMM和底层硬件确保的，程序员并不需要直接干预。
   
6. **问**：什么是原子性？
   **答**：原子性指的是一个操作或者一系列操作，要么全部执行，要么全部不执行，在执行过程中不会被任何其他操作中断 。

7. **问**：Java中哪些操作是原子性的？
   **答**：基本类型赋值操作是原子性的，但复合操作如`i++`不是原子性的，因为它们包含多个步骤 。

8. **问**：如何保证代码块的原子性？
   **答**：可以使用synchronized关键字来保证一个代码块的原子性，因为进入synchronized块之前需要获得锁 。

9. **问**：可见性是什么？
   **答**：可见性指当一个线程修改了共享变量的值，其他线程能够立即看到这个修改 。

10. **问**：Java中如何实现可见性？
    **答**：可以使用volatile关键字、synchronized或final关键字来实现可见性 。

11. **问**：什么是有序性？
    **答**：有序性指程序执行的顺序按照代码的先后顺序执行，但在多线程环境下，由于编译器优化和处理器乱序执行，可能会导致有序性问题 。

12. **问**：Java中如何保证有序性？
    **答**：可以使用synchronized或volatile关键字来保证多线程之间操作的有序性 。

13. **问**：什么是指令重排序？
    **答**：指令重排序是编译器和处理器为了提高执行效率，可能会改变指令的执行顺序，但保证不会改变程序的最终结果 。

14. **问**：指令重排序会带来什么问题？
    **答**：指令重排序可能会导致多线程环境下的内存可见性问题 。

15. **问**：JMM如何限制指令重排序？
    **答**：JMM通过happens-before原则以及在适当位置插入内存屏障来限制指令重排序 。

16. **问**：什么是happens-before原则？
    **答**：happens-before原则是JMM中的一个规则，指如果一个操作happens-before另一个操作，那么第一个操作的执行结果将对第二个操作可见 。

17. **问**：什么是as-if-serial语义？
    **答**：as-if-serial语义指不管编译器和处理器如何重排序，单线程程序的执行结果不能被改变 。

18. **问**：volatile关键字是如何保证原子性的？
    **答**：volatile关键字通过确保对变量的写操作对其他线程立即可见，以及在读取时直接从主内存中读取，来保证原子性 。

19. **问**：volatile关键字是如何实现可见性的？
    **答**：当变量被volatile修饰时，对它的写操作会立即刷新到主内存，而读操作会直接从主内存中读取最新值 。

20. **问**：除了volatile，还有哪些关键字可以保证可见性？
    **答**：final和synchronized关键字也可以保证可见性 。

21. **问**：什么是内存屏障？
    **答**：内存屏障是一种同步机制，用于控制特定变量的内存操作顺序，防止编译器和处理器对指令进行不合理的重排序 。

22. > **问**：内存屏障有哪些类型？
    > **答**：内存屏障主要有四种类型：LoadLoad屏障、StoreStore屏障、LoadStore屏障和StoreLoad屏障 。
    >
    > 在Java中，内存屏障是底层硬件和编译器优化的一部分，它们不是直接暴露给程序员的。但是，我们可以使用`volatile`关键字和`synchronized`块来暗示内存屏障的存在。Java内存模型（JMM）确保了在特定操作之间插入适当的内存屏障。
    > 以下是使用Java代码表达四种内存屏障类型的一个示例。请注意，这些屏障是由JMM隐式插入的，我们不能直接在代码中编写它们，但是我们可以通过注释来指明它们的存在。
    >
    > ```java
    > public class MemoryBarrierExample {
    >  private int a = 0;
    >  private volatile int volA = 0; // 使用volatile变量来暗示内存屏障
    >  private int b = 0;
    >  // StoreStore屏障示例
    >  public void storeStoreBarrierExample() {
    >      a = 1; // Store操作
    >      // StoreStore屏障隐式插入在这里
    >      volA = 2; // Store操作到volatile变量，暗示StoreStore屏障
    >  }
    >  // LoadLoad屏障示例
    >  public void loadLoadBarrierExample() {
    >       // Load操作
    >      int readA = volA; // Load操作从volatile变量，暗示LoadLoad屏障
    >      // LoadLoad屏障隐式插入在这里
    >      int readB = b; // Load操作
    >  }
    >  // LoadStore屏障示例
    >  public void loadStoreBarrierExample() {
    >      // Load操作
    >      int readA = volA; // Load操作从volatile变量，暗示LoadStore屏障
    >      // LoadStore屏障隐式插入在这里
    >      b = 3; // Store操作
    >  }
    >  // StoreLoad屏障示例
    >  public void storeLoadBarrierExample() {
    >      a = 1; // Store操作
    >      // StoreLoad屏障隐式插入在这里
    >      int readB = volA; // Load操作从volatile变量，暗示StoreLoad屏障
    >  }
    >  public static void main(String[] args) {
    >      MemoryBarrierExample example = new MemoryBarrierExample();
    >      // 调用示例方法来展示内存屏障
    >      example.storeStoreBarrierExample();
    >      example.loadLoadBarrierExample();
    >      example.loadStoreBarrierExample();
    >      example.storeLoadBarrierExample();
    >  }
    > }
    > ```
    > 在这个示例中：
    > - `StoreStoreBarrierExample`：在`a = 1;`之后，隐式地插入了一个`StoreStore`屏障，这确保了在写入`volA`之前，`a`的写入操作对其他线程可见。
    > - `LoadLoadBarrierExample`：在读取`volA`之后，隐式地插入了一个`LoadLoad`屏障，这确保了在读取`b`之前，`volA`的读取操作先完成。
    > - `LoadStoreBarrierExample`：在读取`volA`之后，隐式地插入了一个`LoadStore`屏障，这确保了在写入`b`之前，`volA`的读取操作先完成。
    > - `StoreLoadBarrierExample`：在写入`a`之后，隐式地插入了一个`StoreLoad`屏障，这确保了在读取`volA`之前，`a`的写入操作对其他线程可见。
    > 这些注释仅用于说明内存屏障的概念，实际上Java代码不会直接包含这些内存屏障的显式实现。JMM和底层JVM的实现确保了这些屏障的正确插入。
    
23. **问**：synchronized关键字是如何保证原子性和可见性的？
    **答**：synchronized关键字通过在进入代码块前获取锁，确保同一时间只有一个线程可以执行该代码块，从而保证原子性。同时，在解锁前将对共享变量的修改刷新到主内存中，保证可见性 。

24. **问**：什么是锁粗化？
    **答**：锁粗化是一种锁优化原则，如果一系列的连续操作都对同一个对象反复加锁和解锁，会导致不必要的性能损耗，因此可以将这些操作合并成一个范围更大的锁 。

25. **问**：锁粗化有什么好处？
    **答**：锁粗化可以减少频繁的加锁和解锁操作，从而提高程序的执行效率 。

26. **问**：什么是锁消除？
    **答**：锁消除是一种JVM优化技术，如果确定一个同步块内的代码不会被其他线程访问，那么JVM在运行时可以消除这个同步块的锁 。

27. **问**：锁消除有什么好处？
    **答**：锁消除可以减少不必要的同步开销，提高程序的执行效率 。

28. **问**：什么是轻量级锁？
    **答**：轻量级锁是Synchronized的一种优化形式，它使用CAS操作来代替重量级锁，适用于锁竞争不激烈的情况 。

29. **问**：轻量级锁有什么优点？
    **答**：轻量级锁的优点是相比于重量级锁，它的性能开销更小，适用于锁竞争不激烈的场景 。

30. **问**：什么是偏向锁？
    **答**：偏向锁是Synchronized的一种优化形式，当一个线程多次获取同一个锁时，这个锁会偏向这个线程，减少同步的开销 。

31. **问**：偏向锁有什么优点？
    **答**：偏向锁的优点是当一个线程多次获取同一个锁时，可以减少同步的开销，提高程序的执行效率 。

32. **问**：什么是对象的逃逸分析？
    **答**：逃逸分析是一种JVM优化技术，分析对象的作用域，如果确定对象不会被其他线程访问，那么可以考虑将这个对象的内存分配在栈上而不是堆上 。

33. **问**：逃逸分析有什么好处？
    **答**：逃逸分析可以减少堆内存的使用，降低垃圾回收的压力，提高程序的执行效率 。

34. **问**：什么是栈上分配？
    **答**：栈上分配是一种内存分配策略，将对象的内存分配在栈上，而不是堆上，可以减少垃圾回收的压力 。

35. **问**：栈上分配有什么优点？
    **答**：栈上分配的优点是可以减少堆内存的使用，降低垃圾回收的压力，提高程序的执行效率 。

36. **问**：什么是双重检查锁定？
    **答**：双重检查锁定是一种优化单例模式实现的技术，通过两次检查确保单例对象只被创建一次，同时减少同步的开销 。

37. **问**：双重检查锁定有什么优点？
    **答**：双重检查锁定的优点是可以减少同步的开销，提高程序的执行效率，同时确保单例对象只被创建一次 。

38. **问**：什么是指令级别的并行？
    **答**：指令级别的并行是指现代处理器采用的技术，可以将多条指令重叠执行，提高处理器的执行效率 。

39. **问**：指令级别的并行有什么好处？
    **答**：指令级别的并行可以提高处理器的执行效率，使得多条指令可以同时执行，提高程序的执行速度 。

40. **问**：什么是内存系统的重排序？
    **答**：内存系统的重排序是由于处理器使用缓存和读写缓冲区，使得加载

### 1.CPU为什么有可见性问题？为什么CPU要乱序执行

>
>   在[浅谈java内存模型](http://mp.weixin.qq.com/s?__biz=MzI2NzQ0OTMzMQ==&mid=2247483660&idx=1&sn=ecf41b599949b8801307323c2f3ce8c3&chksm=eaffe790dd886e8645ba323ba7d7709e5d8e300ced6181a0960953becaba455d803dc2cbb348&scene=21#wechat_redirect)中，线程的读写都是跟工作内存打交道。而每个线程有自己的工作内存，同一个变量可能在多个工作内存中存在，在一个线程修改变量后，就会出现其他线程的工作内存里还存着该变量的旧值，即其他线程不能看到该变量的最新值，即出现了**可见性**的问题。
>
>   线程的背后是CPU在运行，CPU本身存在可见性和乱序执行的问题，导致让java抽象出了工作内存的概念。
>
>   所以，本文试图讲明白以下几个问题：
>
>   **1. CPU为什么存在可见性问题**
>
>   **2. CPU内部缓存结构是什么样的？**
>
>   **3. CPU如何解决可见性问题？**
>
>   
>
>   首先，从问题就可以看出来，CPU存在缓存。
>
>   那CPU为什么需要缓存？ 
>
>   由于现代硬件设备的不断发展，**CPU的运算速度远大于内存的读写速度**，所以CPU设计中，在CPU和内存中间，添加了各种缓存，来缓解两者速度不匹配的矛盾。（CPU缓存是SRAM做的，SRAM的特点就是非常的昂贵，而内存是用DRAM做的，所以内存跟不上CPU的速度还有钱的问题😅）

#### A.缓存结构

![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8NnI3icx3H4tInq0WZB5haDbF4BOGAkwv61TvRsd3X94OE16dQEQBWMUSy2vLwd3fXLycrPkKK1iaZ1w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

  如上图所示，CPU缓存是一个多行两列的结构。

  多行的实质是一个硬件hash结构，根据内存的地址，映射到上图中的某一行。比如内存地址0x12345E00映射到0xE行。

  而两列则是避免一出现hash冲突就淘汰原内容而增设 备用列。

  通过这样一个多行两列的结构，根据内存地址实现了缓存的功能。

  CPU缓存存储中的最小单位，我们将它称之为 缓存行。（你可以理解为上图中的一个单元格）。

  那缓存行它一次缓存多大的数据呢？

  缓存行的大小是2的整数幂个连续字节，一般为32-256个字节。最常见的缓存行大小是64个字节。在缓存某个变量的时候，会把该变量周边的连续内存凑成缓存行相等的大小进行缓存。（这带来了伪共享问题，对，就是disruptor中说的伪共享）

  而站在整体的角度，CPU是存在多级缓存（一般3-4级缓存）。这里我们先不考虑多久缓存的情况，给出一个简陋的缓存结构图，如下图所示：

![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8NnI3icx3H4tInq0WZB5haDbFx3m6SFxalkfpv0dKEf9qOl5sShOv9uldM8oKQYCWzvd5P0M00QW6pw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如上图所示，

  每个CPU都有属于自己的缓存（Cache），CPU会直接访问缓存，由缓存跟内存（Memory）进行交互。

  CPU在读变量时，先从缓存里读取变量内容，当缓存发现没有该变量，会从内存中加载变量内容到缓存中，从而cpu读取到变量内容。

  而CPU在写变量时，会把修改信息写到缓存中，再从缓存回写到内存中。

  在我们平时写代码的时候，一般是使用缓存对数据库的数据进行缓存，会出现缓存的数据和数据库的数据不一致的情况。

  同样，CPU在引入缓存时，由于同一份数据存储了多个地方，也会出现数据不一致的情况。

  所以，CPU引入了缓存一致性协议MESI。

#### B.缓存一致性协议MESI

| 状态 | 描述      |      |                                                              |
| ---- | --------- | ---- | ------------------------------------------------------------ |
| M    | Modified  | 修改 | 当前数据有效，数据已被修改，和内存中的数据不一样，数据只存在当前CPU的缓存中。 |
| E    | Exclusive | 独享 | 当前数据有效，数据和内存中的数据一致，只有当前CPU的缓存中有该数据。 |
| S    | Shared    | 共享 | 当前数据有效，数据和内存中的数据一致，多个CPU的缓存中有该数据。 |
| I    | Invalid   | 无效 | 当前数据无效                                                 |

 举个例子：

  当只有CPU0访问变量a时，则此时CPU0的缓存中变量a状态为E（独享） 

  而此时CPU1也访问变量a，则此时CPU0和CPU1的缓存中变量a状态都置为S（共享）

  然后CPU0修改变量a,则CPU1的缓存中变量a的状态从S（共享）变成I（无效），CPU0的状态从S（共享）变成M（修改）。

  最后CPU0缓存里修改后的变量a信息同步给内存，此时CPU0的缓存状态从M（修改）变成E（独享）。

 CPU通过在消息总线上传递message进行沟通。主要有以下几种消息：

| 消息                  | 含义                                                         |
| --------------------- | ------------------------------------------------------------ |
| Read                  | 带上数据的物理内存地址发起的读请求消息                       |
| Read Response         | Read 请求的响应信息，内部包含了读请求指向的数据              |
| Invalidate            | 该消息包含数据的内存物理地址，意思是要让其他如果持有该数据缓存行的 CPU 直接失效对应的缓存行 |
| InvalidateAcknowledge | CPU 对Invalidate 消息的响应，目的是告知发起 Invalidate 消息的CPU，这边已经失效了这个缓存行啦 |
| Read Invalidate       | Read 和 Invalidate 的组合消息，与之对应的响应自然就是一个Read Response 和 一系列的 Invalidate Acknowledge |
| Writeback             | 该消息包含一个物理内存地址和数据内容，目的是把这块数据通过总线写回内存里 |

#### C.Store Buffers

此时，我们会发现一个问题，当多个CPU共享某个变量时，假如其中一个CPU要修改变量时，则它会广播Invalidate消息，然后等待其他CPU把变量置为失效后响应Invalidate Acknowledge。如下图所示：

![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8Nnzib7nLPibiaRica8CQw4zZfdUia93p5Pog2yiblwUC6QRKcQWZQhy3JeA1DXtAlf080lQQeC4DsnmL6bA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

也就是说，CPU会有一个空等期。所以CPU引入了store buffers。然后，CPU缓存结构图就变成下面这样:

![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8Nnzib7nLPibiaRica8CQw4zZfdUYQokfNjM0bXy7LCQUyGazPVHzq7tAbQ0QTGM9MAFCUBiawvkzOZ23mA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

 在CPU进行变量的写操作时，Store Buffer 是CPU和Cache之间的缓冲区。CPU无需真正的把变量修改写到缓存中，无需等待其他CPU的反馈，而是写到Store Buffer 就不管了继续执行。

  Store Buffer 避免的CPU的空等。简单理解，Store Buffer 把CPU修改变量写缓存的操作从同步变成了异步。

  但是，在引入了Store Buffer后，CPU读取变量时，如果直接从缓存中读取，则可能出现 Store Buffer中存在已修改的变量，但是缓存中还是旧的数据。即又出现了可见性的问题。

   所以，CPU会先从Store Buffer中读取，Store Buffer中不存在再从缓存中读取，这种机制叫做Store Forwarding。

  缓存结构图更改如下图所示：

  ![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8Nnzib7nLPibiaRica8CQw4zZfdUqcECI6HxRIKiaeU3AQTDerNkNpeiaXGwGrkUXmiaqKtesHWOoUibT00uUw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

  这样能**保证在**单个 CPU 进行顺序执行指令的过程的可见性。  

  Store Forwarding 解决了单个 CPU 执行顺序性和内存可见性问题，但是对于其他CPU来说，依然存在可见性的问题。

  举个例子：

```c

void foo(void)
{
 a = 1;
 b = 1;
}

void bar(void)
{
 while (b == 0) continue;
 assert(a == 1);
}
/*
假设CPU 0执行foo()方法，CPU 1执行bar()方法。变量a,变量b初始化值为0。再假设变量a被CPU 1所缓存，变量b被CPU 0所缓存。
   整个过程可能如下：
    1. CPU 0执行a = 1。缓存行不在CPU 0的缓存，因此CPU 0设置变量a的新值到CPU 0的缓存中并发送“Read Invalidate”消息。
    2. CPU 1执行while（b == 0）continue，但是CPU 1的缓存中不包含变量b。它因此发送“Read”消息。
    3. CPU 0执行b = 1。由于CPU 0的缓存中有变量b，且状态是Exclusive或Modified，因此它直接更新变量b的新值在其对应缓存行中。
    4. CPU 0接收到CPU 1的“ Read”消息，然后发送变量b的新值给CPU 1，并将该缓存行状态修改Shared。
    5. CPU 1接收变量b的新值存放在其缓存中。
    6. CPU 1现在完成了while（b == 0）continue语句的执行，因为它发现了变量b为1，进入下一个语句。
    7. CPU 1执行assert（a == 1），并且由于CPU 1的缓存中存放的是变量a的旧值，此时断言失败，a == 1结果为false。
    8. CPU 1收到CPU 0的Read Invalidate消息，把变量a的缓存行信息发送给CPU 0，并将自身变量a对应的缓存行置为Invalid。但是为时已晚。

    在上述例子里，造成断言失败的原因，是因为变量a的修改对于CPU 1来说，是不可见的。对于CPU1来说，foo()方法的执行从逻辑上来说就是乱序的，此时逻辑上foo()先执行了b=1再执行a=1。要解决上述的问题，要依靠内存屏障。
*/
```

#### D.内存屏障

  由于cpu并不能知道哪些变量之间存在逻辑关系，所以CPU的设计人员提供了内存屏障，让开发人员通过设置内存屏障来告诉CPU这些关系。

  什么是内存屏障？第一次听到这个名字的时候，我觉得这个名字太抽象了。

  简单来说，**我们可以把内存屏障理解为一个CPU指令，通过这个指令，我们在代码逻辑中告诉CPU此时需要严谨的可见性。**

  在添加了内存屏障后，上述例子的代码就变成：

```cpp

void foo(void)
{
 a = 1;
 smp_mb();
 b = 1;
}

void bar(void)
{
 while (b == 0) continue;
 assert(a == 1);
}
```

 smp_mb()这行代码就是我们的内存屏障。

  我们再来回顾下问题，不同CPU之间存在可见性问题的原因，是因为CPU引入了store buffers，把修改变量同步缓存这一动作从同步变成了异步。

  在变量a =1代码后面添加一个smp_mb()代码的作用，会导致 CPU 在后续变量写入之前，把 Store Buffers 的内容同步到CPU缓存。此时CPU 要嘛等待同步缓存的操作完成，要么就把后续的写入操作也放到 Store Buffers 中，直到 Store Buffers 数据顺序刷到缓存。

  即**通过加入屏障的方式，抵消了加入store buffers带来的问题，把修改变量同步缓存这一动作从异步又改回了同步**。

#### E.Invalidate Queues

  我们来回顾下修改变量同步缓存这个操作做了什么事情。假设cpu0在修改变量时，它需要向其他cpu广播Invalidate消息，然后等待其他CPU把该变量对应的缓存置为失效后返回Invalidate Acknowledge消息。

  由于Store Buffer的容量很小，而如果修改的变量个数超过了Store Buffer的容量，此时CPU会等待Store Buffer的空间腾出，即CPU还是会出现空等现象。

  为了尽量避免Store Buffer的容量被填满的情况，CPU引入Invalidate Queues。在Invalidate Queues之后，cpu在收到Invalidate消息时，不会真正地去把变量对应缓存行置为无效，而是马上响应Invalidate Acknowledge消息。

  缓存结构图更改如下图所示：

![图片](https://mmbiz.qpic.cn/mmbiz_png/Zsrhs1ZR8Nk1ibL8egcvfDsO9rbbzvb5JE1k4qmhwNRox8McjJGV0f3DOMBCGG98gZVgzJamOOIgUCrLTamGz4Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

  引入了Invalidate Queue后，Invalidate Acknowledge的时延减小了，即对于修改变量从Store Buffer同步到缓存的时延就减小了，即CPU的空等现象就减少了。

  引入了Invalidate Queue后，虽然提升cpu的效率，但是也带来了新的可见性问题。

  再来看之前加入内存屏障后的代码例子

```cpp

void foo(void)
{
 a = 1;
 smp_mb();
 b = 1;
}

void bar(void)
{
 while (b == 0) continue;
 assert(a == 1);
}
```

  假设CPU 0执行foo()方法，CPU 1执行bar()方法。

  变量a,变量b初始化值为0。再假设变量a被CPU 0和CPU 1所缓存，变量b被CPU 0所缓存。

整个过程可能如下：

1. CPU 0执行a = 1。变量a在CPU 0的缓存状态为Shared，所以CPU 0设置变量a的新值到CPU 0的缓存中并发送“Invalidate”消息。
2. CPU 1收到 invalidate消息，将其放入Invalidate Queue，并向CPU 0发出Invalidate Acknowledge消息。注意，变量a的旧值仍保留在CPU 1的缓存。
3. CPU 0 收到Invalidate Acknowledge后，把 a=1 从 Store Buffer 刷到缓存中。
4. CPU 0执行b = 1。由于CPU 0的缓存中有变量b，且状态是Exclusive或Modified，因此它直接更新变量b的新值在其对应缓存行中。
5. CPU 1执行while（b == 0）continue，但是CPU 1的缓存中不包含变量b。它因此发送“Read”消息。
6. CPU 0接收到CPU 1的“ Read”消息，然后发送变量b的新值给CPU 1，并将该缓存行状态修改Shared。
7. CPU 1接收变量b的新值存放在其缓存中。
8. CPU 1现在完成了while（b == 0）continue语句的执行，因为它发现了变量b为1，进入下一个语句。
9. CPU 1执行assert（a == 1），并且由于CPU 1的缓存中存放的是变量a的旧值，此时断言失败，a == 1结果为false。
10. CPU 1处理Invalidate Queue中的Invalidate消息，将自身变量a对应的缓存行置为Invalid。但是为时已晚。

 

  以上就是引入Invalidate Queue之后造成的可见性问题。解决的办法，还是使用内存屏障。

```cpp

void foo(void)
{
 a = 1;
 smp_mb();
 b = 1;
}

void bar(void)
{
 while (b == 0) continue;
 smp_mb();
 assert(a == 1);
}
```

  如上所示，在assert（a == 1）断言之前加入smp_mb()。这个地方的内存屏障有着更丰富的语义，它会先把 Invalidate Queue 的消息全部标记，并且**强制要求 CPU 必须等待 Invalidate Queue 中被标记的失效消息真正应用到缓存后才能执行后续的所有读操作**。

#### F.读写内存屏障

  再看上面的代码例子中，其实foo方法中的smp_mb只需要处理store Buffer，不需要处理Invalidate Queue。而bar方法中的smp_mb只需要处理Invalidate Queue而不需要处理Store Buffer。所以cpu的设计者把smp_mb（内存屏障）进行了功能上的拆分，分别拆分成smp_rmb(读内存屏障)和smp_wmb（写内存屏障）。

  此时，上述例子就变成了：

```cpp

void foo(void)
{
 a = 1;
 smp_wmb();
 b = 1;
}

void bar(void)
{
 while (b == 0) continue;
 smp_rmb();
 assert(a == 1);
}
```

smp_wmb（写内存屏障）：**执行后会等待Store Buffer把写入同步到缓存中才能执行后续的写操作。**由于该动作会向其他CPU发送Invalidate消息，即 smp_wmb之前的写操作能被其他CPU所感知。使用 写内存屏障 指令可以保证前后写操作之间的顺序性。   

  smp_rmb(读内存屏障)：**执行后会等待Invalidate Queue的失效消息生效到缓存中才能执行后续的读操作。**该操作会使Invalidate消息对应的缓存真正失效。使用 读内存屏障 指令可以保证前后读操作之间的顺序性。

  通过对内存屏障进行功能上的划分，提供更轻量级，性能消耗更小的指令，可在适当场景使用适当的指令，做到保证可见性的同时最小化性能开销。

#### G.总结

  我们梳理下本篇文章的内容和逻辑：

1. 由于CPU访问内存的速度太慢，所以在CPU和内存中间加了缓存。
2. 由于加入了缓存，导致出现数据不一致的问题，进而使用了MESI缓存一致性协议。
3. 由于缓存一致性协议中修改数据同步通知其他CPU会大大降低性能，所以引入Store Buffers和Invalidate Queues，把这个通知动作异步化。
4. 由于通知异步化后一样会出现数据不一致的问题，所以出现了内存屏障。

  从上述我们可以看出CPU的设计者是如何在性能和数据一致性问题（可见性）中做权衡的。

  **最终CPU的方案就是尽可能的提高CPU的性能（性能优先）**，会牺牲内存可见性，会对指令进行乱序执行，它认为大部分的程序我们都不需要关心可见性和乱序问题。

  而对于少部分关心可见性和乱序问题的程序，可**通过在代码中插入内存屏障指令的方式，牺牲CPU性能去获得内存可见性以及禁止乱序执行的特性**。

  内存屏障带来了代码上的侵入性，但是也提供了CPU的控制机制，让开发者自己在性能和可见性之间做抉择。

  **再聊聊CPU的乱序执行：**绝大多数的CPU为了提高性能，可以不等待指令结果就执行后面的指令，如果前后指令不存在数据依赖的话。乱序执行不会影响单个CPU的执行结果，但对其他CPU来说就有可能产生不可预估的影响。

  我们可以发现，**CPU的内存可见性问题和指令乱序问题，其实从某种意义看，两者其实是一码事。**

  当一个CPU的值修改对于另一个CPU来说不可见时，此时站在另一个CPU的视角上看，该CPU指令就像是被乱序执行了。而当指令被乱序执行后，一样会产生内存的可见性问题。

  写在最后，CPU的架构方案也在不断的演进。本文通篇讲述的CPU架构适用于**SMP(对称多处理器架构)**。对于其他CPU架构（比如NUMA）可能架构差异较大，但是架构设计的出发点都是为了性能。
