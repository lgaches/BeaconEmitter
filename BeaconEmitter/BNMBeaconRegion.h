//
//  BNMBeaconRegion.h
//  BeaconEmitter
//
//  Created by Laurent Gaches on 03/11/13.
//  Copyright (c) 2013 Binimo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef uint16_t BNMBeaconMajorValue;
typedef uint16_t BNMBeaconMinorValue;

@interface BNMBeaconRegion : NSObject

@property (strong, nonatomic) NSUUID *proximityUUID;
@property (readonly, nonatomic) NSNumber *major;
@property (readonly, nonatomic) NSNumber *minor;


- (id)initWithProximityUUID:(NSUUID *)proximityUUID major:(BNMBeaconMajorValue)major minor:(BNMBeaconMinorValue)minor identifier:(NSString *)identifier;
- (NSMutableDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower;

@end
