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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        print(self, #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureViews() { }
    func presentErrorAlert(error: CustomError) {
        let alert = UIAlertController(
            title: nil,
            message: error.alert,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: "확인",
            style: .default
        )
        alert.addAction(ok)
        present(
            alert,
            animated: true
        )
    }
    
    deinit {
        print(self, #function)
    }
}
