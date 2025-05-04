//
//  LoginViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 27/04/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func goToPush() {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main) 
            let viewcontroller = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            viewcontroller?.modalPresentationStyle = .overFullScreen
        
            self.present(viewcontroller ?? ViewController(), animated: true, completion: nil)
        }
    
    func getUser() {
        
        let _ = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                print("no login")
            } else {
                self.goToPush()
            }
        }
        
        func configureAlert() {
                let alertController = UIAlertController(title: "Mensaje de error", message: "Usuario o Contraseña incorrecto", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
           
                self.present(alertController, animated: true, completion: nil)
            }
        
    }
 
    
}
