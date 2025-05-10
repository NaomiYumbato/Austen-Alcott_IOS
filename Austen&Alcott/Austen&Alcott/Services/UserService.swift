//
//  UserService.swift
//  Austen&Alcott
//
//  Created by DAMII on 10/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    private init() {}

    // Obtener usuario actual por email
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "NoAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No hay usuario autenticado."])))
            return
        }

        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado."])))
                return
            }

            let data = document.data()
            let user = User(
                email: data["email"] as? String ?? "",
                firstName: data["firstName"] as? String ?? "",
                lastName: data["lastName"] as? String ?? "",
                password: data["password"] as? String ?? "",
                phone: Int(data["phone"] as? String ?? "") ?? 0
            )
            completion(.success(user))
        }
    }

    // Actualizar datos del usuario actual
    func updateCurrentUser(firstName: String, lastName: String, phone: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No hay usuario autenticado."])))
            return
        }

        var updates: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName
        ]

        if let phone = phone {
            updates["phone"] = phone
        }

        db.collection("users").document(uid).updateData(updates) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
