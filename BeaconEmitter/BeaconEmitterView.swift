//
//  ContentView.swift
//  BeaconEmitter
//
//  Created by Laurent Gaches.
//

import SwiftUI

struct BeaconEmitterView: View {

    @StateObject var viewModel = BeaconEmitterViewModel()

    var body: some View {
        Form {
            HStack {
                TextField("UUID", text: $viewModel.uuid)                    
                    .disabled(viewModel.isStarted)
                Button {
                    viewModel.refreshUUID()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }.disabled(viewModel.isStarted)

                Button {
                    viewModel.copyPaste()
                } label: {
                    Image(systemName: "doc.on.doc")
                }.disabled(viewModel.isStarted)
            }

            TextField("Major", value: $viewModel.major, formatter: viewModel.majorMinorFormatter)
                .disabled(viewModel.isStarted)
            TextField("Minor", value: $viewModel.minor, formatter: viewModel.majorMinorFormatter)
                .disabled(viewModel.isStarted)
            TextField("Power", value: $viewModel.power, formatter: viewModel.powerFormatter)
                .disabled(viewModel.isStarted)
            Text(viewModel.status)

            Button {
                viewModel.start()
            } label: {
                Spacer()
                if viewModel.isStarted {
                    Text("Turn iBeacon on")
                } else {
                    Text("Turn iBeacon off")
                }
                Spacer()
            }
        }
        .padding()        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconEmitterView()
    }
}
