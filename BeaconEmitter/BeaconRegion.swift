//
//  BeaconRegion.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import Foundation

struct BeaconRegion {

    var proximityUUID: NSUUID
    var major: UInt16
    var minor: UInt16

    init(proximityUUID: NSUUID, major: UInt16, minor: UInt16) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
    }

    func peripheralDataWithMeasuredPower(_ measuredPower: Int8 = -59) -> [String: Data] {
        let beaconKey = "kCBAdvDataAppleBeaconKey"
        var advBytes = [CUnsignedChar](repeating: 0, count: 21)


        self.proximityUUID.getBytes(&advBytes)

        advBytes[16] = CUnsignedChar((self.major >> 8) & 255)
        advBytes[17] = CUnsignedChar(self.major & 255)

        advBytes[18] = CUnsignedChar((self.minor >> 8) & 255)
        advBytes[19] = CUnsignedChar(self.minor & 255)

        advBytes[20] = CUnsignedChar(bitPattern: measuredPower)

        let AdvData = Data(bytes: &advBytes, count: 21)
        return [beaconKey: AdvData]
    }
}
