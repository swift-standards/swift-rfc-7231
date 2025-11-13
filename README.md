# swift-rfc-7231

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Swift namespace types for RFC 7231: Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content

## Overview

This package provides Swift namespace types for HTTP/1.1 semantics as defined in [RFC 7231](https://www.rfc-editor.org/rfc/rfc7231.html). This package defines the RFC 7231 namespace enum and Method type for extension by parser implementations.

## Features

- ✅ RFC 7231 namespace enum
- ✅ Method type for parser extensions (RFC 7231 section 4)
- ✅ Swift 6 strict concurrency support
- ✅ Full `Sendable` conformance

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-rfc-7231.git", from: "0.1.0")
]
```

## Usage

This package provides namespace types that are extended by parser implementations (e.g., swift-url-routing):

```swift
import RFC_7231

// Parser implementations extend RFC_7231.Method
extension RFC_7231.Method {
  public struct Parser: ParserPrinter { ... }
}
```

## Related Packages

- [swift-url-routing](https://github.com/pointfreeco/swift-url-routing) - Provides parser implementations

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
