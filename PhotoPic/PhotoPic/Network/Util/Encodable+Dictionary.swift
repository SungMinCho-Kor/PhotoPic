//
//  Encodable+Dictionary.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard
            let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Any] else {
            print(#function, "EncodableWrong")
            return [:]
        }
        
        return dictionary
    }
}
