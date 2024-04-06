//
//  TranslateModel.swift
//  TranslateMe
//
//  Created by Fredy Camas on 4/5/24.
//


import Foundation


enum Languages: String, CaseIterable, Identifiable {
    
    
    case English = "en"
    case Italian = "it"
    case French = "fr"
    
    
    var name: String {
        switch self {
        case .English:
            "English"
        case .Italian:
            "Italian"
        case .French:
            "French"
    
        }
    }
    var id: String {
        return self.rawValue
    }
    
}

import Foundation

class TranslationViewModel: ObservableObject {
    
    @Published var inputLanguage = ""
    @Published var outputLanguage = ""
    @Published var text = ""
    @Published var history: [History] = []
    
    func translatedText() async throws -> String? {
        guard let url = URL(string: "https://api.mymemory.translated.net/get?q=\(text)&langpair=\(inputLanguage)|\(outputLanguage)") else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(ResponseData.self, from: data)
        
        guard let matches = result.matches, !matches.isEmpty else { return "No Matches" }
        
        return matches[0].translation ?? "No Translation"
    }
}
