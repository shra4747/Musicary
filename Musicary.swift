import SwiftUI

@main
struct Musicary: App {
    
    @State var page: Constants.ScreenTypes = .main
    @State var mood: Constants.Moods = .neutral
    @State var isSmiling = false
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch page {
                case .main: HomeView(page: $page, mood: $mood)
                case .diary: JournalView(mood: mood, affirmations: false, page: $page)
                case .affirmation: JournalView(mood: mood, affirmations: true, page: $page)
                case .smile: SmileView(page: $page)
                }
            }
        }
    }
}
