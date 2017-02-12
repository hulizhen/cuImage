//
//  String+Crypto.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Foundation

enum CryptoAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    var hmacAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:      result = kCCHmacAlgMD5
        case .sha1:     result = kCCHmacAlgSHA1
        case .sha224:   result = kCCHmacAlgSHA224
        case .sha256:   result = kCCHmacAlgSHA256
        case .sha384:   result = kCCHmacAlgSHA384
        case .sha512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .md5:      result = CC_MD5_DIGEST_LENGTH
        case .sha1:     result = CC_SHA1_DIGEST_LENGTH
        case .sha224:   result = CC_SHA224_DIGEST_LENGTH
        case .sha256:   result = CC_SHA256_DIGEST_LENGTH
        case .sha384:   result = CC_SHA384_DIGEST_LENGTH
        case .sha512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let string = cString(using: .utf8)
        let stringLength = Int(lengthOfBytes(using: .utf8))
        let keyString = key.cString(using: .utf8)
        let keyLength = Int(key.lengthOfBytes(using: .utf8))
        var result = [UInt8](repeating: 0, count: algorithm.digestLength)
        
        CCHmac(algorithm.hmacAlgorithm, keyString!, keyLength, string!, stringLength, &result)
        
        return Data(bytes: result).urlSafeBase64EncodedString()
    }
}
