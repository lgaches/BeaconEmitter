//
//  BeaconEmitterViewModel.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import Foundation
import CoreBluetooth
import CoreLocation
import AppKit

class BeaconEmitterViewModel: NSObject, ObservableObject {

    var emitter: CBPeripheralManager?

    @Published
    var isStarted: Bool = false

    @Published
    var uuid: String = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"

    @Published
    var major: UInt16 = 123

    @Published
    var minor: UInt16 = 456

    @Published
    var status: String = ""

    @Published
    var power: Int8 = -59

    override init() {
        super.init()
        self.emitter = CBPeripheralManager(delegate: self, queue: nil)
    }

    func start() {

        guard let emitter else { return }

        if emitter.isAdvertising {
            emitter.stopAdvertising()
            isStarted = false
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
}


extension BeaconEmitterViewModel: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print(peripheral.state)
        switch(peripheral.state) {
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

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let emitter, emitter.isAdvertising {
            isStarted = true
        }
    }
}
