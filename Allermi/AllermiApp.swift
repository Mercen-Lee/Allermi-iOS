//
//  AllermiApp.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

public let api = "http://43.200.182.132"

@main
struct AllermiApp: App {
    public let token = UserDefaults.standard.string(forKey: "token")
    var body: some Scene {
        WindowGroup {
            if token != nil {
                ContentView()
            } else { FirstView() }
        }
    }
}
