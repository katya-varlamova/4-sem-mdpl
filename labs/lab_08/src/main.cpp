#include <stdio.h>

extern "C"
{
void strc(char *dst, char *src, int size);
}
int strlen(char *str)
{
    int count = 0;
    __asm__("xor %%rcx, %%rcx\n"
            "movl $100, %%ecx\n"
            "mov %1, %%rdi\n"
            "xor %%al, %%al\n"
            "repne scasb\n"
            "mov $100, %%eax\n"
            "sub %%ecx, %%eax\n"
            "dec %%eax\n"
            "movl %%eax, %0\n"
    : "=r"(count): "r"(str)
    );
    return count;
}
int main() {
    int i;
    char a[100] = "abcde";
    char b[100] = "aff";
    int l = strlen(a);
    printf("%d\n", l);
    strc(&a[2], a, l);
    printf("%s\n", a);
    printf("%s\n", &a[2]);
    return 0;
}

