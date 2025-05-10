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
    
    private init() {}
    
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "NoAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No hay usuario autenticado."])))
            return
        }
        
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        usersRef.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
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
}
