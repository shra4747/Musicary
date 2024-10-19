import SwiftUI
import Foundation

struct HomeView: View {
    
    @State var player = MusicPlayer()
    @State var engine = MusicPlayer.Engine()
    @State var pitch: Float = 0.0
    
    @Binding var page: Constants.ScreenTypes
    @Binding var mood: Constants.Moods
    
    var body: some View {
        VStack {
            Text("how are you feeling today?")
                .font(.custom("Savoye LET", size: 120))
            
            HStack(spacing: 100) {
                Image("happy-face")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .onTapGesture {
                        mood = .happy
                        page = .diary
                    }
                Image("neutral-face")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .onTapGesture {
                        mood = .neutral
                        page = .diary
                    }
                Image("sad-face")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .onTapGesture {
                        mood = .sad
                        page = .diary
                    }
            }
        }.frame(width: 1920, height: 1080)
    }
}
