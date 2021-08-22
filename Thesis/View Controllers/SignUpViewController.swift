//
//  SignUpViewController.swift
//  Thesis
//
//  Created by Nabil Belfki on 24/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    //Connecting all four textfields created in the Main Storyboard (fName, lName, email, password) to the controller SignUpViewController through code.
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //Connecting SignUp Button and Label for Error Handling text which was created in the Main Storyboard (which is a UI means of declaring elements) to the code and its respective controller, SignUpViewController.
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide the error label
        errorLabel.alpha = 0
        //Add stylization of elements declared in Utilities.swift from Helpers Group.
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
    }
    //Check textfields to validate if data is inputed correctly, if so function will return nil. Otherwise, it will return the error message.
    func validateFields() -> String?{
        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check for valid email entry
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanedEmail) == false{
            //Email does not conform to regular expressions
            return "Please make sure the email that you typed is valid."
        }
        
        //Check for secure password entry
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            //Password does not conform to regular expressions
            return "Please make sure your password is at least 8 character, contains atleast one special character and number."
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        //Validate inputs of textfields
        let error = validateFields()
        
        if error != nil {
            //An error was return, display error message
            showError(error!)
            }
        else {
            //Store Data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors
                if err != nil {
                    //There was an error
                    self.showError("Error creating user")
                }
                else {
                    //User was created successfully, then stores the first and last name
                    UserDefaults.standard.setValue(email, forKey: "username")
                   
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["fname":firstName,"lname":lastName,"uid":result!.user.uid]) { (error) in
                        if error != nil{
                            //Show error message
                            self.showError("ERROR: COULDNT SAVE USER DATA")
                        }
                    }
                }
            }
        //Transition to the home screen
        self.transitionToHome()
            
        }
    }
    func showError(_ message:String){
        //Error visual properties
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from view controller
        // Changes the rootview controller to maintabbarcontroller and sends user to the readtagcontroller view
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
