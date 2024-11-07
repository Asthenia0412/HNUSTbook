#include<stdio.h>
#include<ctype.h>
void test_type(char c){
    //判断是否是十进制数字
    if(isdigit(c)){
        printf("wow,%c 这是一个十进制数字\n",c);
    }
    //判断是否是十六进制数字
    if(isxdigit(c)){
        printf("wow,%c 这是一个十六进制数字\n",c);
    }
    //判断是否是小写字母
    if(islower(c)){
        printf("wow,%c 这是一个小写字母\n",c);
    }
    //判断是否是大写字母
    if(isupper(c)){
        printf("wow,%c 这是一个大写字母\n",c);

    }
    //判断是否是普通字母
    if(isalpha(c)){
        printf("wow,%c 这是一个普通的字母\n",c);
    }
    //判断是否是标点符号
    if(ispunct(c)){
        printf("wow,%c 这是一个标点符号\n",c);
    }
    //判断是否为空白字符
    if(isspace(c)){
        printf("wow,%c 这是一个空白符号\n",c);
    }
    //判断是否是可打印字符
    if(isprint(c)){
        printf("wow,%c 这是一个可打印字符\n",c);
    }
    //判断是否是控制符号
    if(iscntrl(c)){
        printf("wow,%c 这是一个控制符号\n",c);
    }
}
int main() {
    char c;
    while((c=getchar())!=EOF){
        if((c=='\n')){
            continue;
        }
        test_type(c);
    }
}