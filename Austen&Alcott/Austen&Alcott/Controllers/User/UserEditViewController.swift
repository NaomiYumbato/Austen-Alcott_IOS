//
//  UserEditViewController.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 7/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserEditViewController: UIViewController {
    @IBOutlet weak var nameUserTF: UITextField!
    @IBOutlet weak var lastNameUserTF: UITextField!
    @IBOutlet weak var phoneUserTF: UITextField!

    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }

    func fetchUserData() {
        if let uid = userId {
            db.collection("users").document(uid).getDocument { (document, error) in
                if let error = error {
                    print("Error al obtener datos del usuario: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "No se pudieron cargar los datos del perfil.")
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    self.nameUserTF.text = data?["firstName"] as? String ?? ""
                    self.lastNameUserTF.text = data?["lastName"] as? String ?? ""

                    if let phone = data?["phone"] as? NSNumber {
                        self.phoneUserTF.text = phone.stringValue
                    } else {
                        self.phoneUserTF.text = ""
                    }

                } else {
                    self.showAlert(title: "Error", message: "No se encontró la información del perfil.")
                }
            }
        }
    }

    @IBAction func didTapEditProfile(_ sender: UIButton) {
        guard let firstName = nameUserTF.text, !firstName.isEmpty else {
            showAlert(title: "Error", message: "Por favor, ingresa tu nombre.", fieldToFocus: nameUserTF)
            return
        }

        guard let lastName = lastNameUserTF.text, !lastName.isEmpty else {
            showAlert(title: "Error", message: "Por favor, ingresa tu apellido.", fieldToFocus: lastNameUserTF)
            return
        }

        let phoneString = phoneUserTF.text ?? ""

        // Validar que el teléfono tenga 9 dígitos si no está vacío
        if !phoneString.isEmpty && phoneString.count != 9 {
            showAlert(title: "Error", message: "El número de teléfono debe tener 9 dígitos.", fieldToFocus: phoneUserTF)
            return
        }

        let phone = Int(phoneString) // Intentamos convertir a Int después de la validación

        if let uid = userId {
            var updates: [String: Any] = [:]
            updates["firstName"] = firstName
            updates["lastName"] = lastName
            if let phone = phone {
                updates["phone"] = phone
            } else if !phoneString.isEmpty {
                // Ya mostramos la alerta de formato incorrecto, no necesitamos otra aquí
                return
            }

            db.collection("users").document(uid).updateData(updates) { error in
                if let error = error {
                    print("Error al actualizar el perfil: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "No se pudo actualizar el perfil. Inténtalo de nuevo.")
                } else {
                    print("Perfil actualizado con éxito.")
                    self.showAlert(title: "Éxito", message: "Tu perfil se ha actualizado correctamente.") { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            print("No se pudo obtener el ID del usuario autenticado.")
            self.showAlert(title: "Error", message: "No se pudo obtener la información del usuario.")
        }
    }


    @IBAction func didTapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func showAlert(title: String, message: String, fieldToFocus: UITextField? = nil, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            fieldToFocus?.becomeFirstResponder()
            completion?(action)
        }))
        present(alert, animated: true, completion: nil)
    }
}
