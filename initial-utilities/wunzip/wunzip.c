#include <stdio.h>

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("wunzip: file1 [file2 ...]\n");
        return 1;
    }
    for (int j = 1; j < argc; j++)
    {
        FILE *fp = fopen(argv[j], "r");
        if (fp == NULL)
        {
            printf("wunzip: cannot open file\n");
            return 1;
        }
        int count;
        char c;
        while (fread(&count, sizeof(int), 1, fp) && fread(&c, sizeof(char), 1, fp))
        {
            for (int i = 0; i < count; i++)
            {

                printf("%c", c);
            }
        }
    }
    return 0;
}