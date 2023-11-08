#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct MemoryBlock {
    void* ptr;
    size_t size;
    struct MemoryBlock* next;
};

void* my_calloc(size_t num_elements, size_t element_size, struct MemoryBlock** head) {
    void* ptr = calloc(num_elements, element_size);
    if (ptr == NULL) {
        printf("Memory allocation failed.\n");
        return NULL;
    }

    struct MemoryBlock* newBlock = (struct MemoryBlock*)malloc(sizeof(struct MemoryBlock));
    if (newBlock == NULL) {
        printf("Memory allocation failed for tracking node.\n");
        free(ptr);
        return NULL;
    }

    newBlock->ptr = ptr;
    newBlock->size = num_elements * element_size;
    newBlock->next = *head;
    *head = newBlock;

    return ptr;
}

void my_free(void* ptr, struct MemoryBlock** head) {
    struct MemoryBlock* current = *head;
    struct MemoryBlock* prev = NULL;

    while (current != NULL && current->ptr != ptr) {
        prev = current;
        current = current->next;
    }

    if (current != NULL) {
        if (prev != NULL) {
            prev->next = current->next;
        } else {
            *head = current->next;
        }
        free(current->ptr);
        free(current);
    } else {
        printf("Invalid pointer. Memory not allocated by my_calloc.\n");
    }
}

void deallocateMemory(struct MemoryBlock** head) {
    while (*head != NULL) {
        struct MemoryBlock* temp = *head;
        *head = (*head)->next;
        free(temp->ptr);
        free(temp);
    }
}

void printMemoryBlocks(struct MemoryBlock* head) {
    printf("Memory Blocks held by MemoryBlock nodes:\n");
    struct MemoryBlock* current = head;
    while (current != NULL) {
        printf("Memory Address: %p, Size: %zu\n", current->ptr, current->size);
        current = current->next;
    }
}


int main() {
    struct MemoryBlock* head = NULL;

    // Allocate memory for 5 integers
    int* intArray = (int*)my_calloc(5, sizeof(int), &head);
    if (intArray != NULL) {
        for (int i = 0; i < 5; ++i) {
            intArray[i] = i + 1;
            printf("%d ", intArray[i]);
        }
        printf("\n");

        // Allocate memory for strings
        char* str1 = (char*)my_calloc(6, sizeof(char), &head); // Allocate memory for "Hello"
        char* str2 = (char*)my_calloc(8, sizeof(char), &head); // Allocate memory for "World!"

        if (str1 != NULL && str2 != NULL) {
            strcpy(str1, "Hello");
            strcpy(str2, "World!");

            printf("String 1: %s\n", str1);
            printf("String 2: %s\n", str2);
        }

        // Free allocated memory
//        my_free(intArray, &head);
  //      my_free(str1, &head);
    //    my_free(str2, &head);
    }


    printMemoryBlocks(head);

    // Deallocate all memory blocks and nodes in the linked list
    deallocateMemory(&head);

    return 0;
}

