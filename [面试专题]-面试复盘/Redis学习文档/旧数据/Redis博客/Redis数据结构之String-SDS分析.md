# 1.先导：

String是最基本的key-value结构，其中key是唯一标识。value为具体的值。而value不仅仅是字符串，也可以是数字(整数or浮点数)。value最多可以容纳的数据长度是512M。

我们关注String类型的底层数据结构实现：

- int
- SDS(Simple Dynamic String)

这里主要介绍SDS，我们先谈优点：

- SDS不仅存储文本数据，可以存储二进制数据
  - SDS的struct Header中使用int len来判断字符串是否结束，而非是传统字符串的`\0`字符
  - SDS的数据存放在struct Header中的char buf[]。得益于buf[]的类型，SDS可以存放图片，音频，视频，压缩文件等二进制数据。`在 C 语言中，`char` 类型表示一个字节（即 8 位），因此 `buf[]` 可以存储任意类型的字节流，无论是文本数据还是二进制数据。具体地，以下几种类型的数据可以存放在 `buf[]``
- SDS获取字符串长度的时间复杂度是O(1)
  - 传统C语言字符串没有记录自身长度，因此需要逐个遍历元素，因此可知时间复杂度是O(n)
  - SDS在struct Header中定义了int len;通过查询该值即可一次拿到字符串的长度，故时间复杂度是O(1)
- Redis的SDS API是安全的，拼接字符串不会造成缓冲流溢出
  - 这是得益于`sdsConcat`方法在拼接前会检查SDS的char[] buf空间是否满足要求，倘若空间不足会自动扩容。

# 2.SDS代码中使用到的API

这段代码使用了多个常见的 C 语言标准库 API 来进行内存管理、字符串操作和输出等。我们逐一分析这些 API 和它们的用途。

## 1. **`strlen`**
   ```c
   size_t init_len = strlen(init);
   ```
   `strlen` 是一个标准的 C 库函数，用于计算字符串的长度，不包括字符串的结束符 `'\0'`。它的定义如下：
   ```c
   size_t strlen(const char *str);
   ```
   其中 `str` 是一个指向 C 风格字符串的指针。`strlen` 返回字符串的长度（类型为 `size_t`）。

   - 在这段代码中，`strlen(init)` 用来获取初始化字符串 `init` 的长度，用来为 SDS 分配足够的内存空间。

## 2. **`malloc`**
   ```c
   struct SDSHeader *sds = (struct SDSHeader *)malloc(sizeof(struct SDSHeader) + init_len + 1);
   ```
   `malloc` 是 C 标准库中的内存分配函数。它从堆内存中分配指定大小的内存块，并返回该内存块的起始地址。如果分配失败，则返回 `NULL`。

   - `malloc(sizeof(struct SDSHeader) + init_len + 1)` 为 SDS 结构体和字符串缓冲区分配内存。`init_len + 1` 是为了存储字符串内容和一个额外的结束符 `'\0'`。

   - 这里需要注意 `malloc` 返回的是一个 `void*` 类型的指针，我们需要通过强制类型转换将其转换为 `struct SDSHeader*` 类型。

## 3. **`strcpy`**
   ```c
   strcpy(sds->buf, init);
   ```
   `strcpy` 用于将一个 C 风格字符串（包括结束符 `'\0'`）复制到另一个字符串缓冲区。函数原型如下：
   ```c
   char *strcpy(char *dest, const char *src);
   ```
   - `dest` 是目标字符串，`src` 是源字符串。
   - 在这段代码中，`strcpy` 将初始化字符串 `init` 复制到 `sds->buf` 中，即将实际的字符串数据填充到分配的缓冲区中。

## 4. **`realloc`**
   ```c
   sds1 = (SDS)realloc(sds1, sizeof(struct SDSHeader) + new_len + 1);
   ```
   `realloc` 用于重新分配内存，可以调整已经分配的内存块的大小。如果扩展了内存，它会尝试将内存块移动到新的位置并返回新地址。函数原型如下：
   ```c
   void *realloc(void *ptr, size_t size);
   ```
   - `ptr` 是指向原始内存块的指针，`size` 是新的内存块大小。
   - `realloc` 如果成功会返回一个新的指针，指向重新分配的内存。如果失败，它会返回 `NULL`，并且原来的内存块保持不变。

   - 在这段代码中，`realloc` 被用来扩展 SDS 字符串缓冲区的大小，以容纳两个字符串连接后的新内容。如果 `sdsavail(sds1)` 检测到空间不足，就调用 `realloc` 来增加内存。

