//
//  ViewController.swift
//  Anonymous Sign
//
//  Created by Ravikumar on 8/12/19.
//  Copyright © 2019 Ravikumar. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseAuth
class ViewController: UIViewController {

    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    //........ Firebase
    
    lazy var loginbutton:UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(login_clicked), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutbutton:UIButton = {
        let button = UIButton()
        button.alpha = 0.0
        button.setTitle("logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(logout_clicked), for: .touchUpInside)
        return button
    }()
    
    
    @objc func login_clicked(sender:UIButton){
        print("login clicked")
        let auth = Auth.auth()
        auth.signInAnonymously { (result, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            print("successfully signedin")
        }
    }
    
    @objc func logout_clicked(sender:UIButton){
        print("logout clicked")
        let auth = Auth.auth()
        do {
            try auth.signOut()
            print("successfully signedout")
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    func setupviews() {
        view.backgroundColor = .white
        
        view.addSubview(loginbutton)
        view.addSubview(logoutbutton)
        
        loginbutton.edgesToSuperview(excluding: .bottom,  usingSafeArea: true)
        loginbutton.height(50)
        
        //.................. offset is for give spacing between the components
        logoutbutton.topToBottom(of: loginbutton, offset: 10)
        
        //.................. let-offset and right-offset is for give spacing between the view
        logoutbutton.leftToSuperview( offset: 12, usingSafeArea: true)
        logoutbutton.rightToSuperview( offset: -12, usingSafeArea: true)
        logoutbutton.height(50)

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil{
                print("User is nil")
                self.loginbutton.alpha = 1.0
                self.logoutbutton.alpha = 0.0
                self.title = "User is logged out"
            }
            guard let user = user else{return}
            let uid = user.uid
            
            self.loginbutton.alpha = 0.0
            self.logoutbutton.alpha = 1.0
            self.title = uid
            print(uid)
            
            
        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupviews()
        
        
        
    }


}




























































