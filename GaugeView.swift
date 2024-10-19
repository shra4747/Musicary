import SwiftUI
import Foundation

struct GaugeView: View {
    
    @State var totalHeight = CGFloat(1.0)
    @Binding var positiveGauge: Int
    @Binding var mood: Constants.Moods
    
    @State var factor = 0.0
    @State var screenHeight = CGFloat(0.0)
    @State var barColor: Color = .red
    
    @Binding var page: Constants.ScreenTypes
    @Binding var showAlert: Bool
    @Binding var alertType: AlertTypes

    var body: some View {
        ZStack {
            GeometryReader() { g in VStack{}.onAppear(perform: { screenHeight = g.size.height ; totalHeight = screenHeight})}.frame(width: 0)
            HStack {
                VStack(spacing: totalHeight/3) {
                    Text("😊 - ").font(.custom("Arial", size: 60))
                    Text("😐 - ").font(.custom("Arial", size: 60))
                    Text("😔 - ").font(.custom("Arial", size: 60))
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 85)
                        .frame(width: 225)
                        .foregroundColor(Color(uiColor: .lightGray))
                        .padding(40)
                        .shadow(radius: 10)
                    
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 85)
                            .animation(.easeIn)
                            .frame(width: 225, height:  (totalHeight/factor)+CGFloat(positiveGauge*75))
                            .foregroundColor(barColor)
                            .padding(40)
                    }
                }
            }
        }.onAppear {
            switch mood {
            case .happy:
                factor = 2.5
            case .neutral:
                factor = 4.5
            case .sad:
                factor = 10.5
            }
            changeValues()            
        }
        .onChange(of: positiveGauge, perform: { _ in
            changeValues()
        })
    }
    
    // Determine if Meter gauge is met
    func changeValues() {
        let barHeight = (totalHeight/factor)+CGFloat(positiveGauge*75)
        
        if  barHeight > totalHeight-80 {
            mood = .happy 
            alertType = .affirmed
            showAlert = true
            
        }
        else if barHeight > totalHeight/1.40 {
            mood = .happy
            barColor = .green
        }
        else if barHeight > totalHeight/8.55 {
            mood = .neutral
            barColor = .yellow
        }
        else if barHeight < totalHeight/10.55 {
            mood = .sad
            barColor = .red
        }
    }
}
