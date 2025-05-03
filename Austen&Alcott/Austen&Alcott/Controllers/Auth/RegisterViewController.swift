//
//  RegisterViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 27/04/25.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        // 🚧 Nota: Por ahora no ejecutamos el flujo de validación de register
        // para simplificar las pruebas y navegación inicial de la app.
        // retirar return cuando dejemos todo funcional
        return
            let username = usernameField.text ?? ""
            let password = passwordField.text ?? ""
            let firstName = firstNameField.text ?? ""
            let lastName = lastNameField.text ?? ""
            let phone = phoneField.text ?? ""
            let email = emailField.text ?? ""

            // Validar que no estén vacíos
            if username.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || phone.isEmpty || email.isEmpty {
                showAlert("Todos los campos son obligatorios.")
                return
            }
        

            // Guardar los datos en UserDefaults (puedes usar un modelo de datos en el futuro para más complejidad)
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(firstName, forKey: "firstName")
            UserDefaults.standard.set(lastName, forKey: "lastName")
            UserDefaults.standard.set(phone, forKey: "phone")
            UserDefaults.standard.set(email, forKey: "email")

            // Volver al Login
            dismiss(animated: true)
        
            view.endEditing(true)
        }

        func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
        
    }
    
    
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
        
    }
    
    
    
    
    }
