//
//  LoginViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    lazy var usernameField: UITextField = {
        let usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Enter your username"
        usernameField.borderStyle = .roundedRect
        usernameField.layer.cornerRadius = 8
        return usernameField
    }()
    
    
    lazy var loginButton : UIButton = {
        let loginButton : UIButton = UIButton(type: .system)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubview(usernameField)
        view.addSubview(loginButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
//        align username field
        usernameField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20.0).isActive = true
        usernameField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
//        align login button
        
        loginButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30.0).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        
    }
    
    
    @objc func login(sender:UIButton) {
        if let username = usernameField.text{
            if username .isEmpty{
                showAlert(for: self, message:  "Enter username")
                return
            }
            UserDefaults.standard.set(username, forKey: Constants.username)
            self.dismiss(animated: true)
        }
    }
    
    func showAlert(for controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
