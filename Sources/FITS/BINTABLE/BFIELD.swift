/*
 
 Copyright (c) <2020>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import Foundation

/**
  THE TFIELD data structure as specified for the Bintable extensions
 
 The TFORMn keywords must be present for all values n = 1, ..., TFIELDS and for no other values of n. The value field of this indexed keyword shall contain a char- acter string of the form rTa. The repeat count r is the ASCII representation of a non-negative integer specifying the number of elements in Field n. The default value of r is 1; the repeat count need not be present if it has the default value. A zero el- ement count, indicating an empty field, is permitted. The data type T specifies the data type of the contents of Field n. Only the data types in Table 18 are permitted. The format codes must be specified in upper case. For fields of type P or Q, the only per- mitted repeat counts are 0 and 1. The additional characters a are optional and are not further defined in this Standard. Table 18 lists the number of bytes each data type occupies in a table row. The first field of a row is numbered 1.
 */
open class BFIELD: FIELD {
    
    public typealias TDISP = BDISP
    public typealias TFORM = BFORM
    
    public static func == (lhs: BFIELD, rhs: BFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("ERR")
    }
    
    static let ERR = "ERR"
    
    #if DEBUG
    var raw : Data?
    #endif
    
    public var description: String {
        return  "BFIELD"
    }
    
    public var debugDescription: String {
        return String(describing: self)
    }
    
