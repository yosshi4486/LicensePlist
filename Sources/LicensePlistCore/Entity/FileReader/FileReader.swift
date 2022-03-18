import Foundation

/// An object that reads any file from the given path.
protocol FileReader {

    /// The result parameter type of reading a file.
    associatedtype ResultType

    /// The path which an interested file located.
    var path: URL { get }

    /// Returns a concrete result by reading a file which the given path specifies.
    func read() throws -> ResultType

}
