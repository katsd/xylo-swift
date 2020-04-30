import Foundation
import xylo

public class Xylo {

    public struct Func {
        let funcName: String

        let argNum: UInt

        let closure: @convention(c) (UnsafeMutablePointer<CObj>?, UInt) -> (CObj)
    }

    let eval: UnsafeMutableRawPointer

    public init(source: String, funcs: [Func] = []) {
        eval = CreateXylo(source)

        for fn in funcs {
            AddXyloFunc(eval, fn.funcName, fn.argNum, fn.closure)
        }
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
