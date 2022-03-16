//
//  SwiftPackageManagerTests.swift
//  APIKit
//
//  Created by Matthias Buchetics on 20.09.19.
//

import Foundation
import XCTest
@testable import LicensePlistCore

class SwiftPackageManagerTests: XCTestCase {
    func testDecodingV1() throws {
        let jsonString = """
            {
              "package": "APIKit",
              "repositoryURL": "https://github.com/ishkawa/APIKit.git",
              "state": {
                "branch": null,
                "revision": "86d51ecee0bc0ebdb53fb69b11a24169a69097ba",
                "version": "4.1.0"
              }
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let package = try JSONDecoder().decode(SwiftPackageV1.self, from: data)

        XCTAssertEqual(package.package, "APIKit")
        XCTAssertEqual(package.repositoryURL, "https://github.com/ishkawa/APIKit.git")
        XCTAssertEqual(package.state.revision, "86d51ecee0bc0ebdb53fb69b11a24169a69097ba")
        XCTAssertEqual(package.state.version, "4.1.0")
    }

    func testDecodingOfURLWithDotsV1() throws {
        let jsonString = """
            {
              "package": "R.swift.Library",
              "repositoryURL": "https://github.com/mac-cain13/R.swift.Library",
              "state": {
                "branch": "master",
                "revision": "3365947d725398694d6ed49f2e6622f05ca3fc0f",
                "version": null
              }
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let package = try JSONDecoder().decode(SwiftPackageV1.self, from: data)

        XCTAssertEqual(package.package, "R.swift.Library")
        XCTAssertEqual(package.repositoryURL, "https://github.com/mac-cain13/R.swift.Library")
        XCTAssertEqual(package.state.revision, "3365947d725398694d6ed49f2e6622f05ca3fc0f")
        XCTAssertNil(package.state.version)
    }

    func testDecodingOptionalVersionV1() throws {
        let jsonString = """
            {
              "package": "APIKit",
              "repositoryURL": "https://github.com/ishkawa/APIKit.git",
              "state": {
                "branch": "master",
                "revision": "86d51ecee0bc0ebdb53fb69b11a24169a69097ba",
                "version": null
              }
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let package = try JSONDecoder().decode(SwiftPackageV1.self, from: data)

        XCTAssertEqual(package.package, "APIKit")
        XCTAssertEqual(package.repositoryURL, "https://github.com/ishkawa/APIKit.git")
        XCTAssertEqual(package.state.revision, "86d51ecee0bc0ebdb53fb69b11a24169a69097ba")
        XCTAssertEqual(package.state.branch, "master")
        XCTAssertNil(package.state.version)
    }

    func testDecodingResolvedPackageV1() throws {
        let jsonString = """
            {
              "object": {
                "pins": [
                  {
                    "package": "APIKit",
                    "repositoryURL": "https://github.com/ishkawa/APIKit.git",
                    "state": {
                      "branch": null,
                      "revision": "86d51ecee0bc0ebdb53fb69b11a24169a69097ba",
                      "version": "4.1.0"
                    }
                  },
                  {
                    "package": "Commander",
                    "repositoryURL": "https://github.com/kylef/Commander.git",
                    "state": {
                      "branch": null,
                      "revision": "e5b50ad7b2e91eeb828393e89b03577b16be7db9",
                      "version": "0.8.0"
                    }
                  }
                ]
              },
              "version": 1
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let resolvedPackage = try JSONDecoder().decode(ResolvedPackagesV1.self, from: data)

        XCTAssertEqual(resolvedPackage.version, 1)
        XCTAssertEqual(resolvedPackage.object.pins.count, 2)

        XCTAssertEqual(resolvedPackage.object.pins[0].package, "APIKit")
        XCTAssertEqual(resolvedPackage.object.pins[0].repositoryURL, "https://github.com/ishkawa/APIKit.git")
        XCTAssertEqual(resolvedPackage.object.pins[0].state.revision, "86d51ecee0bc0ebdb53fb69b11a24169a69097ba")
        XCTAssertNil(resolvedPackage.object.pins[0].state.branch)
        XCTAssertEqual(resolvedPackage.object.pins[0].state.version, "4.1.0")

        XCTAssertEqual(resolvedPackage.object.pins[1].package, "Commander")
        XCTAssertEqual(resolvedPackage.object.pins[1].repositoryURL, "https://github.com/kylef/Commander.git")
        XCTAssertEqual(resolvedPackage.object.pins[1].state.revision, "e5b50ad7b2e91eeb828393e89b03577b16be7db9")
        XCTAssertNil(resolvedPackage.object.pins[1].state.branch)
        XCTAssertEqual(resolvedPackage.object.pins[1].state.version, "0.8.0")

    }

    func testDecodingWithVersionV2() throws {
        let jsonString = """
            {
              "identity" : "APIKit",
              "kind" : "remoteSourceControl",
              "location" : "https://github.com/ishkawa/APIKit.git",
              "state" : {
                "revision" : "86d51ecee0bc0ebdb53fb69b11a24169a69097ba",
                "version" : "4.1.0"
              }
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let package = try JSONDecoder().decode(SwiftPackageV2.self, from: data)

        XCTAssertEqual(package.identity, "APIKit")
        XCTAssertEqual(package.location, "https://github.com/ishkawa/APIKit.git")
        XCTAssertEqual(package.state.revision, "86d51ecee0bc0ebdb53fb69b11a24169a69097ba")
        XCTAssertNil(package.state.branch)
        XCTAssertEqual(package.state.version, "4.1.0")
    }

    func testDecodingWithBranchV2() throws {
        let jsonString = """
            {
              "identity" : "APIKit",
              "kind" : "remoteSourceControl",
              "location" : "https://github.com/ishkawa/APIKit.git",
              "state" : {
                "branch" : "master",
                "revision" : "86d51ecee0bc0ebdb53fb69b11a24169a69097ba"
              }
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let package = try JSONDecoder().decode(SwiftPackageV2.self, from: data)

        XCTAssertEqual(package.identity, "APIKit")
        XCTAssertEqual(package.location, "https://github.com/ishkawa/APIKit.git")
        XCTAssertEqual(package.state.revision, "86d51ecee0bc0ebdb53fb69b11a24169a69097ba")
        XCTAssertEqual(package.state.branch, "master")
        XCTAssertNil(package.state.version)
    }

    func testDecodingResolvedPackageV2() throws {
        let jsonString = """
            {
              "pins" : [
                {
                  "identity" : "dznemptydataset",
                  "kind" : "remoteSourceControl",
                  "location" : "https://github.com/dzenbot/DZNEmptyDataSet",
                  "state" : {
                    "branch" : "master",
                    "revision" : "9bffa69a83a9fa58a14b3cf43cb6dd8a63774179"
                  }
                },
                {
                  "identity" : "version",
                  "kind" : "remoteSourceControl",
                  "location" : "https://github.com/mxcl/Version",
                  "state" : {
                    "revision" : "1fe824b80d89201652e7eca7c9252269a1d85e25",
                    "version" : "2.0.1"
                  }
                }
              ],
              "version" : 2
            }
        """

        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let resolvedPackage = try JSONDecoder().decode(ResolvedPackagesV2.self, from: data)

        XCTAssertEqual(resolvedPackage.version, 2)
        XCTAssertEqual(resolvedPackage.pins.count, 2)

        XCTAssertEqual(resolvedPackage.pins[0].identity, "dznemptydataset")
        XCTAssertEqual(resolvedPackage.pins[0].location, "https://github.com/dzenbot/DZNEmptyDataSet")
        XCTAssertEqual(resolvedPackage.pins[0].state.branch, "master")
        XCTAssertEqual(resolvedPackage.pins[0].state.revision, "9bffa69a83a9fa58a14b3cf43cb6dd8a63774179")

        XCTAssertEqual(resolvedPackage.pins[1].identity, "version")
        XCTAssertEqual(resolvedPackage.pins[1].location, "https://github.com/mxcl/Version")
        XCTAssertEqual(resolvedPackage.pins[1].state.version, "2.0.1")
        XCTAssertEqual(resolvedPackage.pins[1].state.revision, "1fe824b80d89201652e7eca7c9252269a1d85e25")
    }

    func testConvertToGithub() {
        let package = SwiftPackage(package: "Commander",
                                   repositoryURL: "https://github.com/kylef/Commander.git",
                                   revision: "e5b50ad7b2e91eeb828393e89b03577b16be7db9",
                                   version: "0.8.0")
        let result = package.toGitHub(renames: [:])
        XCTAssertEqual(result, GitHub(name: "Commander", nameSpecified: "Commander", owner: "kylef", version: "0.8.0"))
    }

    func testConvertToGithubNameWithDots() {
        let package = SwiftPackage(package: "R.swift.Library",
                                   repositoryURL: "https://github.com/mac-cain13/R.swift.Library",
                                   revision: "3365947d725398694d6ed49f2e6622f05ca3fc0f",
                                   version: nil)
        let result = package.toGitHub(renames: [:])
        XCTAssertEqual(result, GitHub(name: "R.swift.Library", nameSpecified: "R.swift.Library", owner: "mac-cain13", version: nil))
    }

    func testConvertToGithubSSH() {
        let package = SwiftPackage(package: "LicensePlist",
                                   repositoryURL: "git@github.com:mono0926/LicensePlist.git",
                                   revision: "3365947d725398694d6ed49f2e6622f05ca3fc0e",
                                   version: nil)
        let result = package.toGitHub(renames: [:])
        XCTAssertEqual(result, GitHub(name: "LicensePlist", nameSpecified: "LicensePlist", owner: "mono0926", version: nil))
    }

    func testConvertToGithubPackageName() {
        let package = SwiftPackage(package: "IterableSDK",
                                   repositoryURL: "https://github.com/Iterable/swift-sdk",
                                   revision: "3365947d725398694d6ed49f2e6622f05ca3fc0e",
                                   version: nil)
        let result = package.toGitHub(renames: [:])
        XCTAssertEqual(result, GitHub(name: "swift-sdk", nameSpecified: "IterableSDK", owner: "Iterable", version: nil))
    }

    func testConvertToGithubRenames() {
        let package = SwiftPackage(package: "IterableSDK",
                                   repositoryURL: "https://github.com/Iterable/swift-sdk",
                                   revision: "3365947d725398694d6ed49f2e6622f05ca3fc0e",
                                   version: nil)
        let result = package.toGitHub(renames: ["swift-sdk": "NAME"])
        XCTAssertEqual(result, GitHub(name: "swift-sdk", nameSpecified: "NAME", owner: "Iterable", version: nil))
    }

    func testRename() {
        let package = SwiftPackage(package: "Commander",
                                   repositoryURL: "https://github.com/kylef/Commander.git",
                                   revision: "e5b50ad7b2e91eeb828393e89b03577b16be7db9",
                                   version: "0.8.0")
        let result = package.toGitHub(renames: ["Commander": "RenamedCommander"])
        XCTAssertEqual(result, GitHub(name: "Commander", nameSpecified: "RenamedCommander", owner: "kylef", version: "0.8.0"))
    }

    func testInvalidURL() {
        let package = SwiftPackage(package: "Google", repositoryURL: "http://www.google.com", revision: "", version: "0.0.0")
        let result = package.toGitHub(renames: [:])
        XCTAssertNil(result)
    }

    func testNonGithub() {
        let package = SwiftPackage(package: "Bitbucket",
                                   repositoryURL: "https://mbuchetics@bitbucket.org/mbuchetics/adventofcode2018.git",
                                   revision: "",
                                   version: "0.0.0")
        let result = package.toGitHub(renames: [:])
        XCTAssertNil(result)
    }

    func testParse() throws {
        let path = "https://raw.githubusercontent.com/mono0926/LicensePlist/master/Package.resolved"
        let content = try String(contentsOf: XCTUnwrap(URL(string: path)))
        let packages = SwiftPackage.loadPackages(content)

        XCTAssertFalse(packages.isEmpty)
        XCTAssertEqual(packages.count, 7)

        let packageFirst = try XCTUnwrap(packages.first)
        XCTAssertEqual(packageFirst, SwiftPackage(package: "APIKit",
                                                  repositoryURL: "https://github.com/ishkawa/APIKit.git",
                                                  revision: "c8f5320d84c4c34c0fd965da3c7957819a1ccdd4",
                                                  version: "5.2.0"))
        let packageLast = try XCTUnwrap(packages.last)
        XCTAssertEqual(packageLast, SwiftPackage(package: "Yaml",
                                                 repositoryURL: "https://github.com/behrang/YamlSwift.git",
                                                 revision: "287f5cab7da0d92eb947b5fd8151b203ae04a9a3",
                                                 version: "3.4.4"))

    }
}
