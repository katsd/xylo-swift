import Foundation
import xylo

class Xylo {

    let eval: UnsafeMutableRawPointer

    init(source: String) {
        eval = CreateXylo(source)
    }

    deinit {
        free(eval)
    }

    func run() {
        RunXylo(eval)
    }

    func runFunc(name: String) {
        RunXyloFunc(eval, name)
    }

}
