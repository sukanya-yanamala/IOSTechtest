//
//  LoginViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022.


//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "What would you like to be called?"
        return welcomeLabel
    }()
    
    private lazy var usernameField: UITextField = {
        let usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Enter your name"
        usernameField.borderStyle = .roundedRect
        usernameField.layer.cornerRadius = 8
        return usernameField
    }()
    
    
    private lazy var saveButton : UIButton = {
        let saveButton : UIButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(dummyLogin), for: .touchUpInside)
        return saveButton
    }()
    
    // This is a Dummy login functionality, and there is no external validation.
    // this is only present to save the name of the user that is used to display welcome message in the home screen.
    // This method can later be used to integrate any login frameworks
    @objc private func dummyLogin(sender:UIButton) {
        if let username = usernameField.text{
            if username .isEmpty{
                showAlert(for: self, message:  "Please Enter your Name")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        view.addSubview(usernameField)
        view.addSubview(saveButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        welcomeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20.0).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        // align username field
        usernameField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20.0).isActive = true
        usernameField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
        // align login button
        
        saveButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30.0).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0).isActive = true
        
    }
}
