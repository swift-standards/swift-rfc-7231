// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-rfc-7231",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "RFC 7231",
            targets: ["RFC 7231"]
        )
    ],
    targets: [
        .target(
            name: "RFC 7231"
        ),
        .testTarget(
            name: "RFC 7231 Tests",
            dependencies: ["RFC 7231"]
        )
    ]
)

for target in package.targets {
    target.swiftSettings?.append(
        contentsOf: [
            .enableUpcomingFeature("MemberImportVisibility")
        ]
    )
}
