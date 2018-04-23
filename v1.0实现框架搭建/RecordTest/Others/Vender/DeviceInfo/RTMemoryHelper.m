
#import "RTMemoryHelper.h"
#include <mach/mach.h>
#include <malloc/malloc.h>

#define KB (1024)
#define MB (KB * 1024)
#define GB (MB * 1024)

static vm_size_t jPageSize = 0;
static vm_statistics_data_t jVMStats;

@implementation RTMemoryHelper

+ (unsigned long long)bytesOfUsedMemory{
    struct mstats stat = mstats();
    return stat.bytes_used;
}

+ (unsigned long long)bytesOfTotalMemory{
    [self updateHostStatistics];

    unsigned long long free_count = (unsigned long long)jVMStats.free_count;
    unsigned long long active_count = (unsigned long long)jVMStats.active_count;
    unsigned long long inactive_count = (unsigned long long)jVMStats.inactive_count;
    unsigned long long wire_count = (unsigned long long)jVMStats.wire_count;
    unsigned long long pageSize = (unsigned long long)jPageSize;

    unsigned long long mem_free = (free_count + active_count + inactive_count + wire_count) * pageSize;
    return mem_free;
}

//for internal use
+ (BOOL)updateHostStatistics{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &jPageSize);
    return (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&jVMStats, &host_size)
        == KERN_SUCCESS);
}

- (NSString*)bytesOfUsedMemory{
    unsigned long long used = [RTMemoryHelper bytesOfUsedMemory];
    return [self number2String:used];
}

- (NSString*)number2String:(int64_t)n{
    if (n < KB) {
        return [NSString stringWithFormat:@"%lldB", n];
    } else if (n < MB) {
        return [NSString stringWithFormat:@"%.1fK", (float)n / (float)KB];
    } else if (n < GB) {
        return [NSString stringWithFormat:@"%.1fM", (float)n / (float)MB];
    } else {
        return [NSString stringWithFormat:@"%.1fG", (float)n / (float)GB];
    }
}

@end
