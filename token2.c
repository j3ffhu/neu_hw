#include <stdio.h>
#include <string.h>

int main() {
    char inputString[100]; // Assuming a maximum length for the input string

    // Read input from standard input (pipe)
    fgets(inputString, sizeof(inputString), stdin);

    // Remove trailing newline character
    inputString[strcspn(inputString, "\n")] = '\0';

    // Flag to keep track of whether a double quote is encountered
    int insideQuotes = 0;

    // Tokenize the input string by space, preserving text within double quotes as a single token
    char *token = strtok(inputString, " ");

    // Print the tokens
    while (token != NULL) {
        // If token starts with a double quote, set insideQuotes flag
        if (token[0] == '"') {
            insideQuotes = 1;
            printf("%s", token + 1); // Print without the leading double quote
        } else if (insideQuotes && token[strlen(token) - 1] == '"') {
            insideQuotes = 0;
            printf(" %.*s\n", (int)strlen(token) - 1, token); // Print without the trailing double quote
        } else if (insideQuotes) {
            printf(" %s", token); // Inside quotes, print token as is
        } else {
            printf("%s\n", token); // Outside quotes, print token on a new line
        }

        // Get the next token
        token = strtok(NULL, " ");
    }

    return 0;
}

