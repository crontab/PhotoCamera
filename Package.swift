// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PhotoCamera",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PhotoCamera",
            targets: ["PhotoCamera"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PhotoCamera",
            dependencies: [],
            path: "PhotoCamera/Sources"
        ),
    ],
	swiftLanguageModes: [.version("6")]
)
