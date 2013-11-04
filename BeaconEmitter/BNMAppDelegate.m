//
//  BNMAppDelegate.m
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

#import "BNMAppDelegate.h"
#import <IOBluetooth/IOBluetooth.h>

#import "BNMBeaconRegion.h"

@interface BNMAppDelegate () <CBPeripheralManagerDelegate>

@property (weak) IBOutlet NSTextField *uuid;
@property (weak) IBOutlet NSTextField *identifier;
@property (weak) IBOutlet NSTextField *major;
@property (weak) IBOutlet NSTextField *minor;
@property (weak) IBOutlet NSTextField *power;

@property (strong, nonatomic) CBPeripheralManager *manager;
@end

@implementation BNMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        
    }
}

- (IBAction)changeBeaconState:(NSButton *)sender {
    
    if ([self.manager isAdvertising]) {
        [self.manager stopAdvertising];
        [sender setTitle:@"Turn iBeacon on"];
    } else {
        NSUUID *proximityUUID  = [[NSUUID alloc] initWithUUIDString:self.uuid.stringValue];
        
        BNMBeaconRegion *beacon = [[BNMBeaconRegion alloc] initWithProximityUUID:proximityUUID major:self.major.intValue minor:self.minor.intValue  identifier:self.identifier.stringValue];
        [self.manager startAdvertising:[beacon peripheralDataWithMeasuredPower:[NSNumber numberWithInt:self.power.intValue]]];
        [sender setTitle:@"Turn iBeacon off"];
    }
}

@end
