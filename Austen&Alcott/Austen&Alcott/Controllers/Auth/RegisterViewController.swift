//
//  RegisterViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 27/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Registrar usuario con Firebase
    func registerWithFirebase(email: String, password: String, firstName: String, lastName: String, phone: String) {
        // Registrar usuario con Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.configureAlert(errorMessage: error.localizedDescription)
            } else {
                // Obtener el ID del usuario recién registrado
                guard let userId = authResult?.user.uid else { return }
                
                // Guardar los datos del usuario en Firestore
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(userId)
                
                userRef.setData([
                    "email": email,
                    "firstName": firstName,
                    "lastName": lastName,
                    "phone": phone,
                    "uid": userId
                ]) { error in
                    if let error = error {
                        self.configureAlert(errorMessage: error.localizedDescription)
                    } else {
                        print("Usuario registrado exitosamente en Firestore.")
                    }
                }
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        // Validar que los campos no estén vacíos
        //guard indica que debe cumpir una condicion - !email.isEmpty
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let firstName = firstNameField.text, !firstName.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty,
              let phone = phoneField.text, !phone.isEmpty else {
            configureAlert(errorMessage: "Por favor, complete todos los campos.")
            return
        }
        
        if password.count < 6 {
            configureAlert(errorMessage: "La contraseña debe tener al menos 6 caracteres.", fieldToFocus: passwordField)
            return
        }
        
        if !isValidPhone(phone) {
            configureAlert(errorMessage: "El número de teléfono debe contener 9 números.", fieldToFocus: phoneField)
                return
            }
        
        if !isValidEmail(email) {
            configureAlert(errorMessage: "El correo electrónico no tiene un formato válido.", fieldToFocus: emailField)
            return
        }
        
        isEmailUsed(email) { isUsed in
                if isUsed {
                    self.configureAlert(errorMessage: "El correo electrónico ya está en uso.", fieldToFocus: self.emailField)
                } else {
                    self.registerWithFirebase(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone)
                }
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        viewcontroller?.modalPresentationStyle = .overFullScreen
        self.present(viewcontroller ?? UIViewController(), animated: true, completion: nil)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^[0-9]{9}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }

    func isEmailUsed(_ email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        // Consultar si ya existe un usuario con ese email - devuelve docs donde este ese email o false si no encuentra docs
        usersRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al verificar el email: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Si el número de doc devueltos es mayor a 0, el email ya está en uso
            if querySnapshot?.documents.count ?? 0 > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    
    func configureAlert(errorMessage: String? = nil, message: String? = nil, fieldToFocus: UITextField? = nil) {
        let alertMessage = errorMessage ?? message ?? "Error desconocido"
        let alert = UIAlertController(title: errorMessage == nil ? "¡Registro exitoso!" : "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                fieldToFocus?.becomeFirstResponder()
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
