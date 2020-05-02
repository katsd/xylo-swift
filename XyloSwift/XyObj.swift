import Foundation
import xylo

enum XyValue {
    case int(Int)
    case float(Double)
    case string(String)
}

public struct XyObj {
    private let value: XyValue

    public init(_ value: Int) {
        self.value = .int(value)
    }

    public init(_ value: Double) {
        self.value = .float(value)
    }

    public init(_ value: String) {
        self.value = .string(value)
    }

    static public var zero: XyObj {
        self.init(0)
    }

    public func int() -> Int {
        switch value {
        case .int(let v):
            return v
        case .float(let v):
            return Int(v)
        case .string(let v):
            return Int(v) ?? 0
        }
    }

    public func float() -> Double {
        switch value {
        case .int(let v):
            return Double(v)
        case .float(let v):
            return v
        case .string(let v):
            return Double(v) ?? 0
        }
    }

    public func string() -> String {
        switch value {
        case .int(let v):
            return String(v)
        case .float(let v):
            return String(v)
        case .string(let v):
            return v
        }
    }
}

extension XyObj {
    init(_ cobj: CObj) {
        switch cobj.type {
        case INT:
            self.init(cobj.value.ival)
        case FLOAT:
            self.init(cobj.value.dval)
        case STRING:
            self.init(String(cString: cobj.value.str))
        default:
            self.init(0)
        }
    }

    func toCObj() -> CObj {
        switch value {
        case .int(let v):
            return CObj(type: INT, value: CObjValue(ival: v))
        case .float(let v):
            return CObj(type: FLOAT, value: CObjValue(dval: v))
        case .string(let v):
            return v.withCString { ptr in
                CObj(type: STRING, value: CObjValue(str: ptr))
            }
        }
    }
}
