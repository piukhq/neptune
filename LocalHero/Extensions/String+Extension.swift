//
//  StringExtension.swift
//  binkapp
//
//  Created by Max Woodhams on 19/09/2019.
//  Copyright © 2019 Bink. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in
            return letters.randomElement()!
        })
    }
    
    static func fromTimestamp(_ timestamp: Double?, withFormat format: DateFormat, prefix: String? = nil, suffix: String? = nil) -> String? {
        guard let timestamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return "\(prefix ?? "")\(formatter.string(from: date))\(suffix ?? "")"
    }
    
    func toNSString() -> NSString {
        return self as NSString
    }
    
    /// Convert a valid JSON string to a decoded Swift object.
    /// - Parameter objectType: The object type you are attempted to decode the JSON to. Passed in as String.self or [String].self.
    /// - Returns: An optional, fully typed decoded Swift object
    func asDecodedObject<T: Decodable>(ofType objectType: T.Type) -> T? {
        guard let data = data(using: .utf8) else { return nil }
        
        do {
            let decodedObject = try JSONDecoder().decode(objectType, from: data)
            return decodedObject
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func ranges(of subString: String) -> [NSRange] {
        var ranges: [NSRange] = []
        var range = NSRange(location: 0, length: count)
        while range.location != NSNotFound {
            range = (self as NSString).range(of: subString, options: .caseInsensitive, range: range)
            if range.location != NSNotFound {
                ranges.append(range)
                range = NSRange(location: range.location + range.length, length: count - (range.location + range.length))
            }
        }
        return ranges
    }
    
    var sha256: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA256)
    }
    
    public enum HMAC {
        static func hash(inp: String, algo: HMACAlgo) -> String {
            guard let stringData = inp.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
                fatalError("Failed to hash")
            }
            return hexStringFromData(input: digest(input: stringData as NSData, algo: algo))
        }
        
        private static func digest(input: NSData, algo: HMACAlgo) -> NSData {
            let digestLength = algo.digestLength()
            var hash = [UInt8](repeating: 0, count: digestLength)
            switch algo {
            case .SHA1:
                CC_SHA1(input.bytes, UInt32(input.length), &hash)
            case .SHA224:
                CC_SHA224(input.bytes, UInt32(input.length), &hash)
            case .SHA256:
                CC_SHA256(input.bytes, UInt32(input.length), &hash)
            case .SHA384:
                CC_SHA384(input.bytes, UInt32(input.length), &hash)
            case .SHA512:
                CC_SHA512(input.bytes, UInt32(input.length), &hash)
            }
            return NSData(bytes: hash, length: digestLength)
        }
        
        private static func hexStringFromData(input: NSData) -> String {
            var bytes = [UInt8](repeating: 0, count: input.length)
            input.getBytes(&bytes, length: input.length)
            
            var hexString = ""
            for byte in bytes {
                hexString += String(format: "%02x", UInt8(byte))
            }
            
            return hexString
        }
    }
}

enum HMACAlgo {
    case SHA1, SHA224, SHA256, SHA384, SHA512
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
