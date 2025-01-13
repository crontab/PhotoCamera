/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Supporting data types for the app.
*/

import AVFoundation
import UIKit.UIImage


// MARK: - Supporting types

/// An enumeration that describes the current status of the camera.
enum CameraStatus {
    /// The initial status upon creation.
    case unknown
    /// A status that indicates a person disallows access to the camera
    case unauthorized
    /// A status that indicates the camera failed to start.
    case failed
    /// A status that indicates the camera is successfully running.
    case running
}

/// An enumeration that defines the activity states the capture service supports.
///
/// This type provides feedback to the UI regarding the active status of the `CaptureService` actor.
enum CaptureActivity {
    case willCapture
    case didCapture(uiImage: UIImage?)
    case didImport(uiImage: UIImage?)
}

enum CameraError: Error {
    case videoDeviceUnavailable
    case addInputFailed
    case addOutputFailed
    case setupFailed
    case deviceChangeFailed
}
