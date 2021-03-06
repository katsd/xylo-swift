import Foundation
import xylo

public class Xylo {

    public struct Func {
        let funcName: String

        let argNum: UInt

        let closure: ([XyObj]) -> XyObj

        public init(funcName: String, argNum: UInt, _ closure: @escaping ([XyObj]) -> XyObj) {
            self.funcName = funcName
            self.argNum = argNum
            self.closure = closure
        }
    }

    var eval: UnsafeMutableRawPointer? = nil

    var extFuncs = Dictionary<String, ([XyObj]) -> XyObj>()

    static let callExtFuncClosure: @convention(c) (UnsafeRawPointer?, UnsafePointer<Int8>?, UInt, UnsafeMutablePointer<CObj>?) -> CObj = {
        CallExtFunc(extXyloInstance: $0, funcName: $1, argNum: $2, args: $3)
    }

    public init(source: String, funcs: [Func] = []) {
        DeleteAllXyloFunc()

        for fn in funcs {
            AddXyloFunc(fn.funcName, fn.argNum)
            extFuncs[funcData2Key(funcName: fn.funcName, argNum: fn.argNum)] = fn.closure
        }

        let selfPtr = Unmanaged<Xylo>.passUnretained(self).toOpaque()

        eval = CreateXylo(selfPtr, source, Xylo.callExtFuncClosure)
    }

    deinit {
        free(eval)
    }

    public func run() {
        RunXylo(eval)
    }

    // call with no arg
    public func runFunc(name: String) {
        RunXyloFunc(eval, name)
    }

    func runExtFunc(funcName: String, args: [XyObj]) -> XyObj {
        guard let closure = extFuncs[funcData2Key(funcName: funcName, argNum: UInt(args.count))] else {
            return .zero
        }

        return closure(args)
    }

    private func funcData2Key(funcName: String, argNum: UInt) -> String {
        funcName + String(argNum)
    }
}

func CallExtFunc(extXyloInstance: UnsafeRawPointer?, funcName: UnsafePointer<Int8>?, argNum: UInt, args: UnsafeMutablePointer<CObj>?) -> CObj {
    let cobjZero = CObj(type: CObjType(0), value: CObjValue(ival: 0))

    guard let extXyloInstance = extXyloInstance, let funcName = funcName else {
        return cobjZero
    }

    let xylo = Unmanaged<Xylo>.fromOpaque(extXyloInstance).takeUnretainedValue()

    var sArgs = [XyObj]()
    for i in 0..<argNum {
        sArgs.append(XyObj(args?.advanced(by: Int(i)).pointee ?? cobjZero))
    }

    let res = xylo.runExtFunc(funcName: String(cString: funcName), args: sArgs)

    return res.toCObj()
}
