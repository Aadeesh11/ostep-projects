#include <stdio.h>
#include <string.h>
#include <assert.h>
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("wzip: file1 [file2 ...]\n");
        return 1;
    }
    char a = '\0';
    int count = 0;
    for (int j = 1; j < argc; j++)
    {
        FILE *fp = fopen(argv[j], "r");
        if (fp == NULL)
        {
            printf("wzip: cannot open file\n");
            return 1;
        }
        char *line = NULL;
        size_t linecap = 0;
        ssize_t linelen;

        while ((linelen = getline(&line, &linecap, fp)) > 0)
        {
            assert(linelen > 0);
            int len = strlen(line);
            int i;
            if (a == '\0')
            {
                a = line[0];
                count = 1;
                i = 1;
            }
            else
            {
                i = 0;
            }
            while (i < len)
            {
                if (line[i] != a)
                {
                    fwrite(&count, sizeof(int), 1, stdout);
                    fwrite(&a, sizeof(char), 1, stdout);
                    a = line[i];
                    i++;
                    count = 1;
                }
                else
                {
                    i++;
                    count++;
                }
            }
        }
        if (argc == j + 1)
        {
            fwrite(&count, sizeof(int), 1, stdout);
            fwrite(&a, sizeof(char), 1, stdout);
        }
    }
    return 0;
}