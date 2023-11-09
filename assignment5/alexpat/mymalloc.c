#define _DEFAULT_SOURCE
#define _BSD_SOURCE 
#include <malloc.h> 
#include <stdio.h> 
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>


#include <debug.h>  

 
typedef struct block {
  size_t size;        // number of bytes allocated
                 
  struct block *next; // point to next block
  bool free;          // flag 1/free, 0/ used 

} block_t;

 block_t* head = NULL;

//  first-fit strategy
block_t* findFirstFit(size_t s, block_t* block) {
  assert(block != NULL);
  assert(s > 0);

  //  match found, 
  if (block->free == true && block->size >= s) {
    block->free = false;
    return block;
  }
  // no fit, create a new blokc, append 
  else if (block->next == NULL) {
    // Allocate memory for new block
    block_t* tailBlock = malloc(sizeof(block_t) + s);
    
    tailBlock->size = s;
    tailBlock->free = false;
    tailBlock->next = NULL;
    // append current
    block->next = tailBlock;
    //return header pointer
    return tailBlock;
  } else {
    // repeat
    return findFirstFit(s, block->next);
  }
}

 
void *mymalloc(size_t s) {
  assert(s > 0);
  void* p;

  // starter
  if (head == NULL) {

    head = malloc(sizeof(block_t) + s);

    head->size = s;
    head->next = NULL;
    head->free = false;

    //return the pointer to the open memory
    p = (void*) head + sizeof(block_t);
  } else {
    //return the pointer to the memory just allocated
    p = (void*) findFirstFit(s, head) + sizeof(block_t);
  }

  debug_printf("malloc %zu bytes\n", s);
  assert(p != NULL);
  return p;
}

//allocates the amount of memory specified by s * nmemb
//Signature: size_t, size_t -> void*
void *mycalloc(size_t nmemb, size_t s) {
  assert(nmemb > 0);
  assert(s > 0);
  void* p;
  block_t* block;
  block = mymalloc(s * nmemb + (sizeof(block_t) * (nmemb - 1)));
  block->size = s;

  debug_printf("calloc %zu bytes\n", s);
  p = (void*) block + sizeof(block_t);
  assert(p != NULL);
  return p;
}



void myfree(void *ptr) {

  assert(ptr != NULL);

  block_t* freed = ptr - sizeof(block_t);

  //set flag only, for next first fit match
  freed->free = true;
  debug_printf("Freed %zu bytes\n",  sizeof(block_t) );
}
