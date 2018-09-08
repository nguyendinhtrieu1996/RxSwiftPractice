//
//  UIViewControllerExtensions.swift
//  Combinestagram
//
//  Created by MACOS on 9/8/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func showMessage(_ title: String, description: String? = nil) -> Completable {
        return Completable.create(subscribe: { [weak self] completable in
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                completable(.completed)
            }))
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        })
       
    }
    
}

