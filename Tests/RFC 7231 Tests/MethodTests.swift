import Testing
import RFC_7231

@Suite("HTTP Method")
struct MethodTests {

    // MARK: - Static Properties Tests

    @Test("GET method properties")
    func getMethod() {
        let method = RFC_7231.Method.get
        #expect(method.rawValue == "GET")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == true)
    }

    @Test("HEAD method properties")
    func headMethod() {
        let method = RFC_7231.Method.head
        #expect(method.rawValue == "HEAD")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == true)
    }

    @Test("POST method properties")
    func postMethod() {
        let method = RFC_7231.Method.post
        #expect(method.rawValue == "POST")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == true)
    }

    @Test("PUT method properties")
    func putMethod() {
        let method = RFC_7231.Method.put
        #expect(method.rawValue == "PUT")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("DELETE method properties")
    func deleteMethod() {
        let method = RFC_7231.Method.delete
        #expect(method.rawValue == "DELETE")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("CONNECT method properties")
    func connectMethod() {
        let method = RFC_7231.Method.connect
        #expect(method.rawValue == "CONNECT")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == false)
    }

    @Test("OPTIONS method properties")
    func optionsMethod() {
        let method = RFC_7231.Method.options
        #expect(method.rawValue == "OPTIONS")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("TRACE method properties")
    func traceMethod() {
        let method = RFC_7231.Method.trace
        #expect(method.rawValue == "TRACE")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("PATCH method properties")
    func patchMethod() {
        let method = RFC_7231.Method.patch
        #expect(method.rawValue == "PATCH")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == false)
    }

    // MARK: - RawRepresentable Init Tests

    @Test("RawRepresentable init recognizes GET")
    func rawRepresentableGET() {
        let method = RFC_7231.Method(rawValue: "GET")
        #expect(method == .get)
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == true)
    }

    @Test("RawRepresentable init recognizes POST")
    func rawRepresentablePOST() {
        let method = RFC_7231.Method(rawValue: "POST")
        #expect(method == .post)
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == true)
    }

    @Test("RawRepresentable init recognizes all standard methods")
    func rawRepresentableAllStandard() {
        #expect(RFC_7231.Method(rawValue: "GET") == .get)
        #expect(RFC_7231.Method(rawValue: "HEAD") == .head)
        #expect(RFC_7231.Method(rawValue: "POST") == .post)
        #expect(RFC_7231.Method(rawValue: "PUT") == .put)
        #expect(RFC_7231.Method(rawValue: "DELETE") == .delete)
        #expect(RFC_7231.Method(rawValue: "CONNECT") == .connect)
        #expect(RFC_7231.Method(rawValue: "OPTIONS") == .options)
        #expect(RFC_7231.Method(rawValue: "TRACE") == .trace)
        #expect(RFC_7231.Method(rawValue: "PATCH") == .patch)
    }

    @Test("RawRepresentable init with custom method (defaults)")
    func rawRepresentableCustomDefaults() {
        let method = RFC_7231.Method(rawValue: "PROPFIND")
        #expect(method.rawValue == "PROPFIND")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == false)
    }

    @Test("RawRepresentable init with WebDAV methods")
    func rawRepresentableWebDAV() {
        let propfind = RFC_7231.Method(rawValue: "PROPFIND")
        let proppatch = RFC_7231.Method(rawValue: "PROPPATCH")
        let mkcol = RFC_7231.Method(rawValue: "MKCOL")
        let copy = RFC_7231.Method(rawValue: "COPY")
        let move = RFC_7231.Method(rawValue: "MOVE")

        #expect(propfind.rawValue == "PROPFIND")
        #expect(proppatch.rawValue == "PROPPATCH")
        #expect(mkcol.rawValue == "MKCOL")
        #expect(copy.rawValue == "COPY")
        #expect(move.rawValue == "MOVE")

        // All custom methods default to unsafe, non-idempotent, non-cacheable
        for method in [propfind, proppatch, mkcol, copy, move] {
            #expect(method.isSafe == false)
            #expect(method.isIdempotent == false)
            #expect(method.isCacheable == false)
        }
    }

    // MARK: - Base Init Tests

    @Test("Base init with all parameters")
    func baseInitComplete() {
        let method = RFC_7231.Method(
            "CUSTOM",
            isSafe: true,
            isIdempotent: true,
            isCacheable: false
        )
        #expect(method.rawValue == "CUSTOM")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("Base init for custom safe idempotent method")
    func baseInitSafeIdempotent() {
        let method = RFC_7231.Method(
            "REPORT",
            isSafe: true,
            isIdempotent: true,
            isCacheable: false
        )
        #expect(method.rawValue == "REPORT")
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == false)
    }

    @Test("Base init allows overriding standard method properties")
    func baseInitOverride() {
        // This is unusual but should be possible with the base init
        let weirdGet = RFC_7231.Method(
            "GET",
            isSafe: false,
            isIdempotent: false,
            isCacheable: false
        )
        #expect(weirdGet.rawValue == "GET")
        #expect(weirdGet.isSafe == false)
        #expect(weirdGet != .get) // Different properties
    }

    // MARK: - Hashable & Equatable Tests

    @Test("Method equality based on all properties")
    func methodEquality() {
        let method1 = RFC_7231.Method("TEST", isSafe: true, isIdempotent: true, isCacheable: false)
        let method2 = RFC_7231.Method("TEST", isSafe: true, isIdempotent: true, isCacheable: false)
        let method3 = RFC_7231.Method("TEST", isSafe: false, isIdempotent: true, isCacheable: false)

        #expect(method1 == method2)
        #expect(method1 != method3) // Different isSafe property
    }

    @Test("Method hashing")
    func methodHashing() {
        let method1 = RFC_7231.Method.get
        let method2 = RFC_7231.Method(rawValue: "GET")
        let method3 = RFC_7231.Method.post

        var set = Set<RFC_7231.Method>()
        set.insert(method1)
        set.insert(method2)
        set.insert(method3)

        #expect(set.count == 2) // method1 and method2 are equal
        #expect(set.contains(.get))
        #expect(set.contains(.post))
    }

    @Test("Method dictionary keys")
    func methodDictionaryKeys() {
        var dict: [RFC_7231.Method: String] = [:]
        dict[.get] = "GET endpoint"
        dict[.post] = "POST endpoint"
        dict[RFC_7231.Method(rawValue: "GET")] = "Updated GET"

        #expect(dict.count == 2)
        #expect(dict[.get] == "Updated GET")
        #expect(dict[.post] == "POST endpoint")
    }

    // MARK: - Codable Tests

    @Test("Encode method to JSON")
    func encodeMethod() throws {
        let method = RFC_7231.Method.post
        let encoder = JSONEncoder()
        let data = try encoder.encode(method)
        let string = String(data: data, encoding: .utf8)
        #expect(string == "\"POST\"")
    }

    @Test("Decode method from JSON")
    func decodeMethod() throws {
        let json = "\"GET\"".data(using: .utf8)!
        let decoder = JSONDecoder()
        let method = try decoder.decode(RFC_7231.Method.self, from: json)
        #expect(method == .get)
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
        #expect(method.isCacheable == true)
    }

    @Test("Decode custom method from JSON")
    func decodeCustomMethod() throws {
        let json = "\"PROPFIND\"".data(using: .utf8)!
        let decoder = JSONDecoder()
        let method = try decoder.decode(RFC_7231.Method.self, from: json)
        #expect(method.rawValue == "PROPFIND")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == false)
    }

    @Test("Round-trip encode/decode standard method")
    func roundTripStandardMethod() throws {
        let original = RFC_7231.Method.delete
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(RFC_7231.Method.self, from: data)

        #expect(decoded == original)
        #expect(decoded.rawValue == "DELETE")
        #expect(decoded.isSafe == false)
        #expect(decoded.isIdempotent == true)
        #expect(decoded.isCacheable == false)
    }

    @Test("Round-trip encode/decode custom method")
    func roundTripCustomMethod() throws {
        let original = RFC_7231.Method("SEARCH", isSafe: true, isIdempotent: true, isCacheable: true)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(original)
        let decoded = try decoder.decode(RFC_7231.Method.self, from: data)

        #expect(decoded.rawValue == "SEARCH")
        // Note: Custom properties are lost in round-trip because we only encode rawValue
        // The decoder will use defaults for custom methods
        #expect(decoded.isSafe == false) // defaults to false
        #expect(decoded.isIdempotent == false) // defaults to false
        #expect(decoded.isCacheable == false) // defaults to false
    }

    @Test("Encode array of methods")
    func encodeMethodArray() throws {
        let methods: [RFC_7231.Method] = [.get, .post, .put]
        let encoder = JSONEncoder()
        let data = try encoder.encode(methods)
        let string = String(data: data, encoding: .utf8)
        #expect(string == "[\"GET\",\"POST\",\"PUT\"]")
    }

    // MARK: - Case Sensitivity Tests

    @Test("Method rawValue is case sensitive")
    func caseSensitivity() {
        let upperGet = RFC_7231.Method(rawValue: "GET")
        let lowerGet = RFC_7231.Method(rawValue: "get")
        let mixedGet = RFC_7231.Method(rawValue: "Get")

        #expect(upperGet == .get) // Standard method recognized
        #expect(lowerGet != .get) // Not recognized, custom method
        #expect(mixedGet != .get) // Not recognized, custom method

        #expect(lowerGet.rawValue == "get")
        #expect(mixedGet.rawValue == "Get")

        // Non-standard case becomes custom methods with default properties
        #expect(lowerGet.isSafe == false)
        #expect(lowerGet.isIdempotent == false)
        #expect(lowerGet.isCacheable == false)
    }

    // MARK: - RawRepresentable Map Tests

    @Test("Creating methods from array of strings")
    func mapFromStrings() {
        let methodStrings = ["GET", "POST", "PROPFIND", "DELETE"]
        let methods = methodStrings.map { RFC_7231.Method(rawValue: $0) }

        #expect(methods.count == 4)
        #expect(methods[0] == .get)
        #expect(methods[1] == .post)
        #expect(methods[2].rawValue == "PROPFIND")
        #expect(methods[3] == .delete)
    }

    // MARK: - Sendable Tests

    @Test("Method is Sendable")
    func sendableConformance() {
        // This test verifies that Method conforms to Sendable
        // If it compiles, the test passes
        let method: RFC_7231.Method = .get
        Task {
            let _ = method // Can be captured in Task
        }
    }

    // MARK: - Edge Cases

    @Test("Empty string method")
    func emptyStringMethod() {
        let method = RFC_7231.Method(rawValue: "")
        #expect(method.rawValue == "")
        #expect(method.isSafe == false)
        #expect(method.isIdempotent == false)
        #expect(method.isCacheable == false)
    }

    @Test("Very long method name")
    func longMethodName() {
        let longName = String(repeating: "A", count: 1000)
        let method = RFC_7231.Method(rawValue: longName)
        #expect(method.rawValue == longName)
        #expect(method.isSafe == false)
    }

    @Test("Method with special characters")
    func specialCharactersMethod() {
        // While not RFC-compliant, the type should handle it
        let method = RFC_7231.Method(rawValue: "GET-SPECIAL")
        #expect(method.rawValue == "GET-SPECIAL")
        #expect(method.isSafe == false)
    }

    @Test("Method with numbers")
    func numbersInMethod() {
        let method = RFC_7231.Method(rawValue: "METHOD123")
        #expect(method.rawValue == "METHOD123")
        #expect(method.isSafe == false)
    }

    // MARK: - Documentation Examples Tests

    @Test("Documentation example 1 - using static property")
    func docExample1() {
        let method = RFC_7231.Method.get
        #expect(method.isSafe == true)
        #expect(method.isIdempotent == true)
    }

    @Test("Documentation example 2 - custom method")
    func docExample2() {
        let customMethod = RFC_7231.Method(rawValue: "PROPFIND")
        #expect(customMethod.rawValue == "PROPFIND")
    }

    @Test("Documentation example 3 - explicit properties")
    func docExample3() {
        let customMethod = RFC_7231.Method(
            "REPORT",
            isSafe: true,
            isIdempotent: true,
            isCacheable: false
        )
        #expect(customMethod.rawValue == "REPORT")
        #expect(customMethod.isSafe == true)
        #expect(customMethod.isIdempotent == true)
        #expect(customMethod.isCacheable == false)
    }
}