## 5. **`strcat`**
   ```c
   strcat(sds1->buf, s2);
   ```
   `strcat` 是 C 标准库中用于连接两个字符串的函数，函数原型如下：
   ```c
   char *strcat(char *dest, const char *src);
   ```
   - `dest` 是目标字符串，`src` 是要连接到目标字符串的源字符串。
   - `strcat` 会将 `src` 字符串追加到 `dest` 字符串的末尾，并在末尾添加 `'\0'` 字符。

   - 在这段代码中，`strcat(sds1->buf, s2)` 将字符串 `s2` 追加到 `sds1->buf` 中，即连接两个 SDS 字符串。

## 6. **`printf`**
   ```c
   printf("SDS string: %s\n", sds->buf);
   printf("Length: %u\n", sdslen(sds1));
   printf("Available space: %u\n", sdsavail(sds1));
   ```
   `printf` 是 C 标准库中用于格式化输出的函数，原型如下：
   ```c
   int printf(const char *format, ...);
   ```
   - `format` 是格式字符串，后面跟着可变参数，`printf` 会根据格式字符串输出对应的数据。
   - `%s` 是一个格式化占位符，用于输出一个 C 风格字符串。
   - `%u` 用于输出无符号整数。

   - 在这段代码中，`printf` 被用来输出 SDS 字符串内容、字符串的长度以及可用空间。

## 7. **`free`**
   ```c
   free(sds);
   ```
   `free` 用于释放通过 `malloc` 或 `realloc` 分配的内存。函数原型如下：
   ```c
   void free(void *ptr);
   ```
   - `ptr` 是指向要释放的内存块的指针。释放内存后，指针不再有效。

   - 在这段代码中，`freeSDS` 函数释放了通过 `malloc` 或 `realloc` 分配的 SDS 结构体及其缓冲区的内存。

---

## 总结：
- **内存管理**：`malloc` 和 `realloc` 用于分配和重新分配内存，`free` 用于释放内存。
- **字符串操作**：`strlen` 用于获取字符串长度，`strcpy` 用于复制字符串，`strcat` 用于连接字符串。
- **输出**：`printf` 用于格式化输出信息。

这些 C 标准库函数在处理动态内存管理和字符串操作时非常常见，是 C 语言开发中不可或缺的工具。

# 3.代码与分析

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// SDS 的结构体定义
struct SDSHeader {
    unsigned int len;       // 字符串的长度，不包括空字符
    unsigned int alloc;     // 已分配的空间（包括字符串末尾的空字符）
    unsigned char flags;    // 标志位，通常用来标记 SDS 的类型（简单或二进制）
    char buf[];             // 存放字符串内容的缓冲区
};

typedef struct SDSHeader *SDS;

// 创建一个新的 SDS 字符串
SDS createSDS(const char *init) {
    size_t init_len = strlen(init); // 初始化字符串的长度
    struct SDSHeader *sds = (struct SDSHeader *)malloc(sizeof(struct SDSHeader)+init_len+1);
    // if (!sds) return NULL;

    sds->len = init_len;
    sds->alloc = init_len + 1;  // 为结束符 '\0' 分配空间
    sds->flags = 0;  // 初始化标志位
    strcpy(sds->buf,init); // 将初始化字符串复制到缓冲区

    return sds;
}

// 获取 SDS 字符串的长度
unsigned int sdslen(SDS sds) {
    return sds->len;
}

// 获取 SDS 字符串分配的内存大小
unsigned int sdsavail(SDS sds) {
    return sds->alloc - sds->len - 1;
}

// 释放 SDS
void freeSDS(SDS sds) {
    if (sds) {
        free(sds);
    }
}

// 连接两个 SDS 字符串
SDS sdsConcat(SDS sds1, const char *s2) {
    size_t s2_len = strlen(s2);
    size_t new_len = sdslen(sds1) + s2_len;
    if (sdsavail(sds1) < s2_len) {  // 如果空间不足，需要扩展
       sds1 = (SDS)realloc(sds1,sizeof(struct SDSHeader)+new_len+1);
        if (!sds1) return NULL;  // 内存分配失败
        sds1->alloc = new_len + 1;
    }

    strcat(sds1->buf, s2);  // 连接字符串
    sds1->len = new_len;    // 更新 SDS 长度

    return sds1;
}

// 打印 SDS 字符串
void printSDS(SDS sds) {
    printf("SDS string: %s\n", sds->buf);
}

