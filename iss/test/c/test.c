
#include "printf.h"

void _putchar (char c)
{
    char* p = (char*) 0x80000000;
    
    *p = c;
}

int func (int in)
{
    return in * in;
}

static char buf[1024];

int main (int args, int**argv)
{
    unsigned val = 0;
    
    for(int i = 1; i <= 10; i++)
    {
        val += func(i);
    }
    
    printf("val = %d\n", val);

    return 0;

}