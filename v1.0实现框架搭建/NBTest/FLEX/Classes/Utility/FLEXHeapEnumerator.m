
#import "FLEXHeapEnumerator.h"
#import <malloc/malloc.h>
#import <mach/mach.h>
#import <objc/runtime.h>

static CFMutableSetRef registeredClasses;

typedef struct {
    Class isa;
} flex_maybe_object_t;

@implementation FLEXHeapEnumerator

static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount)
{
    flex_object_enumeration_block_t block = (__bridge flex_object_enumeration_block_t)context;
    if (!block) {
        return;
    }
    
    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        flex_maybe_object_t *tryObject = (flex_maybe_object_t *)range.address;
        Class tryClass = NULL;
#ifdef __arm64__
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
        tryClass = tryObject->isa;
#endif
        if (CFSetContainsValue(registeredClasses, (__bridge const void *)(tryClass))) {
            block((__bridge id)tryObject, tryClass);
        }
    }
}

static kern_return_t reader(__unused task_t remote_task, vm_address_t remote_address, __unused vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

+ (void)enumerateLiveObjectsUsingBlock:(flex_object_enumeration_block_t)block
{
    if (!block) {
        return;
    }
    
    [self updateRegisteredClasses];
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(TASK_NULL, reader, &zones, &zoneCount);
    
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            if (zone->introspect && zone->introspect->enumerator) {
                zone->introspect->enumerator(TASK_NULL, (__bridge void *)block, MALLOC_PTR_IN_USE_RANGE_TYPE, (vm_address_t)zone, reader, &range_callback);
            }
        }
    }
}

+ (void)updateRegisteredClasses
{
    if (!registeredClasses) {
        registeredClasses = CFSetCreateMutable(NULL, 0, NULL);
    } else {
        CFSetRemoveAllValues(registeredClasses);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(registeredClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
}

@end
