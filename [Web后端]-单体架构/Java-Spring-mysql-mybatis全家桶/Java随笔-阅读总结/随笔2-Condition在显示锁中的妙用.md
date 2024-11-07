# 1.代码例子

```java
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Main {
    static Lock lock = new ReentrantLock();
    static private Condition condition = lock.newCondition();
    static class WaitTarget implements  Runnable{
        public void run(){
            lock.lock();
            try{
                System.out.println("我是等待方");
                condition.await();
                System.out.println("收到通知，等待方继续执行");

            }catch(InterruptedException e){
                e.printStackTrace();
            }finally {
                lock.unlock();
            }
        }
    }
    static class NotifyTarget implements  Runnable{
        public void run(){
            lock.lock();
            try{
                System.out.println("我是通知方");
                condition.signal();
                System.out.println("我发出通知了，但是线程还没立马释放锁");
            }finally {
                lock.unlock();
            }
        }
    }
    public static void main(String[] args){
       //创建等待线程
        Thread waitThread = new Thread(new WaitTarget());
        waitThread.start();
        //创建通知线程
        Thread notifyThread = new Thread(new NotifyTarget());
        notifyThread.start();
        
    }
}

```

# 2.相同点分析

在Java中，`Lock`和`synchronized`都是用于实现线程间的同步机制，它们都有等待-通知机制，但在实现和使用上存在一些差异和相似之处。

### 相同性

1. **目的**：两者都用于控制对共享资源的访问，防止线程间的数据不一致。
2. **等待-通知机制**：两者都支持线程的等待（wait）和通知（notify）机制。线程可以在条件不满足时等待，并在条件满足时被唤醒。

### 差异性

1. **实现方式**：
   - **synchronized**：Java的内置锁，使用关键字` synchronized`进行标记。它会自动获取和释放锁，具有较高的便利性，但在异常发生时，锁的释放也是自动的。
   - **Lock**：是一个更灵活的锁实现，属于`java.util.concurrent.locks`包。使用时需要显式调用`lock()`和`unlock()`方法，提供了更细粒度的控制。

2. **条件变量**：
   - **synchronized**：使用`Object.wait()`、`Object.notify()`、`Object.notifyAll()`进行等待-通知，条件变量的控制相对简单。
   - **Lock**：提供了`Condition`接口，可以创建多个条件变量，更灵活地控制不同的等待-通知机制。例如，可以为不同的条件创建不同的`Condition`对象，进行精确控制。
     - `Condition`的`condition.await`等价于`synchronized`中的`Object.wait`
     - `Condition`的`condition.signal`等价于`synchronized`中的`Object.notify`
     - `Condition`的`condition.signalAll`等价于`synchronized`中的`Object.notifyAll`
     - 对应的原因是：JUC的设计者不希望JUC中的等待-通知机制的API和JVM提供的产生命名冲突。因此选择了相近的单词做为API名
   
3. **可中断性**：
   - **synchronized**：在等待锁时不可中断，除非线程被中断。
   - **Lock**：提供了可中断的`lockInterruptibly()`方法，允许在等待锁时响应中断。

4. **公平性**：
   - **synchronized**：没有公平性保证。
   - **Lock**：可以选择公平锁（`new ReentrantLock(true)`），保证线程按照请求锁的顺序获得锁。

### 使用Lock的模板注意事项

1. **确保释放锁**：在使用`Lock`时，必须确保在finally块中调用`unlock()`，以避免在异常发生时导致死锁。
   ```java
   Lock lock = new ReentrantLock();
   try {
       lock.lock();
       // 访问共享资源
   } finally {
       lock.unlock();
   }
   ```

2. **使用Condition**：在需要多个条件变量的场景下，使用`Condition`接口，需注意调用`await()`时会释放锁，并在被唤醒时重新获取锁。
   ```java
   Condition condition = lock.newCondition();
   lock.lock();
   try {
       while (/* condition not met */) {
           condition.await(); // 释放锁，等待通知
       }
       // 处理条件满足的情况
   } finally {
       lock.unlock();
   }
   ```

3. **可中断的锁**：在可能需要中断的场合，使用`lockInterruptibly()`，确保能够响应中断。
   ```java
   try {
       lock.lockInterruptibly();
       // 访问共享资源
   } catch (InterruptedException e) {
       // 处理中断
   } finally {
       lock.unlock();
   }
   ```

### 总结

`Lock`和`synchronized`各有优缺点，选择使用哪种机制取决于具体的应用场景。对于简单的同步场景，`synchronized`足够且易用；而在复杂的线程交互或高性能需求下，`Lock`提供的灵活性和功能会更有优势。