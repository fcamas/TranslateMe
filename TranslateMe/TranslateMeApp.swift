//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Fredy Camas on 4/5/24.
//

import SwiftUI

@main
struct TranslateMeApp: App {
   
    let translationViewModel = TranslationViewModel()
    
    var body: some Scene {
        WindowGroup {
           
            TranslateView()
                .environmentObject(translationViewModel)
        }
    }
}
