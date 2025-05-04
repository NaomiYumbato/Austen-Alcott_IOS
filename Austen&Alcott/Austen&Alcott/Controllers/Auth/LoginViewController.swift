//
//  LoginViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 27/04/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
        //el campo de contraseña se ven puntos
        passwordField.isSecureTextEntry = true
    }
    
    func getUser() {
            let _ = Auth.auth().addStateDidChangeListener { auth, user in
                if user == nil {
                    print("no login")
                } else {
                    self.goToPush() 
                }
            }
        }
    
    func goToPush() {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main) 
            let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            viewcontroller?.modalPresentationStyle = .overFullScreen
        
            self.present(viewcontroller ?? ViewController(), animated: true, completion: nil)
        }
    
    func loginWithFirebase(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                if error != nil {
                    configureAlert()
                } else {
                    self.goToPush()
                }
            }
        }
 
    func configureAlert() {
            let alertController = UIAlertController(title: "Mensaje de error", message: "Email o Contraseña incorrecto", preferredStyle: .alert)
                
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
           
            self.present(alertController, animated: true, completion: nil)
        }
    
    func loginUser() {
            let email = emailField.text ?? ""
            let password = passwordField.text ?? ""
            loginWithFirebase(email: email, password: password)
        }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        loginUser()
    }
}
