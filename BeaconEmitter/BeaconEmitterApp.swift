//
//  BeaconEmitterApp.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import AppKit
import SwiftUI

@main
struct BeaconEmitterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
