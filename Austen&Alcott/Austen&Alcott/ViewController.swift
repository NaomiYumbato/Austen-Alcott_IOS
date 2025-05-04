//
//  ViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 15/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    
    func getUser() {
        guard let email = Auth.auth().currentUser?.email else {
            print("No hay usuario autenticado.")
            return
        }

        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        // Buscamos el documento del usuario por su email
        usersRef.whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error al obtener el usuario: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No se encontró ningún usuario con ese correo")
                return
            }
            
            let document = documents.first!
            let userData = document.data()
            
            // Actualizamos el nombre del usuario en la interfaz
            if let name = userData["firstName"] as? String {
                DispatchQueue.main.async {
                    self.userNameLabel.text = "Bienvenido(a), \(name)"
                }
            }
        }
    }
    
    // Acción del botón para navegar a la vista de libros
    @IBAction func didTapGoBooks(_ sender: UIButton) {
        print("Button presionado")
        let storyboard = UIStoryboard(name: "MyBooks", bundle: nil)
        
        if let booksVC = storyboard.instantiateViewController(withIdentifier: "BooksViewController") as? BooksViewController {
            self.navigationController?.pushViewController(booksVC, animated: true)
        } else {
            print("No se pudo cargar el BooksViewController")
        }
    }
    
    // Acción para cerrar sesión
    @IBAction func pruebaButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("Usuario desconectado.")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.present(homeVC, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("Error al cerrar sesión: \(signOutError.localizedDescription)")
        }
    }
}
