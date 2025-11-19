
/// RFC 7231: Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content
///
/// This module implements HTTP/1.1 semantics and content types
/// as specified in RFC 7231. This includes HTTP methods, status codes,
/// and content negotiation.
///
/// Example usage:
/// ```swift
/// let method = RFC_7231.Method.get
/// print(method.isSafe) // true
/// print(method.isIdempotent) // true
///
/// // Custom methods are supported
/// let customMethod = RFC_7231.Method("PROPFIND")
/// ```
public enum RFC_7231 {}

// MARK: - HTTP Method

extension RFC_7231 {
    /// HTTP request method as defined in RFC 7231 Section 4
    ///
    /// This type represents HTTP request methods with support for both
    /// standard methods defined in RFC 7231 and extension methods.
    ///
    /// Standard methods are provided as static properties:
    /// ```swift
    /// let method = RFC_7231.Method.get
    /// print(method.isSafe)       // true
    /// print(method.isIdempotent) // true
    /// print(method.isCacheable)  // true
    /// ```
    ///
    /// Extension methods can be created using the initializer:
    /// ```swift
    /// let webdavMethod = RFC_7231.Method("PROPFIND")
    /// print(webdavMethod.isSafe) // false (defaults to false)
    ///
    /// // Or specify properties explicitly for custom methods:
    /// let customMethod = RFC_7231.Method(
    ///     "REPORT",
    ///     isSafe: true,
    ///     isIdempotent: true,
    ///     isCacheable: false
    /// )
    /// ```
    public struct Method: Hashable, Sendable, Codable, RawRepresentable {
        public let rawValue: String

        /// Whether this method is safe per RFC 7231 Section 4.2.1
        ///
        /// Safe methods are essentially read-only and do not cause
        /// observable side effects on the server.
        public let isSafe: Bool

        /// Whether this method is idempotent per RFC 7231 Section 4.2.2
        ///
        /// Idempotent methods produce the same result when executed
        /// multiple times, allowing safe automatic retry after failures.
        public let isIdempotent: Bool

        /// Whether responses to this method are cacheable per RFC 7231 Section 4.2.3
        ///
        /// Cacheable methods allow their responses to be stored for future reuse.
        public let isCacheable: Bool

        /// Creates an HTTP method directly with specified properties.
        ///
        /// This is the base initializer used by standard method constants.
        ///
        /// - Parameters:
        ///   - rawValue: The HTTP method name (e.g., "GET", "POST")
        ///   - isSafe: Whether the method is safe
        ///   - isIdempotent: Whether the method is idempotent
        ///   - isCacheable: Whether responses are cacheable
        public init(
            _ rawValue: String,
            isSafe: Bool,
            isIdempotent: Bool,
            isCacheable: Bool
        ) {
            self.rawValue = rawValue
            self.isSafe = isSafe
            self.isIdempotent = isIdempotent
            self.isCacheable = isCacheable
        }

        /// Creates an HTTP method from a raw string value.
        ///
        /// If the rawValue matches a standard method, the standard properties are used.
        /// Otherwise, defaults to unsafe, non-idempotent, non-cacheable.
        ///
        /// - Parameter rawValue: The HTTP method name (e.g., "GET", "POST", "PROPFIND")
        public init(rawValue: String) {
            // Check if this is a standard method and use its properties
            switch rawValue {
            case "GET":
                self = .get
            case "HEAD":
                self = .head
            case "POST":
                self = .post
            case "PUT":
                self = .put
            case "DELETE":
                self = .delete
            case "CONNECT":
                self = .connect
            case "OPTIONS":
                self = .options
            case "TRACE":
                self = .trace
            case "PATCH":
                self = .patch
            default:
                // Custom method: defaults to unsafe, non-idempotent, non-cacheable
                self.init(rawValue, isSafe: false, isIdempotent: false, isCacheable: false)
            }
        }

        // MARK: Standard Methods

        /// GET method (RFC 7231 Section 4.3.1)
        ///
        /// Safe, idempotent, and cacheable.
        public static let get = Method(
            "GET",
            isSafe: true,
            isIdempotent: true,
            isCacheable: true
        )

        /// HEAD method (RFC 7231 Section 4.3.2)
        ///
        /// Safe, idempotent, and cacheable. Identical to GET except no response body.
        public static let head = Method(
            "HEAD",
            isSafe: true,
            isIdempotent: true,
            isCacheable: true
        )

        /// POST method (RFC 7231 Section 4.3.3)
        ///
        /// Not safe, not idempotent, but cacheable (with explicit freshness).
        ///
        /// Note: While POST is technically cacheable per RFC 7231 Section 4.2.3,
        /// most cache implementations only support GET and HEAD.
        public static let post = Method(
            "POST",
            isSafe: false,
            isIdempotent: false,
            isCacheable: true
        )

        /// PUT method (RFC 7231 Section 4.3.4)
        ///
        /// Not safe, but idempotent. Not cacheable.
        public static let put = Method(
            "PUT",
            isSafe: false,
            isIdempotent: true,
            isCacheable: false
        )

        /// DELETE method (RFC 7231 Section 4.3.5)
        ///
        /// Not safe, but idempotent. Not cacheable.
        public static let delete = Method(
            "DELETE",
            isSafe: false,
            isIdempotent: true,
            isCacheable: false
        )

        /// CONNECT method (RFC 7231 Section 4.3.6)
        ///
        /// Not safe, not idempotent, not cacheable.
        public static let connect = Method(
            "CONNECT",
            isSafe: false,
            isIdempotent: false,
            isCacheable: false
        )

        /// OPTIONS method (RFC 7231 Section 4.3.7)
        ///
        /// Safe, idempotent, not cacheable.
        public static let options = Method(
            "OPTIONS",
            isSafe: true,
            isIdempotent: true,
            isCacheable: false
        )

        /// TRACE method (RFC 7231 Section 4.3.8)
        ///
        /// Safe, idempotent, not cacheable.
        public static let trace = Method(
            "TRACE",
            isSafe: true,
            isIdempotent: true,
            isCacheable: false
        )

        /// PATCH method (RFC 5789)
        ///
        /// Not safe, not idempotent, not cacheable.
        public static let patch = Method(
            "PATCH",
            isSafe: false,
            isIdempotent: false,
            isCacheable: false
        )

        // MARK: Equatable

        public static func == (lhs: Method, rhs: Method) -> Bool {
            lhs.rawValue == rhs.rawValue &&
            lhs.isSafe == rhs.isSafe &&
            lhs.isIdempotent == rhs.isIdempotent &&
            lhs.isCacheable == rhs.isCacheable
        }

        // MARK: Hashable

        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
            hasher.combine(isSafe)
            hasher.combine(isIdempotent)
            hasher.combine(isCacheable)
        }

        // MARK: Codable

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            self.init(rawValue: string)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
}
