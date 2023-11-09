#define _DEFAULT_SOURCE
#define _BSD_SOURCE 
#include <malloc.h> 
#include <stdio.h> 
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>

// Include any other headers we need here

// NOTE: You should NOT include <stdlib.h> in your final implementation

#include <debug.h>  

 
typedef struct block {
  size_t size;      // How many bytes beyond this metadata have been
  void* data ;     // data location  
  struct block *next; // Where is the next block in the free list
  bool free;          // 1 is free, 0 is allocated
                      // information--remember, you are the boss!
} block_t;

//global variable representing the first block in our list
block_t* headBlock = NULL;

 
block_t* findFirstFit(size_t s, block_t* block) {


   assert(s > 0);

   if (block  == NULL ) {  

    // starter
     block =sbrk(sizeof(block_t));
 
    // create data
    void *data =sbrk(sizeof(s));
    debug_printf("calloc %zu bytes\n", s);

 
    block->size = s;
    block->data = data;
    block->free = false;
    block->next = NULL;
 
    return block;

   }  else if (block->free == true && block->size >= s) {
    block->free = false;
    return block;
  }  else if (block->next == NULL) {
    // end chain, create new 
    // create block
    block_t* currentBlock =sbrk(sizeof(block_t));

    // create data
    void *data =sbrk(sizeof(s));
     debug_printf("calloc %zu bytes\n", s);


    // init values
    currentBlock->size = s;
    currentBlock->data = data;
    currentBlock->free = false;
    currentBlock->next = NULL;
    // Set previous next to be new block
    block->next = currentBlock;
    //return header pointer
    return currentBlock;
  } else {
    //find the next free block from the next block
    return findFirstFit(s, block->next);
  }
}

//allocates s bytes of memory
//Signature: size_t -> void*
void *mymalloc(size_t s) {
 
 block_t*  p = (block_t*) findFirstFit(s, headBlock)  ;
 
  return p;
}

//allocates the amount of memory specified by s * nmemb
//Signature: size_t, size_t -> void*
void *mycalloc(size_t nmemb, size_t s) {

  block_t* p = (block_t*) findFirstFit(sizeof(s) *nmemb , headBlock)  ;
 
  return p;
 
}


//frfee the memory pointed to by ptr
//Signature: void* -> void
void myfree(void *ptr) {
  assert(ptr != NULL);
  //find the pointer to the header of the memory we want to free
  block_t* freed = ptr - sizeof(block_t);
  //set the free variable at that header to true
  freed->free = true;
  debug_printf("Freed %zu bytes\n", freed->size);
}
