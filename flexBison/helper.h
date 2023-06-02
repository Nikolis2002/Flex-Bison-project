#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void add_id(char ***arr, int *size, const char *value);
int id_compare(char **arr, int size);
int checkedButton_checker(char **arr, int size, char *string);
int progress_max(int max, int progress);
void print(char **arr, int size);
void print_program(FILE *yyin);
extern void print_err_program(FILE *yyin, int line);
int fileLinesSize(FILE *file);
void copyString(const char *source, char **destination);

void add_id(char ***arr, int *size, const char *value)
{
    if (*arr == NULL || *size == 0)
    {
        *arr = (char **)malloc(sizeof(char *));
        *size = 1;
    }
    else if (*size > 0)
    {
        *arr = (char **)realloc(*arr, (*size + 1) * sizeof(char *));
        (*size)++;
    }

    (*arr)[*size - 1] = (char *)malloc(strlen(value) + 1);
    strcpy((*arr)[*size - 1], value);
}

int id_compare(char **arr, int size)
{
    if (size == 1)
        return 1;

    for (int i = 0; i < size - 1; i++)
    {
        if (strcmp(arr[size - 1], arr[i]) == 0)
            return 0;
    }
    return 1;
}

int checkedButton_checker(char **arr, int size, char *string)
{
    if (size == 0)
        return 1;

    if (string == NULL)
        return 1;

    for (int i = 0; i < size; i++)
    {
        if (strcmp(string, arr[i]) == 0)
            return 1;
    }
    return 0;
}

int progress_max(int max, int progress)
{
    if (progress > max)
    {
        return 1;
    }

    return 0;
}

void print(char **arr, int size)
{
    printf("[ ");
    for (int i = 0; i < size; i++)
    {
        printf("string %d: %s\n", i + 1, arr[i]);
    }
    printf("]\n");
}

void print_program(FILE *yyin)
{
    fseek(yyin, 0, SEEK_SET);

    int count = 1;
    printf("%d: ", count++);
    int c;

    while ((c = fgetc(yyin)) != EOF)
    {
        if (c == '\n')
        {
            printf("%c", c);
            printf("%d: ", count);
            count++;
        }
        else
        {
            printf("%c", c);
        }
    }

    printf("\n");
}

extern void print_err_program(FILE *yyin, int line)
{

    int char_size = fileLinesSize(yyin);
    fseek(yyin, 0, SEEK_SET);
    int count = 1;
    int num = line + 1;
    char c[char_size];
    while ((count < num) && (fgets(c, sizeof(c), yyin) != NULL))
    {
        printf("%d: %s", count, c);
        count++;
    }
}

int fileLinesSize(FILE *file)
{
    fseek(file, 0, SEEK_SET);
    int sizeCounter = 0;
    char c;
    int maxLenCounter = 0;

    while ((c = fgetc(file)) != EOF)
    {
        if (c == '\n')
        {
            // New maximum
            if (maxLenCounter > sizeCounter)
                sizeCounter = maxLenCounter;

            maxLenCounter = 0;
        }

        maxLenCounter++;
    }

    sizeCounter++;

    return sizeCounter;
}

void copyString(const char *source, char **destination)
{
    *destination = malloc(strlen(source) + 1); // Allocate memory for the copied string
    strcpy(*destination, source);              // Copy the string
}