int main() {
    // 创建一个 SDS 字符串
    SDS sds1 = createSDS("Hello");
    printSDS(sds1);
    printf("Length: %u\n", sdslen(sds1));
    printf("Available space: %u\n", sdsavail(sds1));

    // 连接另一个字符串
    sds1 = sdsConcat(sds1, " World!");
    printSDS(sds1);
    printf("Length: %u\n", sdslen(sds1));
    printf("Available space: %u\n", sdsavail(sds1));

    // 释放内存
    freeSDS(sds1);

    return 0;
}
```

# 4.SDS好就好在没有`\0`

我相信你在阅读完上述的博文后，会产生一个疑问：**SDS和传统C字符串都是用char[]来存数据，凭什么说SDS能存图片，音频，视频是相较于传统的优点呢？**

**答案在于对于`\0`的处理**



## 1. **传统 C 字符串的限制**

传统的 C 字符串（`char` 数组）有以下一些限制，使得它们在存储二进制数据时不那么方便：

- **以 null 字符 `\0` 结尾：** C 字符串是以 `\0`（null 字符）结尾的，表示字符串的结束。这意味着，当我们试图存储含有 `\0` 字符的数据（比如图片或文件的二进制数据）时，C 字符串会认为 `\0` 后的部分是无效数据，从而导致数据丢失或不完整。

  例如，如果图片文件的二进制数据中有字节 `0x00`，传统 C 字符串会误认为这就是字符串的结尾，而无法正确存储剩下的数据。

- **没有内存管理信息：** 传统的 C 字符串没有内置的机制来管理内存的使用情况，也没有记录字符串实际存储的长度。这就导致了管理动态内存时的复杂性，尤其是在需要处理更大数据（如二进制数据）时，开发者需要自己进行额外的内存管理。

## 2. **SDS 的优点**

SDS（简单动态字符串）是 Redis 中的一种数据结构，它改进了传统 C 字符串的一些缺点。SDS 设计之初就是为了更好地支持字符串操作（包括二进制数据）。它的主要优点包括：

- **二进制安全：**
  SDS 可以存储任意字节的数组，包括 `0x00` 这样的字节。由于 SDS 是基于长度前缀和容量前缀的机制，它并不依赖于 `\0` 来标识字符串的结束，因此可以安全地存储二进制数据（包括包含 `\0` 的数据）。这使得 SDS 可以用来存储图片、音频、加密数据等任意二进制数据。

- **内存管理：**
  SDS 内部有明确的内存结构，包含了三个字段：
  
  - `len`: 记录当前字符串的实际长度（不包括结束符 `\0`）。
  - `free`: 记录当前可用的空闲空间（即可以在不重新分配内存的情况下扩展字符串的长度）。
  - `buf`: 实际存储数据的缓冲区（用于存储字符串或二进制数据）。
  
  这种设计使得 SDS 不仅可以有效地管理动态字符串的内存，还可以通过预留空闲空间来减少内存重分配的频率，提升性能。
  
- **快速扩展：**
  与传统 C 字符串不同，SDS 允许通过简单的重分配来扩展字符串长度，并且能够高效地管理内存。每次分配新的内存时，SDS 会考虑到扩展的需求，预留一定的空间，以减少频繁的内存重分配，避免性能瓶颈。

- **避免了传统 C 字符串的 "O(n)" 操作：**
  传统 C 字符串在进行拼接操作时，通常需要复制整个字符串来扩展空间（例如 `strcat`），这是一种 `O(n)` 的操作。而 SDS 在扩展时仅仅是更新长度信息和内存块大小，不需要每次操作时都复制数据，从而大大提高了操作效率。

## 3. **存储二进制数据的优势**

SDS 的二进制安全性是它相对于传统 C 字符串的最大优势之一。传统 C 字符串无法处理包含 `\0` 的数据，因此不适合用来存储二进制文件内容（如图片、视频、音频等）。而 SDS 可以存储包括 `\0` 在内的任意字节，这使得它非常适合处理二进制数据。

例如，如果你需要存储一个图片文件的二进制数据，并且这个文件中可能包含很多 `0x00` 字节，传统 C 字符串将无法处理这个问题，数据可能被截断。使用 SDS，你可以安全地存储整个二进制数据，不会遇到截断或者丢失的风险。

## 4. **例子**

假设我们需要存储一张图片的二进制数据。如果使用传统 C 字符串，你可能会遇到以下问题：

```c
char image_data[1000];
FILE *file = fopen("image.jpg", "rb");
fread(image_data, 1, 1000, file); // 假设图片数据较大

// 如果图片数据包含 '\0' 字符，传统字符串将会截断数据
printf("Image data: %s\n", image_data); // 可能只打印部分数据，甚至可能打印乱码
```

然而，如果使用 SDS，则可以避免这个问题：

```c
SDS sds_image = sdsnewlen(NULL, 1000);
FILE *file = fopen("image.jpg", "rb");
fread(sds_image, 1, 1000, file); // SDS 可以处理包含 '\0' 的数据

printf("Image data: %s\n", sds_image); // 不会发生截断，二进制数据可以完整存储
```

## 总结

虽然传统的 C 字符串也使用 `char` 来存储数据，但由于 C 字符串必须以 `\0` 结尾，它们并不适合存储二进制数据。SDS 的设计克服了这一问题，支持存储任意二进制数据（包括包含 `\0` 的数据），并且具有更好的内存管理和性能优化。因此，SDS 是一种更加灵活和高效的数据结构，尤其适合在需要处理二进制数据的场景中使用。
