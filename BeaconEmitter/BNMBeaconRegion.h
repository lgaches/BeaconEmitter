//
//  BNMBeaconRegion.h
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
