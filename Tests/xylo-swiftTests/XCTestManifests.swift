import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(xylo_swiftTests.allTests),
    ]
}
#endif
