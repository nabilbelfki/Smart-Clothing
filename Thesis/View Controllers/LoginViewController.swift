//
//  LoginViewController.swift
//  Thesis
//
//  Created by Nabil Belfki on 24/11/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    //Connecting four elements created through the Main Storyboard User Interface (email textfield,password textfield, login button, error message) to the Login ViewController
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide the error label.
        errorLabel.alpha = 0
        //Add stylization of elements declared in Utilities.swift from Helpers Group.
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(loginButton)
    }
    
    //Check textfields to validate if data is inputed correctly, if so function will return nil. Otherwise, it will return the error message.
    func validateFields() -> String?{
        //Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //Validate Text Fields
        
        //Store textfield inputs
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                //Could not sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                    UserDefaults.standard.setValue(email, forKey: "username")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                // This is to get the SceneDelegate object from view controller
                // Changes the rootview controller to maintabbarcontroller and sends user to the readtagcontroller view
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }
    }
    

