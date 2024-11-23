//
//  TouchableApp.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/21.
//

import SwiftUI

@main
struct TouchableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(CGSize(width: 400, height: 300))
        .windowResizability(.contentSize)
    }
}
