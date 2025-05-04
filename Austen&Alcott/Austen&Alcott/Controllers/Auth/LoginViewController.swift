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
                    self.configureAlert(errorMessage: "Email o Contraseña incorrectos")
                } else {
                    self.getUser()
                    self.goToPush()
                }
            }
        }
    
    func configureAlert(errorMessage: String? = nil, message: String? = nil, fieldToFocus: UITextField? = nil) {
        let alertMessage = errorMessage ?? message ?? "Error desconocido"
        let alert = UIAlertController(title: errorMessage == nil ? "¡Logeo exitoso!" : "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                fieldToFocus?.becomeFirstResponder()
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginUser() {
            let email = emailField.text ?? ""
            let password = passwordField.text ?? ""
            loginWithFirebase(email: email, password: password)
        }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            configureAlert(errorMessage: "Por favor, complete todos los campos.")
            return
        }
        loginUser()
    }
}
