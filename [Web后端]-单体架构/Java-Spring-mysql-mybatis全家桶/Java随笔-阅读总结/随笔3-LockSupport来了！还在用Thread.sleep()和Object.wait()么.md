# 1.代码实战

```java
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.LockSupport;
import java.util.concurrent.locks.ReentrantLock;

public class Main {
    public static class ChangeObjectThread extends Thread {
        public ChangeObjectThread(String name){
            super(name);
        }
        @Override
        public void run(){
            System.out.println("马上进入LockSupport导致的无限时阻塞");
            LockSupport.park();//阻塞当前线程
            if(Thread.currentThread().isInterrupted()){
                System.out.println("LockSupport:虽然发生中断，但是不影响我继续工作！"+Thread.currentThread().getName());
            }else{
                System.out.println("LockSupport:我被重新唤醒咯！"+Thread.currentThread().getName());
            }
        }
    }
    public static void main(String[] args) {
        ChangeObjectThread t1 = new ChangeObjectThread("线程1");
        ChangeObjectThread t2 = new ChangeObjectThread("线程2");
        t1.start();
        t2.start();
        t1.interrupt();
        LockSupport.unpark(t2);
    }


}

```

# 2.API分析

下面是对 `LockSupport` 的 API 及其与 `Thread.sleep` 和 `Object.wait()` 的区别的详细说明：

### 1. LockSupport 的 API

`LockSupport` 是一个用于实现阻塞和唤醒线程的工具类，主要提供以下 API：

- **`static void park()`**: 当前线程被阻塞，直到被其他线程唤醒。
- **`static void park(Object blocker)`**: 当前线程被阻塞，并且可以指定阻塞的原因。
- **`static void unpark(Thread thread)`**: 唤醒指定的线程。如果该线程已经被阻塞，则立即返回，否则它在下次调用 `park` 时将不再被阻塞。
- **`static boolean isBlocked(Thread thread)`**: 判断指定线程是否被阻塞（在某些实现中可用）。

### 2. LockSupport 和 Thread.sleep 的区别

- **用途**:
  - `Thread.sleep(long millis)` 是一个让当前线程休眠指定时间的方法，期间该线程不会占用 CPU，但仍然是“睡眠”状态。
  - `LockSupport.park()` 用于阻塞当前线程，直到被其他线程唤醒，通常用于实现更复杂的线程间通信。

- **唤醒机制**:
  - `Thread.sleep` 会在指定时间后自动返回，或者通过抛出 InterruptedException 响应中断。
  - `LockSupport.park()` 需要其他线程调用 `unpark()` 来显式唤醒。

- **灵活性**:
  - `Thread.sleep` 的阻塞时间是固定的。
  - `LockSupport` 提供了更灵活的控制，可以在需要时进行阻塞和唤醒，适用于生产者-消费者等更复杂的场景。

### 3. LockSupport 和 Object.wait() 的区别

- **调用条件**:
  - `Object.wait()` 必须在同步块或同步方法中调用，并且调用者必须持有对象的监视器。
  - `LockSupport.park()` 不需要持有监视器，可以在任何地方调用。

- **唤醒机制**:
  - `Object.wait()` 通过 `notify()` 或 `notifyAll()` 唤醒等待的线程。
  - `LockSupport.park()` 通过 `LockSupport.unpark(Thread thread)` 唤醒，可以更精确地控制哪个线程被唤醒。

- **中断处理**:
  - `Object.wait()` 会抛出 InterruptedException 当线程被中断。
  - `LockSupport.park()` 不会抛出异常，线程的中断状态不会清除，但可以通过 `Thread.interrupted()` 方法检查。

- **适用场景**:
  - `Object.wait()` 适合用于传统的对象监视器和同步块的场景。
  - `LockSupport` 更适合用于实现自定义的同步结构和高级并发工具。

### 总结

`LockSupport` 提供了更灵活的线程阻塞和唤醒机制，适合用于复杂的多线程场景，而 `Thread.sleep` 和 `Object.wait()` 适合于相对简单的线程控制和同步需求。选择合适的工具可以提高程序的性能和可维护性。
