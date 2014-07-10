//
//  BNMBeaconRegion.m
//  BeaconEmitter
//
//  Created by Laurent Gaches on 03/11/13.
//  Copyright (c) 2013 Binimo. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
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
    unsigned char advBytes[21] = {0};
    
    if (!measuredPower) {
        measuredPower = @-59;
    }
    
    [self.proximityUUID getUUIDBytes:(unsigned char *)&advBytes];
    
    advBytes[16] = (unsigned char)(self.major.shortValue >> 8);
    advBytes[17] = (unsigned char)(self.major.shortValue & 255);
    
    advBytes[18] = (unsigned char)(self.minor.shortValue >> 8);
    advBytes[19] = (unsigned char)(self.minor.shortValue & 255);
    
    advBytes[20] = measuredPower.shortValue;
    
    NSMutableData *AdvData = [NSMutableData dataWithBytes:advBytes length:21];
    NSLog(@"%@",AdvData);
    return [@{beaconKey:AdvData} mutableCopy];
}

@end
