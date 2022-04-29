//
//  EditUsernameViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import Foundation
import UIKit

class EditUsernameViewController : UIViewController{
    
    private lazy var usernameField: UITextField = {
        let usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.borderStyle = .roundedRect
        usernameField.layer.cornerRadius = 8
        usernameField.text = UserDefaults.standard.string(forKey: Constants.username)
        return usernameField
    }()
    
    private lazy var updateButton : UIButton = {
        let updateButton : UIButton = UIButton(type: .system)
        updateButton.setTitle("Update", for: .normal)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        return updateButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(usernameField)
        view.addSubview(updateButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        // align username field
        usernameField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20.0).isActive = true
        usernameField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        // align login button
        
        updateButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30.0).isActive = true
        updateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        updateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
    }
    
    @objc private  func update(sender:UIButton) {
        if let username = usernameField.text{
            if username .isEmpty{
                showAlert(for: self, message:  "Enter username")
                return
            }
            UserDefaults.standard.set(username, forKey: Constants.username)
            self.dismiss(animated: true)
        }
    }
    
    private func showAlert(for controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
