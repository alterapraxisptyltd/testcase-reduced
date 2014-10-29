
#define CAR_GLOBAL __attribute__((section(".car.global_data")))
static int car_migrated CAR_GLOBAL;

void foo()
{
  car_migrated = 5;
}
