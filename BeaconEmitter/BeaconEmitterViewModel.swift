//
//  BeaconEmitterViewModel.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import AppKit
import CoreBluetooth
import CoreLocation
import Foundation
import SwiftUI

class BeaconEmitterViewModel: NSObject, ObservableObject {
    @AppStorage("previousUUID") private var savedUUID: String?
    @AppStorage("major") private var savedMajor: Int?
    @AppStorage("minor") private var savedMinor: Int?
    @AppStorage("power") private var savedPower: Int?

    private var advertiseBeforeSleep: Bool = false
    var majorMinorFormatter = NumberFormatter()
    var powerFormatter = NumberFormatter()
    var emitter: CBPeripheralManager?

    @Published
    var isStarted: Bool = false

    @Published
    var uuid: String = UUID().uuidString

    @Published
    var major: UInt16 = 0

    @Published
    var minor: UInt16 = 0

    @Published
    var status: String = ""

    @Published
    var power: Int8 = -59

    override init() {
        super.init()

        self.loadSavedValue()

        self.emitter = CBPeripheralManager(delegate: self, queue: nil)

        self.majorMinorFormatter.allowsFloats = false
        self.majorMinorFormatter.maximum = NSNumber(value: UInt16.max)
        self.majorMinorFormatter.minimum = NSNumber(value: UInt16.min)

        self.powerFormatter.allowsFloats = false
        self.powerFormatter.maximum = NSNumber(value: Int8.max)
        self.powerFormatter.minimum = NSNumber(value: Int8.min)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveSleepNotification), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveAwakeNotification), name: NSWorkspace.didWakeNotification, object: nil)
    }

    func startStop() {
        guard let emitter else { return }

        if emitter.isAdvertising {
            emitter.stopAdvertising()
            self.isStarted = false
        } else {
            if let proximityUUID = NSUUID(uuidString: self.uuid) {
                let region = BeaconRegion(proximityUUID: proximityUUID, major: self.major, minor: self.minor)
                emitter.startAdvertising(region.peripheralDataWithMeasuredPower())
            } else {
                self.status = "The UUID format is invalid"
            }
        }
    }

    func refreshUUID() {
        self.uuid = UUID().uuidString
    }

    func copyPaste() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self.uuid, forType: .string)
    }

    @objc
    func receiveSleepNotification(_: Notification) {
        if let emitter, emitter.isAdvertising {
            self.advertiseBeforeSleep = true
            self.startStop()
        }
    }

    @objc
    func receiveAwakeNotification(_: Notification) {
        if self.advertiseBeforeSleep {
            self.startStop()
        }
    }

    func save() {
        self.savedUUID = self.uuid
        self.savedMajor = Int(self.major)
        self.savedMinor = Int(self.minor)
        self.savedPower = Int(self.power)
    }

    private func loadSavedValue() {
        if let savedUUID {
            self.uuid = savedUUID
        }

        if let savedMajor {
            self.major = UInt16(savedMajor)
        }

        if let savedMinor {
            self.minor = UInt16(savedMinor)
        }

        if let savedPower {
            self.power = Int8(savedPower)
        }
    }
}

extension BeaconEmitterViewModel: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            self.status = "Bluetooth is currently powered off"
        case .poweredOn:
            self.status = "Bluetooth is currently powered on and is available to use."
        case .unauthorized:
            self.status = "The app is not authorized to use the Bluetooth low energy peripheral/server role."
        case .unknown:
            self.status = "The current state of the peripheral manager is unknown; an update is imminent."
        case .resetting:
            self.status = "The connection with the system service was momentarily lost; an update is imminent."
        case .unsupported:
            self.status = "The platform doesn't support the Bluetooth low energy peripheral/server role."
        @unknown default:
            self.status = "The current state of the peripheral manager is unknown; an update is imminent."
        }
    }

    func peripheralManagerDidStartAdvertising(_: CBPeripheralManager, error _: Error?) {
        if let emitter, emitter.isAdvertising {
            self.isStarted = true
        }
    }
}
