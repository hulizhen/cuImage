//
//  String+Random.swift
//  cuImage
//
//  Created by Lizhen Hu on 19/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Foundation

extension String {
    static func random(length: Int) -> String {
        var string = ""
        let letters = Constants.characterSet
        let count = UInt32(letters.characters.count)

        for _ in 0..<length {
            let random = Int(arc4random_uniform(count))
            let index = letters.index(letters.startIndex, offsetBy: random)
            string.append(letters.characters[index])
        }
        return string
    }
}
