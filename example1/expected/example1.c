// implicit include for simplec symbol 'say'
#include <stdio.h>

// 'example1.sc':1:5 # "Hello simplec"
static const char* string_1 = "Hello simplec\n\0";

// implicit main function at 'example1.sc':1:1
int main(int argc, char **argv)
{
    // 'example1.sc':1:1 # say(...)
    printf(string_1);

    // implicit exit at 'example1.sc':1:21
    return 0;
}
