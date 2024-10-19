import SwiftUI
import Foundation
import AVFoundation

struct JournalView: View {
    
    @State var text = ""
    @FocusState private var focused: Bool
    @State var mood: Constants.Moods
    
    @State var player = MusicPlayer.SuccessionalMusic()
    @State var engine = MusicPlayer.Engine()
    
    @State var affirmations: Bool
    @Binding var page: Constants.ScreenTypes

    @State var isShowingAlert = false
    @State var alertType: AlertTypes = .startAffirmations

    var body: some View {
        ZStack {
            VStack {
               HStack {
                   VStack {
                       TextField(affirmations ? "type some positive affirmations " : "talk to me about your day...", text: $text, axis: .vertical)
                           .font(.custom("Apple Chancery", size: 50))
                           .multilineTextAlignment(.leading)
                           .autocorrectionDisabled(true)
                           .padding()
                           .textFieldStyle(.plain)
                           .focused($focused)
                           .onChange(of: text, perform: { value in
                               let nextNote = (player.nextNote(message: text, mood: mood))
                               switch nextNote.type {
                               case .note:
                                   do {
                                       try engine.playAudio(pitch: player.noteToPitch(note: nextNote.value, mood: mood))
                                   }
                                   catch {
                                       print("Error!")
                                   }
                               case .scale:
                                   player.scale = nextNote.value
                               case .empty: break
                               }
                           })
                       Spacer()
                   }
                   .padding(.leading, 40)
                   .padding(.trailing, 40)
                   .padding(.top, 40)
                   .padding(.bottom, 20)

                   if affirmations {
                       GaugeView(positiveGauge: $player.positiveWordCount, mood: $mood, page: $page, showAlert: $isShowingAlert, alertType: $alertType)
                   }
               }
            }.onAppear {
                focused = true
                if affirmations {
                    isShowingAlert = true
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if page == .diary {
                        Button(action: {
                            if page == .diary {
                                page = .affirmation
                            }
                            else if page == .affirmation {
                                page = .smile
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 300, height: 100, alignment: .center)
                                    .shadow(radius: 20)
                                    .foregroundColor(Color(uiColor: UIColor.lightGray))
                                HStack {
                                    Text("Next").font(.custom("Apple Chancery", size: 45)).foregroundColor(.white)
                                    Image(systemName: "chevron.right").scaleEffect(1.3).bold().foregroundColor(.white)
                                }
                            }.opacity(isShowingAlert ? 0 : 1)
                        }
                    }
                    Spacer()
                }.padding()
            }.padding()
            
            if isShowingAlert {
                AlertView(mood: mood, alertType: alertType, showAlert: $isShowingAlert, page: $page).animation(.easeIn)
            }
        }
    }
}
