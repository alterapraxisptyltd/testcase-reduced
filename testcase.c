#include <stdlib.h>

// Toggle Me to reproduce..
//#define __PRE_RAM__

#ifdef __PRE_RAM__
asm(".section .car.global_data,\"w\",@nobits");
asm(".previous");
#define CAR_GLOBAL __attribute__((section(".car.global_data")))
#else
#define CAR_GLOBAL
#endif

static int car_migrated CAR_GLOBAL;

void foo()
{
  car_migrated = ~0;
}

void * bar()
{
  if(car_migrated)
    return NULL;
  return NULL;
}
