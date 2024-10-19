import SwiftUI
import Foundation

struct AlertView: View {
    
    @State var mood: Constants.Moods
    @State var alertType: AlertTypes = .startAffirmations
    @Binding var showAlert: Bool
    @Binding var page: Constants.ScreenTypes
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.6)
            ZStack {
                RoundedRectangle(cornerRadius: 25).foregroundColor(.white).shadow(radius: 10)
                VStack(spacing: 40) {
                    Text(getEmoji()).font(.custom("Arial", size: 60))
                        
                    Text(getDescription())
                        .font(.custom("Rockwell", size: 35))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        showAlert = false
                        if alertType == .startAffirmations {
                            alertType = .affirmed
                        }
                        else if alertType == .affirmed {
                            page = .smile
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 200, height: 75, alignment: .center)
                                .shadow(radius: 5)
                                .foregroundColor(Color(uiColor: UIColor.lightGray))
                                .opacity(0.6)
                            HStack {
                                Image(systemName: "chevron.right").scaleEffect(1.4).bold().foregroundColor(.white)
                            }
                        }
                    }
                }
            }.frame(width: 500, height: 600, alignment: .center)
        }
    }
    
    
    func getEmoji() -> String {
        switch alertType {
        case .startAffirmations:
            switch mood {
            case .happy:
                return "😊"
            case .neutral:
                return "😐"
            case .sad:
                return "😔"
            }
        case .askToSmile:
            return "🫵"
        case .completed:
            return "😄"
        case .affirmed: 
            return "👉"
        }
    }
    
    func getDescription() -> String {
        switch alertType {
        case .startAffirmations:
            switch mood {
            case .happy:
                return "a good day can be even more awesome, say some positive things about yourself, and fill up the bar!"
            case .neutral:
                return "lets make an okay day a great day! say some positive things about yourself, and fill up the bar!"
            case .sad:
                return "i'm sorry you have been having a not so stellar day. say some positive things about yoursef, and fill up the bar!"
            }
        case .askToSmile:
            return "i need you to smile for 5 seconds, it will make you feel even better! 🙂"
        case .completed:
            return "i hope you are feeling a lot better now. you've got a friend in me 🐻"
        case .affirmed:
            return "don't worry, be happy. hakuna matata 🦁"
        }
    }
}


enum AlertTypes {
    case startAffirmations
    case askToSmile
    case affirmed
    case completed
}
