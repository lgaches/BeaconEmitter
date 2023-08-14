//
//  BeaconEmitterView.swift
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
                TextField("Unique Identifier", text: $viewModel.uuid)
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

            TextField("Most significant value", value: $viewModel.major, formatter: viewModel.majorMinorFormatter)
                .disabled(viewModel.isStarted)
            TextField("Least significant value", value: $viewModel.minor, formatter: viewModel.majorMinorFormatter)
                .disabled(viewModel.isStarted)
            TextField("Power", value: $viewModel.power, formatter: viewModel.powerFormatter)
                .disabled(viewModel.isStarted)
            Text(viewModel.status)

            Button {
                viewModel.startStop()
            } label: {
                Spacer()
                if viewModel.isStarted {
                    Text("Turn iBeacon off")
                } else {
                    Text("Turn iBeacon on")
                }
                Spacer()
            }
        }
        .padding()
        .onDisappear {
            viewModel.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconEmitterView()
    }
}
