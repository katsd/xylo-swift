import Foundation
import xylo

public class Xylo {

    let eval: UnsafeMutableRawPointer

    public init(source: String) {
        eval = CreateXylo(source)
    }

    deinit {
        free(eval)
    }

    public func run() {
        RunXylo(eval)
    }

    public func runFunc(name: String) {
        RunXyloFunc(eval, name)
    }

}
