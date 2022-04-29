//
//  ViewController.swift
//  Movies
//
//  Created by Sukanya Yanamala on 28/04/2022
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let username = UserDefaults.standard.string(forKey: Constants.username) {
            print("Welcome1 \(username)")
            presentHome()
        } else{
            print("No")
            presentLogin()
        }
    }
    
    func presentHome() {
        let home = HomeViewController()
        
        let nav = UINavigationController(rootViewController: home)
        nav.modalPresentationStyle = .fullScreen
        nav.view.backgroundColor = .white
        self.present(nav, animated: true)
        
        
    }
    func presentLogin() {
        let login = LoginViewController()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        nav.view.backgroundColor = .white
        self.present(nav, animated: true)
    }
    
    
    
    
    
}

