//
//  ContentView.swift
//  ExptMainActorTasks
//
//  Created by Maris Lagzdins on 23/02/2023.
//

import SwiftUI

class Service {
    func printWeatherTemperature() async {
        print(16)
    }
}

class ViewModel: ObservableObject {
    private let service = Service()
    @Published private(set) var printingInProgress = false

    @MainActor func printTemperatures() async {
        printingInProgress = true

        printComputerTemperature()                  // executed on main thread
        await printRoomTemperature()                // executed on background thread
        await service.printWeatherTemperature()     // executed on background thread

        printingInProgress = false
    }

    private func printComputerTemperature() {
        print(40)
    }

    private func printRoomTemperature() async {
        print(21)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        Button("Print temperatures") {
            Task {
                await viewModel.printTemperatures()
            }
        }
        .disabled(viewModel.printingInProgress)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
