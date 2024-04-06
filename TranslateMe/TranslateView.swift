//
//  TranslateView.swift
//  TranslateMe
//
//  Created by Fredy Camas on 4/5/24.
//

import SwiftUI
struct TranslateView: View {
    
    @EnvironmentObject var translator: TranslationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState var isKeyboardShowing: Bool
    
    @State private var userText = ""
    @State private var translatedText = ""
    @State private var isTranslating = false
    
    @State private var sourceLanguage = ""
    @State private var targetLanguage = ""
    @State private var showAlert = false
    @State private var placeholder = "Text here"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                try await
                                print("hello")
                                //translator.fetchHistory()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        placeholder = "Text here"
                        userText = ""
                        translatedText = ""
                        sourceLanguage = ""
                        targetLanguage = ""
                        translator.inputLanguage = ""
                        translator.outputLanguage = ""
                        isTranslating = true
                    }, label: {
                        Text("History")
                            .font(.headline) // Changed font
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    })
                }
                .padding(.horizontal, 17)
                
                VStack {
                    ZStack {
                        Color.black.opacity(0.5) // Black color with opacity
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                        
                        TextEditor(text: $userText)
                            .onTapGesture {
                                placeholder = ""
                            }
                            .focused($isKeyboardShowing)
                            .padding()
                            .textEditorStyle(.automatic)
                    }
                    
                    HStack {
                        VStack {
                            Menu {
                                ForEach(Languages.allCases) { language in
                                    Button(action: {
                                        translator.inputLanguage = language.rawValue
                                        sourceLanguage = language.name
                                    }, label: {
                                        Text(language.name)
                                    })
                                }
                            } label: {
                                Label(
                                    title: {
                                        Text("Pick Language")
                                            .font(.headline) // Changed font
                                    },
                                    icon: { Image(systemName: "chevron.down") }
                                )
                                .foregroundColor(.black)
                                .bold()
                            }
                            Text(sourceLanguage)
                        }
                        
                        VStack {
                            Menu {
                                ForEach(Languages.allCases) { language in
                                    Button(action: {
                                        translator.outputLanguage = language.rawValue
                                        targetLanguage = language.name
                                    }, label: {
                                        Text(language.name)
                                    })
                                }
                            } label: {
                                Label(
                                    title: {
                                        Text("Pick Language")
                                            .font(.headline) // Changed font
                                    },
                                    icon: { Image(systemName: "chevron.down") }
                                )
                                .foregroundColor(.black)
                                .bold()
                            }
                            Text(targetLanguage)
                        }
                    }
                    
                    ZStack {
                        Color.black.opacity(0.5) // Black color with opacity
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                        
                        TextEditor(text: $translatedText)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .disabled(true)
                            .padding()
                    }
                }
                
                Button(action: {
                    if sourceLanguage == "" || targetLanguage == "" {
                        showAlert = true
                    }
                    translator.text = userText
                    Task {
                        do {
                            translatedText = try await translator.translatedText() ?? "no translated text"
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }, label: {
                    Text("Translate Me")
                        .font(.headline) // Changed font
                        .bold()
                        .frame(width: 300)
                        .padding()
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                })
                .shadow(radius: 8)
            }
            .padding(.horizontal, 8)
            .navigationBarBackButtonHidden()
            .onTapGesture {
                isKeyboardShowing = false
            }
            .alert("Missing field", isPresented: $showAlert, actions: {
                Button("Ok", action: {})
            }, message: {
                Text("Pick a language first")
            })
        }
        .navigationDestination(isPresented: $isTranslating) {
            // HistoryView()
        }
    }
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
            .environmentObject(TranslationViewModel())
    }
}
