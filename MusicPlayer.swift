import SwiftUI
import AVFoundation

// Function to read the positive.txt file and get list of all positive words
public func readWords() -> String {
    do {
        guard let fileUrl = Bundle.main.url(forResource: "positive", withExtension: "txt") else { return "" }
        let text = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
        return text
    } catch {
        return ""
    }
}

// Music Player class contating Engine and Successive Note structs
/*#-code-walkthrough(1.modifier)*/
class MusicPlayer {
/*#-code-walkthrough(1.modifier)*/
    /*#-code-walkthrough(2.modifier)*/
    struct Engine {
        var engine = AVAudioEngine()
        var players: [AVAudioPlayerNode] = []
        var pitchControls: [AVAudioUnitTimePitch] = []
        var speedControls: [AVAudioUnitVarispeed] = []
    /*#-code-walkthrough(2.modifier)*/
        init() {
            // Connect the engine's main mixer node to the output node
            let mixer = engine.mainMixerNode
            let format = mixer.outputFormat(forBus: 0)
            engine.connect(mixer, to: engine.outputNode, format: format)
            
            // Tries to start the engine
            do {
                try engine.start()
            } catch {
                print("Failed to start audio engine: \(error)")
            }
        }
        
        // Crreates a new Node to add to the array
        mutating func addPlayer() {
            let player = AVAudioPlayerNode()
            let pitchControl = AVAudioUnitTimePitch()
            let speedControl = AVAudioUnitVarispeed()
            
            engine.attach(player)
            engine.attach(pitchControl)
            engine.attach(speedControl)
            
            engine.connect(player, to: speedControl, format: nil)
            engine.connect(speedControl, to: pitchControl, format: nil)
            engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)
            
            players.append(player)
            pitchControls.append(pitchControl)
            speedControls.append(speedControl)
        }
        
        // Function that plays audio
        mutating func playAudio(pitch: Float) throws {
            guard let audioURL = Bundle.main.url(forResource: "c", withExtension: "wav") else {
                print("Audio file not found")
                return
            }
            addPlayer()
            
            // Limits the number of Nodes in the array to maximize resources
            if players.count > 10 {
                engine.disconnectNodeInput(players[0])
                engine.disconnectNodeInput(speedControls[0])
                engine.disconnectNodeInput(pitchControls[0])
                engine.detach(players[0])
                engine.detach(speedControls[0])
                engine.detach(pitchControls[0])
                players = Array(players[1...players.count-1])
                pitchControls = Array(pitchControls[1...pitchControls.count-1])
                speedControls = Array(speedControls[1...speedControls.count-1])
            }
            
            // Finds the index of a Node that has no audio playing
            if let index = players.lastIndex(where: { !$0.isPlaying }) {
                let player = players[index]
                let pitchControl = pitchControls[index]
                pitchControl.pitch = pitch
                /*#-code-walkthrough(3.modifier)*/
                let file = try AVAudioFile(forReading: audioURL)
                player.scheduleFile(file, at: nil)
                player.play()
                /*#-code-walkthrough(3.modifier)*/
            } else {
                print("Error no players")
            }
        }
    }
    
    // Decide next best note to play 
    struct SuccessionalMusic {
        
        struct Returnable {
            enum ReturnType {
                case scale
                case note
                case empty
            }
            
            let type: ReturnType
            let value: String
        }
        
        let positiveWordList = readWords()
        var positiveWordCount = 0
        
        var lastWord = ""
        var lastletter = ""
        var scale = ""
        var lastNote = ""
        
        // Convert a Letter note to the corresponding pitch value
        /*#-code-walkthrough(4.modifier)*/
        /*#-code-walkthrough(3.modifier)*/
        public func noteToPitch(note: String, mood: Constants.Moods) -> Float {
            let pitch = Float(Constants().pitchValues[note] ?? 0)
            if pitch > 500 {
                if mood == .sad {
                    return pitch-2400
                }
                else {
                    return pitch-1200
                }
            }
            else {
                if mood == .sad {
                    return pitch-1200
                }
                else {
                    return pitch
                }
            }
        }
        /*#-code-walkthrough(4.modifier)*/
        /*#-code-walkthrough(3.modifier)*/
        // Determine the next best note using a random number
        mutating public func nextNote(message: String, mood: Constants.Moods) -> Returnable {
            
            if scale == "" {
                switch mood {
                case .happy :
                    scale = Constants.MajorScales.random().rawValue
                case .neutral:
                     scale = Constants.NeutralScales.random().rawValue
                case .sad:
                     scale = Constants.MinorScales.random().rawValue
                }
            }
            
            guard let messageEnding = message.last else {
                return Returnable(type: .empty, value: "")
            }
            let letter = "\(messageEnding)"
            lastletter = letter
            if letter == " " {
                
                // Calculate number of positive words used
                do {
                    try positiveWords(word: lastWord.replacingOccurrences(of: " ", with: ""))
                }
                catch {
                    fatalError(error.localizedDescription)
                }
                
                lastletter = ""
                lastNote = ""
                lastWord = ""
                
                // Get the next scale based on the mood
                /*#-code-walkthrough(5.modifier)*/
                switch mood {
                case .happy :
                    return Returnable(type: .scale, value: Constants.MajorScales.random().rawValue)
                case .neutral:
                    return Returnable(type: .scale, value: Constants.NeutralScales.random().rawValue)
                case .sad:
                    return Returnable(type: .scale, value: Constants.MinorScales.random().rawValue)
                }
                /*#-code-walkthrough(5.modifier)*/
                
            }
            else {
                lastWord += letter
                let scaleArr = scale.split(separator: " ")
                if let index = scaleArr.firstIndex(of: String.SubSequence(stringLiteral: lastNote)) {
                    var newIndex = 0
                    var found = false
                    while found == false {
                        newIndex = index+Int.random(in: -2...2)
                        if !(newIndex < 0 || newIndex >= scale.split(separator: " ").count) {
                            found = true
                        }
                    }
                    // Get new Note based on the newIndex randomly generated
                    let newNote = scale.split(separator: " ")[newIndex]
                    lastNote = String(newNote)
                    return Returnable(type: .note, value: String(newNote))
                }
                else {
                    let newNote = scale.split(separator: " ")[Int.random(in: 0..<scale.split(separator: " ").count)]
                    lastNote = String(newNote)
                    return Returnable(type: .note, value: String(newNote))
                }
            }
        }
        
        // Determines if a word is positive
        /*#-code-walkthrough(6.modifier)*/
        mutating public func positiveWords(word: String) throws {
            if positiveWordList.contains(word.replacingOccurrences(of: ".", with: "")) && word.count > 2 {
                positiveWordCount += 1
            }
        }
        /*#-code-walkthrough(6.modifier)*/
    }
}
