/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An object that provides the interface to the features of the camera.
*/

@preconcurrency import AVFoundation
//import SwiftUI

/// An object that provides the interface to the features of the camera.
///
@Observable
@MainActor
final class Camera {

    /// The app's capture session.
    var captureSession: AVCaptureSession { captureService.captureSession }

    /// The activity stream for indicating capture stages
    var activityStream: AsyncStream<CaptureActivity> { captureService.activityStream }

    /// The current status of the camera, such as unauthorized, running, or failed.
    private(set) var status = CameraStatus.unknown

    /// A Boolean value that indicates whether the app is currently switching video devices.
    private(set) var isSwitchingVideoDevices = false

    /// A Boolean value that indicates whether the app is currently switching capture modes.
    private(set) var isSwitchingModes = false

    /// An error that indicates the details of an error during photo or movie capture.
    private(set) var error: Error?

    /// An object that manages the app's capture functionality.
    private let captureService: CaptureService

    init(forSelfie: Bool = false) {
        self.captureService = CaptureService(forSelfie: forSelfie)
    }

    init(status: CameraStatus) { // for previews only
        self.status = status
        self.captureService = CaptureService(forSelfie: false)
    }

    // MARK: - Starting the camera
    /// Start the camera and begin the stream of data.
    func start() async {
        guard !Self.isPreview else {
            status = .running
            return
        }

        // Verify that the person authorizes the app to use device cameras.
        guard await captureService.isAuthorized else {
            status = .unauthorized
            return
        }
        do {
            // Start the capture service to start the flow of data.
            try await captureService.start()
            status = .running
        } catch {
            logger.error("Failed to start capture service. \(error)")
            status = .failed
        }
    }
    
    // MARK: - Changing devices

    /// Selects the next available video device for capture.
    func switchVideoDevices() async {
        guard !Self.isPreview else { return }
        isSwitchingVideoDevices = true
        defer { isSwitchingVideoDevices = false }
        await captureService.selectNextVideoDevice()
    }
    
    // MARK: - Photo capture
    
    /// Captures a photo
    func capturePhoto() async {
        guard !Self.isPreview else { return }
        await captureService.capturePhoto()
        logger.info("Photo captured")
    }

    /// Performs a focus and expose operation at the specified screen point.
    func focusAndExpose(at point: CGPoint) async {
        guard !Self.isPreview else { return }
        await captureService.focusAndExpose(at: point)
    }

    private static let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