    public static func parse(data: Data?, type: BFORM) -> BFIELD {
        
        //print("PARSE \(type): \(data?.base64EncodedString() ?? "NIL")")
        
        switch type {
        case .L:
            if let data = data, !data.isEmpty {
                var string = String(data: data, encoding: .ascii)
                string = string?.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string?.reduce(into: [Bool](), { arr, char in
                    if char == "T" {
                        arr.append(true)
                    } else if char == "F" {
                        arr.append(false)
                    }
                })
                return BFIELD.L(val: arr)
            } else {
                return BFIELD.L(val: nil)
            }
        case .X:
            return BFIELD.X(val: data)
        case .B(let count):
            if let data = data {
                var values : [UInt8] = []
                data.copyBytes(to: &values, count: count)
                return BFIELD.B(val: values)
            } else {
                return BFIELD.B(val: nil)
            }
        case .I(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Int16] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int16.self).map{Int16.init(bigEndian: $0)}
                }
                return BFIELD.I(val: values)
            } else {
                return BFIELD.I(val: nil)
            }
        case .J:
            if let data = data {
                let values : [Int32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int32.self).map{Int32.init(bigEndian: $0)}
                }
                return BFIELD.J(val: values)
            } else {
                return BFIELD.J(val: nil)
            }
        case .K:
            if let data = data {
                let values : [Int64] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int64.self).map{Int64.init(bigEndian: $0)}
                }
                return BFIELD.K(val: values)
            } else {
                return BFIELD.K(val: nil)
            }
        case .A:
            if let data = data {
                let string = String(data: data, encoding: .ascii)
            return BFIELD.A(val: string)
            } else {
                return BFIELD.A(val: nil)
            }
        case .E:
            if let data = data {
                let values : [Float] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt32.self).map{Float(bitPattern: $0)}
                }
                return BFIELD.E(val: values)
            } else {
                return BFIELD.E(val: nil)
            }
        case .D(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Double] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt64.self).map{Double(bitPattern: $0)}
                }
                return BFIELD.D(val: values)
            } else {
                return BFIELD.D(val: nil)
            }
        case .C:
            return BFIELD.C(val: nil)
        case .M:
            return BFIELD.M(val: nil)
            
            // variable length array
        case .PL(let count):
            if let data = data?.subdata(in: 0..<count), !data.isEmpty {
                var string = String(data: data, encoding: .ascii)
                string = string?.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string?.reduce(into: [Bool](), { arr, char in
                    if char == "T" {
                        arr.append(true)
                    } else if char == "F" {
                        arr.append(false)
                    }
                })
                return BFIELD.PL(val: arr)
            } else {
                return BFIELD.PL(val: nil)
            }
        case .PX:
            return BFIELD.PX(val: data)
        case .PB(let count):
            if let data = data {
                var values : [UInt8] = []
                data.copyBytes(to: &values, count: count)
                return BFIELD.PB(val: values)
            } else {
                return BFIELD.PB(val: nil)
            }
        case .PI(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Int16] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int16.self).map{Int16.init(bigEndian: $0)}
                }
                return BFIELD.PI(val: values)
            } else {
                return BFIELD.PI(val: nil)
            }
        case .PJ(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Int32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int32.self).map{Int32.init(bigEndian: $0)}
                }
                return BFIELD.PJ(val: values)
            } else {
                return BFIELD.PJ(val: nil)
            }
        case .PK(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Int64] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int64.self).map{Int64.init(bigEndian: $0)}
                }
                return BFIELD.PK(val: values)
            } else {
                return BFIELD.PK(val: nil)
            }
        case .PA(let count):
            if let data = data?.subdata(in: 0..<count) {
                let string = String(data: data, encoding: .ascii)
                return BFIELD.A(val: string)
            } else {
                return BFIELD.A(val: nil)
            }
        case .PE(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Float32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt32.self).map{Float32(bitPattern: $0)}
                }
                return BFIELD.PE(val: values)
            } else {
                return BFIELD.PE(val: nil)
            }
        case .PC:
            return BFIELD.PB(val: nil)

            
        case .QD(let count):
            if let data = data?.subdata(in: 0..<count) {
                let values : [Double] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt64.self).map{Double(bitPattern: $0)}
                }
                return BFIELD.QD(val: values)
            } else {
                return BFIELD.QD(val: nil)
            }
        case .QM:
            return BFIELD.QM(val: nil)
        }
    }
    
    public var form: TFORM {
        fatalError("Not implemented")
    }
    
    public func format(_ using: BDISP?) -> String? {
        return BFIELD.ERR
    }
    
    public func write(_ form: BFORM) -> String {
        ""
    }
    
    public func write(to: inout Data) {
        //
    }
    
    //MARK:- L : Logical
    /// Logical
    final public class L : BFIELD {
        var val: [Bool]?
        
        init(val: [Bool]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            //case .L:
            //    return val.first ? "T" : "F"
            default:
                return self.description
            }
        }
        
        public override func write(to: inout Data) {
            let string = val?.reduce(into: "", { r, v in
                r.append(v ? "T" : "F")
            }) ?? ""
            to.append(string)
        }
        
        public override var form: TFORM {
            return BFORM.L(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.L(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("L")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- X : BIT
    /// Bit
    final public class X : BFIELD {
        var val: Data?
        
        init(val: Data?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.X(r: val?.count ?? 0 * MemoryLayout<UInt8>.size)
        }
        
        override public var debugDescription: String {
            return "BFIELD.X(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("X")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- B : (U)Byte
    /// Unsigned byte
    final public class B : BFIELD {
        var val: [UInt8]?
        
        init(val: [UInt8]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                /// - ToDo: format `val`
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.B(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<UInt8>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.B(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("B")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- I : Int16
    /// 16-bit integer
    final public class I : BFIELD {
        var val: [Int16]?
        
        init(val: [Int16]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.I(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Int16.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<Int16>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.I(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("I")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- J : Int32
    /// 32-bit integer
    final public class J : BFIELD {
        var val: [Int32]?
        
        init(val: [Int32]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.J(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Int32.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<Int32>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.J(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("J")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- K : Int64
    /// 64-bit integer
    final public class K : BFIELD {
        var val: [Int64]?
        
        init(val: [Int64]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.K(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Int64.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<Int64>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.K(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("K")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- A : Character
    // Character
    final public class A : BFIELD {
        var val: String?
        
        init(val: String?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            case .A(let w):
                return String(val.prefix(w))
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.A(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let dat = val?.data(using: .ascii){
                to.append(dat)
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.A(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("A")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
     //MARK:- E : Single-precision floating point
    /// Single-precision floating point
    final public class E : BFIELD {
        var val: [Float]?
        
        init(val: [Float]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.E(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Float.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<Float>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.E(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("E")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- D : Double-precision floating point
    /// Double-precision floating point
    final public class D : BFIELD {
        var val: [Double]?
        
        init(val: [Double]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.D(r: val?.count ?? 0)
        }
        
        public override func write(to: inout Data) {
            if let arr = val {
                var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Double.self).map{$0.bigEndian} }
                to.append(Data(bytes: &dat, count: MemoryLayout<Double>.size * arr.count))
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.D(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("D")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- C : Single-precision complex
    /// Single-precision complex
    final public class C : BFIELD {
        var val: [(Float,Float)]?
        
        init(val: [(Float,Float)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.C(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.C(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("C")
            val?.forEach({ f1,f2 in
                hasher.combine(f1)
                hasher.combine(f2)
            })
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- M : Single-precision floating point
    /// Double-precision complex
    final public class M : BFIELD {
        var val: [(Double,Double)]?
        
        init(val: [(Double,Double)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.M(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.M(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("M")
            val?.forEach({ f1,f2 in
                hasher.combine(f1)
                hasher.combine(f2)
            })
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- P : Array Descriptor (32-bit)
    /// Array Descriptor (32-bit)
    final public class PL : BFIELD {
        var val: [Bool]?
        
        init(val: [Bool]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PL(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PL(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PL")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PX : BFIELD {
        var val: Data?
        
        init(val: Data?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PX(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PX(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PX")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PB : BFIELD {
        var val: [UInt8]?
        
        init(val: [UInt8]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PB(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PB(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PB")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PI : BFIELD {
        var val: [Int16]?
        
        init(val: [Int16]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PI(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PI(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PI")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PJ : BFIELD {
        var val: [Int32]?
        
        init(val: [Int32]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PJ(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PJ(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PJ")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PK : BFIELD {
        var val: [Int64]?
        
        init(val: [Int64]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PJ(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PK(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PK")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PA : BFIELD {
        var val: [Character]?
        
        init(val: [Character]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PA(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PA(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PA")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PE : BFIELD {
        var val: [Float32]?
        
        init(val: [Float32]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PE(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PE(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PE")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (32-bit)
    final public class PC : BFIELD {
        var val: [(Float, Float)]?
        
        init(val: [(Float,Float)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PC(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PC(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PC")
            val?.forEach{ v in
                hasher.combine(v.0)
                hasher.combine(v.1)
            }
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    
    //MARK:- Q : Array Descriptor (64-bit)
    /// Array Descriptor (64-bit)
    final public class QD : BFIELD {
        var val: [Double]?
        
        init(val: [Double]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.QD(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.QD(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("QD")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    /// Array Descriptor (64-bit)
    final public class QM : BFIELD {
        var val: [(Double,Double)]?
        
        init(val: [(Double,Double)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.QM(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.QM(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("QM")
            val?.forEach({ v in
                hasher.combine(v.0)
                hasher.combine(v.1)
            })
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
}

