import SwiftUI
import CoreImage
import AVFoundation
import UIKit


struct SmileView: View {
    
    @Binding var page: Constants.ScreenTypes
    
    @State var isSmiling = false
    @State var smileCount = 0
    
    @State var isShowingAlert = true
    @State var alertType: AlertTypes = .askToSmile
    
    var body: some View {
        ZStack {
            if isShowingAlert == false {
                CameraView { smile in isSmiling = smile }.onChange(of: isSmiling, perform: { _ in
                    if isSmiling && isShowingAlert == false {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            if isSmiling {
                                smileCount += 1
                                if smileCount >= 4 {
                                    alertType = .completed
                                    isShowingAlert = true
                                    timer.invalidate()
                                }
                            }
                        }
                    }
                })
            }
            VStack {
                Text(isSmiling ? "😊" : "😐")
                    .font(.custom("Rockwell", size: 300))
                if isShowingAlert == false {
                    Text(isSmiling ? "few more seconds!" : "you're not smiling :( i need you to smile!")
                        .font(.custom("Rockwell", size: 45))
                }
            }
            if isShowingAlert {
                AlertView(mood: .happy, alertType: alertType, showAlert: $isShowingAlert, page: $page)
            }
        }.onChange(of: isShowingAlert, perform: { _ in
            if alertType == .completed && isShowingAlert == false {
                page = .main
            }
        })
    }
}

// Converts View Controller into SwiftUI Representable View
/*#-code-walkthrough(1.smile)*/
struct CameraView: UIViewControllerRepresentable {
    var isSmiling: ((Bool) -> Void)?
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.isSmiling = isSmiling
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// UIKit View Controller
class CameraViewController: UIViewController {
/*#-code-walkthrough(1.smile)*/
    var isSmiling: ((Bool) -> Void)?
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    let smileDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    // Gets the main camera and creates an input-output layer
    /*#-code-walkthrough(2.smile)*/
    func setupCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        captureSession.addOutput(output)
        
        captureSession.startRunning()
    }
    /*#-code-walkthrough(2.smile)*/
}

// Core Image detects if the user is smiling
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        /*#-code-walkthrough(3.smile)*/
        let features = smileDetector?.features(in: ciImage, options: [CIDetectorSmile: true])
        /*#-code-walkthrough(3.smile)*/
        
        if let face = features?.first as? CIFaceFeature {
            /*#-code-walkthrough(4.smile)*/
            isSmiling?(face.hasSmile)
            /*#-code-walkthrough(4.smile)*/
        }
    }
}
