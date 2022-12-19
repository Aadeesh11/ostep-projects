#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

struct List
{
    struct List *next;
    char *line;
};

int main(int argc, char *argv[])
{
    if (argc > 3)
    {
        fprintf(stderr, "usage: reverse <input> <output>\n");
        return 1;
    }
    FILE *in, *out;
    if (argc == 2)
    {
        in = fopen(argv[1], "r");
        if (in == NULL)
        {
            fprintf(stderr, "reverse: cannot open file '%s'\n", argv[1]);
            return 1;
        }
        out = stdout;
    }
    if (argc == 1)
    {
        in = stdin;
        out = stdout;
    }
    if (argc == 3)
    {
        if (strcmp(argv[1], argv[2]) == 0)
        {
            fprintf(stderr, "reverse: input and output file must differ\n");
            return 1;
        }
        in = fopen(argv[1], "r");
        if (in == NULL)
        {
            fprintf(stderr, "reverse: cannot open file '%s'\n", argv[1]);
            return 1;
        }
        out = fopen(argv[2], "w");
        if (out == NULL)
        {
            fprintf(stderr, "reverse: cannot open file '%s'\n", argv[2]);
            return 1;
        }
    }
    char *inLine = NULL;
    size_t linecap = 0;
    ssize_t linelen;
    struct List *head = NULL;
    while ((linelen = getline(&inLine, &linecap, in)) > 0)
    {

        struct List *newData = malloc(sizeof(struct List));
        if (newData == NULL)
        {
            fprintf(stderr, "malloc failed\n");
            return 1;
        }
        newData->next = head;
        newData->line = malloc(sizeof(char) * (strlen(inLine) + 1));
        strcpy(newData->line, inLine);
        head = newData;
    }

    struct List *tmp = head;
    while (head != NULL)
    {
        fprintf(out, "%s", head->line);
        head = head->next;
        free(tmp->line);
        free(tmp);
        tmp = head;
    }
    fclose(out);
    fclose(in);

    return 0;
}