import Foundation
import xylo

public class Xylo {

    public struct Func {
        let funcName: String

        let argNum: UInt

        let closure: @convention(c) (UnsafeMutablePointer<CObj>?, UInt) -> CObj

        public init(funcName: String, argNum: UInt, closure: @convention(c) @escaping (UnsafeMutablePointer<CObj>?, UInt) -> CObj) {
            self.funcName = funcName
            self.argNum = argNum
            self.closure = closure
        }
    }

    let eval: UnsafeMutableRawPointer

    public init(source: String, funcs: [Func] = []) {
        for fn in funcs {
            AddXyloFunc(eval, fn.funcName, fn.argNum, fn.closure)
        }

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
