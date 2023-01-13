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
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }.commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem, addition: {})            
        }
    }
}
