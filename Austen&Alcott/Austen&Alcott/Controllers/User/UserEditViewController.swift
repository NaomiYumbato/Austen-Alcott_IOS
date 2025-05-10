//
//  UserEditViewController.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 7/05/25.
//

import UIKit

class UserEditViewController: UIViewController {
    @IBOutlet weak var nameUserTF: UITextField!
    @IBOutlet weak var lastNameUserTF: UITextField!
    @IBOutlet weak var phoneUserTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }

    func fetchUserData() {
        UserService.shared.getCurrentUser { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.nameUserTF.text = user.firstName
                    self.lastNameUserTF.text = user.lastName
                    self.phoneUserTF.text = String(user.phone)
                }
            case .failure(let error):
                print("Error al obtener datos del usuario: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "No se pudieron cargar los datos del perfil.")
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

        if !phoneString.isEmpty {
            let isValid = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{9}$").evaluate(with: phoneString)
            if !isValid {
                showAlert(title: "Error", message: "El número de teléfono debe tener exactamente 9 dígitos.", fieldToFocus: phoneUserTF)
                return
            }
        }

        UserService.shared.updateCurrentUser(firstName: firstName, lastName: lastName, phone: phoneString.isEmpty ? nil : phoneString) { result in
            switch result {
            case .success:
                self.showAlert(title: "Éxito", message: "Tu perfil se ha actualizado correctamente.") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Error al actualizar perfil: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "No se pudo actualizar el perfil. Inténtalo de nuevo.")
            }
        }
        dismiss(animated: true, completion: nil)
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
