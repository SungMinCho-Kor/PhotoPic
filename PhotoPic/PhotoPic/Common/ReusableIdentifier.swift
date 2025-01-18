//
//  ReusableIdentifier.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

protocol ReusableIdentifier { }

extension ReusableIdentifier {
    static var identifier: String {
        String(describing: self)
    }
}

