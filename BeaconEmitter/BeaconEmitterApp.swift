//
//  BeaconEmitterApp.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import SwiftUI

@main
struct BeaconEmitterApp: App {
    var body: some Scene {
        WindowGroup {
            BeaconEmitterView()
        }.commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem, addition: {})            
        }
    }
}
