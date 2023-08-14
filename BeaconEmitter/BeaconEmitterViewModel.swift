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

        loadSavedValue()

        emitter = CBPeripheralManager(delegate: self, queue: nil)

        majorMinorFormatter.allowsFloats = false
        majorMinorFormatter.maximum = NSNumber(value: UInt16.max)
        majorMinorFormatter.minimum = NSNumber(value: UInt16.min)

        powerFormatter.allowsFloats = false
        powerFormatter.maximum = NSNumber(value: Int8.max)
        powerFormatter.minimum = NSNumber(value: Int8.min)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(receiveSleepNotification), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(receiveAwakeNotification), name: NSWorkspace.didWakeNotification, object: nil)
    }

    func startStop() {
        guard let emitter else { return }

        if emitter.isAdvertising {
            emitter.stopAdvertising()
            isStarted = false
        } else {
            if let proximityUUID = NSUUID(uuidString: uuid) {
                let region = BeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor)
                emitter.startAdvertising(region.peripheralDataWithMeasuredPower())
            } else {
                status = "The UUID format is invalid"
            }
        }
    }

    func refreshUUID() {
        uuid = UUID().uuidString
    }

    func copyPaste() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(uuid, forType: .string)
    }

    @objc
    func receiveSleepNotification(_: Notification) {
        if let emitter, emitter.isAdvertising {
            advertiseBeforeSleep = true
            startStop()
        }
    }

    @objc
    func receiveAwakeNotification(_: Notification) {
        if advertiseBeforeSleep {
            startStop()
        }
    }

    func save() {
        savedUUID = uuid
        savedMajor = Int(major)
        savedMinor = Int(minor)
        savedPower = Int(power)
    }

    private func loadSavedValue() {
        if let savedUUID {
            uuid = savedUUID
        }

        if let savedMajor {
            major = UInt16(savedMajor)
        }

        if let savedMinor {
            minor = UInt16(savedMinor)
        }

        if let savedPower {
            power = Int8(savedPower)
        }
    }
}

extension BeaconEmitterViewModel: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            status = "Bluetooth is currently powered off"
        case .poweredOn:
            status = "Bluetooth is currently powered on and is available to use."
        case .unauthorized:
            status = "The app is not authorized to use the Bluetooth low energy peripheral/server role."
        case .unknown:
            status = "The current state of the peripheral manager is unknown; an update is imminent."
        case .resetting:
            status = "The connection with the system service was momentarily lost; an update is imminent."
        case .unsupported:
            status = "The platform doesn't support the Bluetooth low energy peripheral/server role."
        @unknown default:
            status = "The current state of the peripheral manager is unknown; an update is imminent."
        }
    }

    func peripheralManagerDidStartAdvertising(_: CBPeripheralManager, error _: Error?) {
        if let emitter, emitter.isAdvertising {
            isStarted = true
        }
    }
}
