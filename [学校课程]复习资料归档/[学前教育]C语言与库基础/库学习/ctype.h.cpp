#include<stdio.h>
#include<ctype.h>
void test_type(char c){
    //�ж��Ƿ���ʮ��������
    if(isdigit(c)){
        printf("wow,%c ����һ��ʮ��������\n",c);
    }
    //�ж��Ƿ���ʮ����������
    if(isxdigit(c)){
        printf("wow,%c ����һ��ʮ����������\n",c);
    }
    //�ж��Ƿ���Сд��ĸ
    if(islower(c)){
        printf("wow,%c ����һ��Сд��ĸ\n",c);
    }
    //�ж��Ƿ��Ǵ�д��ĸ
    if(isupper(c)){
        printf("wow,%c ����һ����д��ĸ\n",c);

    }
    //�ж��Ƿ�����ͨ��ĸ
    if(isalpha(c)){
        printf("wow,%c ����һ����ͨ����ĸ\n",c);
    }
    //�ж��Ƿ��Ǳ�����
    if(ispunct(c)){
        printf("wow,%c ����һ��������\n",c);
    }
    //�ж��Ƿ�Ϊ�հ��ַ�
    if(isspace(c)){
        printf("wow,%c ����һ���հ׷���\n",c);
    }
    //�ж��Ƿ��ǿɴ�ӡ�ַ�
    if(isprint(c)){
        printf("wow,%c ����һ���ɴ�ӡ�ַ�\n",c);
    }
    //�ж��Ƿ��ǿ��Ʒ���
    if(iscntrl(c)){
        printf("wow,%c ����һ�����Ʒ���\n",c);
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