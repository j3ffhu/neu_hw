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


// GLOBAL
 block_t* head = NULL;

//  first-fit strategy
block_t* findFirstFit(size_t s, block_t* block) {
  
 
  assert(s > 0);

// first even block
if (block == NULL) {
    // Allocate memory for new block
    block = malloc(sizeof(block_t) + s);
    
    block->size = s;
    block->free = false;
    block->next = NULL;

    return block;
  } else  if (block->free == true && block->size >= s) {
    block->free = false;
    return block;
  }  else if (block->next == NULL) {  // no fit, create a new block, append 
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

 
void*  mymalloc(size_t s) {
 
  void* p  =  findFirstFit(s, head);

  debug_printf("malloc %zu bytes\n", s);

  // shiftt block_t meta
  // |block|---actual memory---|block|------actual memory-----|block|--actual memory--|
  return p   ;
}

//allocates the amount of memory specified by s * nmemb
//Signature: size_t, size_t -> void*
void *mycalloc(size_t nmemb, size_t s) {

  void* p  =  findFirstFit(sizeof(s) * nmemb, head);

  debug_printf("malloc %zu bytes\n", s);

  return p   ;
  
}



void myfree(void *ptr) {

  assert(ptr != NULL);

  block_t* freed = ptr - sizeof(block_t);

  //set flag only, for next first fit match
  freed->free = true;
  debug_printf("Freed %zu bytes\n",  sizeof(block_t) );
}
