//
//  BNMBeaconRegion.m
//  BeaconEmitter
//
//  Created by Laurent Gaches on 03/11/13.
//  Copyright (c) 2013 Binimo. All rights reserved.
//

#import "BNMBeaconRegion.h"



@implementation BNMBeaconRegion

- (id)initWithProximityUUID:(NSUUID *)proximityUUID major:(BNMBeaconMajorValue)major minor:(BNMBeaconMinorValue)minor identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.proximityUUID = proximityUUID;
        _major = [NSNumber numberWithUnsignedShort:major];
        _minor = [NSNumber numberWithUnsignedShort:minor];
    }
    return self;
}

- (NSMutableDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower {
    NSString *beaconKey = @"kCBAdvDataAppleBeaconKey";
    unsigned char advertisementBytes[21] = {0};
    
    [self.proximityUUID getUUIDBytes:(unsigned char *)&advertisementBytes];
    
    advertisementBytes[16] = (unsigned char)(self.major.shortValue >> 8);
    advertisementBytes[17] = (unsigned char)(self.major.shortValue & 255);
    
    advertisementBytes[18] = (unsigned char)(self.minor.shortValue >> 8);
    advertisementBytes[19] = (unsigned char)(self.minor.shortValue & 255);
    
    advertisementBytes[20] = measuredPower.shortValue;
    
    NSMutableData *advertisement = [NSMutableData dataWithBytes:advertisementBytes length:21];
    
    return [@{beaconKey:advertisement} mutableCopy];
}

@end
