import XCTest
@testable import LicensePlistCore

/// The testcase is for most outer integration tests.
class ProcessPlistProcessTests: XCTestCase {

    let testOutputURL: URL = FileManager.default.temporaryDirectory.appendingPathComponent("LicensePlistTestOutputsDir")

    override func setUpWithError() throws {
        try super.setUpWithError()

        // `tearDownWithError` doesn't be called if the test raises `fatalError`. This step covers the case.
        try? FileManager.default.removeItem(at: testOutputURL)
        try FileManager.default.createDirectory(at: testOutputURL, withIntermediateDirectories: false)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        try FileManager.default.removeItem(at: testOutputURL)
    }

    func testProcessSwiftPackage() throws {

        let testResolvedPackageFileURL = URL(fileURLWithPath: TestUtil.testResourceDir.appendingPathComponent("Package.resolved").absoluteString)

        let option = Options(outputPath: testOutputURL,
                             cartfilePath: URL(fileURLWithPath: Consts.cartfileName),
                             mintfilePath: URL(fileURLWithPath: Consts.mintfileName),
                             podsPath: URL(fileURLWithPath: Consts.podsDirectoryName),
                             packagePaths: [testResolvedPackageFileURL],
                             xcworkspacePath: URL(fileURLWithPath: "*.xcworkspace"),
                             xcodeprojPath: URL(fileURLWithPath: "*.xcodeproj"),
                             prefix: Consts.prefix,
                             gitHubToken: nil,
                             htmlPath: nil,
                             markdownPath: nil,
                             config: Config.empty)

        let licensePlist = LicensePlistCore.LicensePlist()
        licensePlist.process(options: option)

        let latestResultTextURL = testOutputURL.appendingPathComponent("com.mono0926.LicensePlist.latest_result.txt")
        let latestResultText = try String(contentsOf: latestResultTextURL, encoding: .utf8)
        let expectationText = """
        name: APIKit, nameSpecified: APIKit, owner: ishkawa, version: 4.1.0, source: https://github.com/ishkawa/APIKit

        name: Commander, nameSpecified: Commander, owner: kylef, version: 0.8.0, source: https://github.com/kylef/Commander

        name: HeliumLogger, nameSpecified: HeliumLogger, owner: Kitura, version: 1.8.1, source: https://github.com/Kitura/HeliumLogger

        name: LoggerAPI, nameSpecified: LoggerAPI, owner: Kitura, version: 1.8.1, source: https://github.com/Kitura/LoggerAPI

        name: Result, nameSpecified: Result, owner: antitypical, version: 4.1.0, source: https://github.com/antitypical/Result

        name: Spectre, nameSpecified: Spectre, owner: kylef, version: 0.9.0, source: https://github.com/kylef/Spectre

        name: swift-html-entities, nameSpecified: HTMLEntities, owner: Kitura, version: 3.0.13, source: https://github.com/Kitura/swift-html-entities

        name: YamlSwift, nameSpecified: Yaml, owner: behrang, version: 3.4.4, source: https://github.com/behrang/YamlSwift

        add-version-numbers: false

        LicensePlist Version: \(Consts.version)
        """

        XCTAssertEqual(latestResultText, expectationText)
    }

}
