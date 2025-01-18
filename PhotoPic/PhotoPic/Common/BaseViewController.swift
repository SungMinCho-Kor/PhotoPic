//
//  BaseViewController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit

class BaseViewController: UIViewController, ViewConfiguration {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureViews()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureViews() { }
}
