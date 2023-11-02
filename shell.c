#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char command[100]; // Assuming a maximum length for the command

    // Loop to continuously accept and execute shell commands
    while (1) {
        // Read shell command from user
        printf("shell $");
        fgets(command, sizeof(command), stdin);

        // Remove trailing newline character
        command[strcspn(command, "\n")] = '\0';

        // Check if the user wants to exit
        if (strcmp(command, "exit") == 0) {
            printf("Bye bye.\n");
            break;
        }

        // Use popen to execute the command and read the output
        FILE *fp = popen(command, "r");
        if (fp == NULL) {
            printf("Error executing command.\n");
            return 1;
        }

        // Read and print the output of the command
        char output[1000]; // Assuming a maximum length for the output
        while (fgets(output, sizeof(output), fp) != NULL) {
            printf("%s", output);
        }

        // Close the pipe and print any errors
        int status = pclose(fp);
    }

    return 0;
}

