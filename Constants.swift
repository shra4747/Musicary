import SwiftUI
import Foundation


struct Constants {
    
    enum ScreenTypes {
        case main
        case diary
        case affirmation
        case smile
    }
    
    // Major Scales and Pentatoinic Scales
    enum MajorScales: String, CaseIterable {
        case c_maj = "c d e f g a b c"
        case g_maj = "g a b c d e g"
        case d_maj = "d e g a b d"
        case a_maj = "a b d e a"

        case pentatonic = "c# d# f# g# a# c# d#"        

        static func random() -> MajorScales {
            return allCases.randomElement()!
        }
    }  
    
    // Scales that have embelishments
    enum NeutralScales: String, CaseIterable {
        case f_maj = "f g a a# c d e f"
        case asharp_maj = "a# c d d# f g a a#"
        case dsharp_maj = "d# f g g# a# c d d#"
        case gsharp_maj = "g# a# c c# d# f g g#"
        case b_maj = "b c# d# e f# g# a# b"
        case fsharp_maj = "f# g# a# b c# d# f f#"
        case csharp_maj = "c# d# f f# g# a# c c#"

        static func random() -> NeutralScales {
            return allCases.randomElement()!
        }
    }
    
    // Minor Scales
    enum MinorScales: String, CaseIterable {
        case a_min = "a b c d e f g a"
        case e_minor = "e f# g a b c# e"
        case b_minor = "b c# e f# g a# b"
        
        static func random() -> MinorScales {
            return allCases.randomElement()!
        }
    }
    
    enum Moods {
        case happy
        case neutral
        case sad
    }
    
    let pitchValues: [String: Int] = ["c": 0, "c#": 100, "d": 200, "d#": 300, "e": 400, "f": 500, "f#": 600, "g": 700, "g#": 800, "a": 900, "a#": 1000, "b": 1100]
}
