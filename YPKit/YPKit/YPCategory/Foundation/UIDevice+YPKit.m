//
//  UIDevice+YPKit.m
//  YPKit
//
//  Created by 喻平 on 16/6/22.
//  Copyright © 2016年 YPKit. All rights reserved.
//

#import "UIDevice+YPKit.h"
#import <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation UIDevice (YPKit)

- (BOOL)isPad {
    static dispatch_once_t onceToken;
    static BOOL pad;
    dispatch_once(&onceToken, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

- (NSString *)yp_machineModel {
    static dispatch_once_t once;
    static NSString *model;
    dispatch_once(&once, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return model;
}

- (NSString *)yp_machineModelName {
    static dispatch_once_t once;
    static NSString *name;
    dispatch_once(&once, ^{
        NSString *model = [self yp_machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                                @"AppleTV2,1" : @"Apple TV 2",
                                @"AppleTV3,1" : @"Apple TV 3",
                                @"AppleTV3,2" : @"Apple TV 3",
                                @"AppleTV5,3" : @"Apple TV 4",
                                @"AppleTV6,2" : @"Apple TV 4K",
                                @"AppleTV11,1" : @"Apple TV 4K (2nd generation)",
                                
                                @"Watch1,1" : @"Apple Watch",
                                @"Watch1,2" : @"Apple Watch",
                                @"Watch2,6" : @"Apple Watch Series 1",
                                @"Watch2,7" : @"Apple Watch Series 1",
                                @"Watch2,3" : @"Apple Watch Series 2",
                                @"Watch2,4" : @"Apple Watch Series 2",
                                @"Watch3,1" : @"Apple Watch Series 3",
                                @"Watch3,2" : @"Apple Watch Series 3",
                                @"Watch3,3" : @"Apple Watch Series 3",
                                @"Watch3,4" : @"Apple Watch Series 3",
                                @"Watch4,1" : @"Apple Watch Series 4",
                                @"Watch4,2" : @"Apple Watch Series 4",
                                @"Watch4,3" : @"Apple Watch Series 4",
                                @"Watch4,4" : @"Apple Watch Series 4",
                                @"Watch5,1" : @"Apple Watch Series 5",
                                @"Watch5,2" : @"Apple Watch Series 5",
                                @"Watch5,3" : @"Apple Watch Series 5",
                                @"Watch5,4" : @"Apple Watch Series 5",
                                @"Watch5,9" : @"Apple Watch SE",
                                @"Watch5,10" : @"Apple Watch SE",
                                @"Watch5,11" : @"Apple Watch SE",
                                @"Watch5,12" : @"Apple Watch SE",
                                @"Watch6,1" : @"Apple Watch Series 6",
                                @"Watch6,2" : @"Apple Watch Series 6",
                                @"Watch6,3" : @"Apple Watch Series 6",
                                @"Watch6,4" : @"Apple Watch Series 6",
                                @"Watch6,6" : @"Apple Watch Series 7",
                                @"Watch6,7" : @"Apple Watch Series 7",
                                @"Watch6,8" : @"Apple Watch Series 7",
                                @"Watch6,9" : @"Apple Watch Series 7",
                                @"Watch6,10" : @"SE (2nd generation)",
                                @"Watch6,11" : @"SE (2nd generation)",
                                @"Watch6,12" : @"SE (2nd generation)",
                                @"Watch6,13" : @"SE (2nd generation)",
                                @"Watch6,14" : @"Apple Watch Series 8",
                                @"Watch6,15" : @"Apple Watch Series 8",
                                @"Watch6,16" : @"Apple Watch Series 8",
                                @"Watch6,17" : @"Apple Watch Series 8",
                                @"Watch6,18" : @"Apple Watch Ultra",
                                @"Watch7,5" : @"Apple Watch Ultra 2",
                                
                                @"iPad1,1" : @"iPad 1",
                                @"iPad2,1" : @"iPad 2 (WiFi)",
                                @"iPad2,2" : @"iPad 2 (GSM)",
                                @"iPad2,3" : @"iPad 2 (CDMA)",
                                @"iPad2,4" : @"iPad 2",
                                @"iPad2,5" : @"iPad mini 1",
                                @"iPad2,6" : @"iPad mini 1",
                                @"iPad2,7" : @"iPad mini 1",
                                @"iPad3,1" : @"iPad 3 (WiFi)",
                                @"iPad3,2" : @"iPad 3 (4G)",
                                @"iPad3,3" : @"iPad 3 (4G)",
                                @"iPad3,4" : @"iPad 4",
                                @"iPad3,5" : @"iPad 4",
                                @"iPad3,6" : @"iPad 4",
                                @"iPad6,11" : @"iPad (5th generation)",
                                @"iPad6,12" : @"iPad (5th generation)",
                                @"iPad7,5" : @"iPad (6th generation)",
                                @"iPad7,6" : @"iPad (6th generation)",
                                @"iPad7,11" : @"iPad (7th generation)",
                                @"iPad7,12" : @"iPad (7th generation)",
                                @"iPad11,6" : @"iPad (8th generation)",
                                @"iPad11,7" : @"iPad (8th generation)",
                                @"iPad12,1" : @"iPad (9th generation)",
                                @"iPad12,2" : @"iPad (9th generation)",
                                
                                @"iPad4,1" : @"iPad Air",
                                @"iPad4,2" : @"iPad Air",
                                @"iPad4,3" : @"iPad Air",
                                @"iPad5,3" : @"iPad Air 2",
                                @"iPad5,4" : @"iPad Air 2",
                                @"iPad11,3" : @"iPad Air (3rd generation)",
                                @"iPad11,4" : @"iPad Air (3rd generation)",
                                @"iPad13,1" : @"iPad Air (4th generation)",
                                @"iPad13,2" : @"iPad Air (4th generation)",
                                @"iPad13,16" : @"iPad Air (5th generation)",
                                @"iPad13,17" : @"iPad Air (5th generation)",
                                
                                @"iPad6,3" : @"iPad Pro (9.7 inch)",
                                @"iPad6,4" : @"iPad Pro (9.7 inch)",
                                @"iPad6,7" : @"iPad Pro (12.9 inch)",
                                @"iPad6,8" : @"iPad Pro (12.9 inch)",
                                @"iPad7,1" : @"iPad Pro (12.9-inch, 2nd generation)",
                                @"iPad7,2" : @"iPad Pro (12.9-inch, 2nd generation)",
                                @"iPad7,3" : @"iPad Pro (10.5-inch)",
                                @"iPad7,4" : @"iPad Pro (10.5-inch)",
                                @"iPad8,1" : @"iPad Pro (11-inch)",
                                @"iPad8,2" : @"iPad Pro (11-inch)",
                                @"iPad8,3" : @"iPad Pro (11-inch)",
                                @"iPad8,4" : @"iPad Pro (11-inch)",
                                @"iPad8,5" : @"iPad Pro (12.9-inch, 3rd generation)",
                                @"iPad8,6" : @"iPad Pro (12.9-inch, 3rd generation)",
                                @"iPad8,7" : @"iPad Pro (12.9-inch, 3rd generation)",
                                @"iPad8,8" : @"iPad Pro (12.9-inch, 3rd generation)",
                                @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
                                @"iPad8,10" : @"iPad Pro (11-inch) (2nd generation)",
                                @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
                                @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
                                @"iPad13,4" : @"iPad Pro (11-inch) (3rd generation)",
                                @"iPad13,5" : @"iPad Pro (11-inch) (3rd generation)",
                                @"iPad13,6" : @"iPad Pro (11-inch) (3rd generation)",
                                @"iPad13,7" : @"iPad Pro (11-inch) (3rd generation)",
                                @"iPad13,8" : @"iPad Pro (12.9-inch) (5th generation)",
                                @"iPad13,9" : @"iPad Pro (12.9-inch) (5th generation)",
                                @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
                                @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
                                @"iPad14,3" : @"iPad Pro (11-inch) (6th generation)",
                                @"iPad14,4" : @"iPad Pro (11-inch) (6th generation)",
                                @"iPad14,5" : @"iPad Pro (12.9-inch) (6th generation)",
                                @"iPad14,6" : @"iPad Pro (12.9-inch) (6th generation)",
                                
                                @"iPad4,4" : @"iPad mini 2",
                                @"iPad4,5" : @"iPad mini 2",
                                @"iPad4,6" : @"iPad mini 2",
                                @"iPad4,7" : @"iPad mini 3",
                                @"iPad4,8" : @"iPad mini 3",
                                @"iPad4,9" : @"iPad mini 3",
                                @"iPad5,1" : @"iPad mini 4",
                                @"iPad5,2" : @"iPad mini 4",
                                @"iPad11,1" : @"iPad mini (5th generation)",
                                @"iPad11,2" : @"iPad mini (5th generation)",
                                @"iPad14,1" : @"iPad mini (6th generation)",
                                @"iPad14,2" : @"iPad mini (6th generation)",
                                
                                @"iPhone1,1" : @"iPhone 1G",
                                @"iPhone1,2" : @"iPhone 3G",
                                @"iPhone2,1" : @"iPhone 3GS",
                                @"iPhone3,1" : @"iPhone 4 (GSM)",
                                @"iPhone3,2" : @"iPhone 4",
                                @"iPhone3,3" : @"iPhone 4 (CDMA)",
                                @"iPhone4,1" : @"iPhone 4S",
                                @"iPhone5,1" : @"iPhone 5",
                                @"iPhone5,2" : @"iPhone 5",
                                @"iPhone5,3" : @"iPhone 5c",
                                @"iPhone5,4" : @"iPhone 5c",
                                @"iPhone6,1" : @"iPhone 5s",
                                @"iPhone6,2" : @"iPhone 5s",
                                @"iPhone7,1" : @"iPhone 6 Plus",
                                @"iPhone7,2" : @"iPhone 6",
                                @"iPhone8,1" : @"iPhone 6s",
                                @"iPhone8,2" : @"iPhone 6s Plus",
                                @"iPhone8,4" : @"iPhone SE",
                                @"iPhone9,1" : @"iPhone 7",
                                @"iPhone9,3" : @"iPhone 7",
                                @"iPhone9,2" : @"iPhone 7 Plus",
                                @"iPhone9,4" : @"iPhone 7 Plus",
                                @"iPhone10,1" : @"iPhone 8",
                                @"iPhone10,4" : @"iPhone 8",
                                @"iPhone10,2" : @"iPhone 8 Plus",
                                @"iPhone10,5" : @"iPhone 8 Plus",
                                @"iPhone10,3" : @"iPhone X",
                                @"iPhone10,6" : @"iPhone X",
                                @"iPhone11,2" : @"iPhone XS",
                                @"iPhone11,6" : @"iPhone XS Max",
                                @"iPhone11,8" : @"iPhone XR",
                                @"iPhone12,1" : @"iPhone 11",
                                @"iPhone12,3" : @"iPhone 11 Pro",
                                @"iPhone12,5" : @"iPhone 11 Pro Max",
                                @"iPhone12,8" : @"iPhone SE (2nd generation)",
                                @"iPhone13,1" : @"iPhone 12 Mini",
                                @"iPhone13,2" : @"iPhone 12",
                                @"iPhone13,3" : @"iPhone 12 Pro",
                                @"iPhone13,4" : @"iPhone 12 Pro Max",
                                @"iPhone14,4" : @"iPhone 13 Mini",
                                @"iPhone14,5" : @"iPhone 13",
                                @"iPhone14,2" : @"iPhone 13 Pro",
                                @"iPhone14,3" : @"iPhone 13 Pro Max",
                                @"iPhone14,6" : @"iPhone SE (3rd generation)",
                                @"iPhone14,7" : @"iPhone 14",
                                @"iPhone14,8" : @"iPhone 14 Plus",
                                @"iPhone15,2" : @"iPhone 14 Pro",
                                @"iPhone15,3" : @"iPhone 14 Pro Max",
                                @"iPhone15,5" : @"iPhone 15 Plus",
                                @"iPhone16,1" : @"iPhone 15 Pro",
                                @"iPhone16,2" : @"iPhone 15 Pro Max",
                                
                                @"iPod1,1" : @"iPod touch 1",
                                @"iPod2,1" : @"iPod touch 2",
                                @"iPod3,1" : @"iPod touch 3",
                                @"iPod4,1" : @"iPod touch 4",
                                @"iPod5,1" : @"iPod touch 5",
                                @"iPod7,1" : @"iPod touch 6",
                                @"iPod9,1" : @"iPod touch 7",
                                
                                @"i386" : @"Simulator x86",
                                @"x86_64" : @"Simulator x64",
                            };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

- (int64_t)diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceUsed {
    int64_t total = self.diskSpace;
    int64_t free = self.diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)ipAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

- (NSString *)ipAddressCell {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}

@end
