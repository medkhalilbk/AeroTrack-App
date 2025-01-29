//
//  LoaderViewController.swift
//  AeroTrack_App
//
//  Created by Med Khalil Benkhelil on 10/30/24.
//

import UIKit

class LoaderViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

       override func loadView() {
           view = UIView()
           view.backgroundColor = UIColor(white: 0, alpha: 0.7)

           spinner.translatesAutoresizingMaskIntoConstraints = false
           spinner.startAnimating()
           view.addSubview(spinner)

           spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       }
 }


