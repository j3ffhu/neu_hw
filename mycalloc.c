
#include <stdio.h>
#include <unistd.h>

struct MemoryBlock {
    void* ptr;
    size_t size;
    struct MemoryBlock* next;
};

void* my_calloc(size_t num_elements, size_t element_size, struct MemoryBlock** head) {
    size_t total_size = num_elements * element_size;
    void* ptr = sbrk(total_size);
    if (ptr == (void*)-1) {
        printf("Memory allocation failed.\n");
        return NULL;
    }

    struct MemoryBlock* newBlock = (struct MemoryBlock*)malloc(sizeof(struct MemoryBlock));
    if (newBlock == NULL) {
        printf("Memory allocation failed for tracking node.\n");
        return NULL;
    }

    newBlock->ptr = ptr;
    newBlock->size = total_size;
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
        free(current);
    } else {
        printf("Invalid pointer. Memory not allocated by my_calloc.\n");
    }
}

void deallocateMemory(struct MemoryBlock** head) {
    while (*head != NULL) {
        struct MemoryBlock* temp = *head;
        *head = (*head)->next;
        brk(temp->ptr);
        free(temp);
    }
}

int main() {
    struct MemoryBlock* head = NULL;

    // Allocate memory for 5 integers
    int* intArray = (int*)my_calloc(5, sizeof(int), &head);
    if (intArray != NULL) {
        // ...

        // Allocate memory for strings
        // ...

        // Free allocated memory
        // ...
    }

    // Deallocate all memory blocks and nodes in the linked list
    deallocateMemory(&head);

    return 0;
}
