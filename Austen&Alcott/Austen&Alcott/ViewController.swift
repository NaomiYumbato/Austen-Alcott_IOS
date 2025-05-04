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
    
    // obtiene los datos del usuario en la bd en base al correo
    func getUser() {
        guard let email = Auth.auth().currentUser?.email else {
            print("No hay usuario autenticado.")
            return
        }

        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
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
            
            if let name = userData["firstName"] as? String {
                DispatchQueue.main.async {
                    self.userNameLabel.text = "Bienvenido(a),\(name)"
                }
            }
        }
    }
    
    @IBAction func didTapGoBooks(_ sender: UIButton) {
        print("Button presionado")
        let storyboard = UIStoryboard(name: "MyBooks", bundle: nil)
        
        if let booksVC = storyboard.instantiateViewController(withIdentifier: "BooksViewController") as? BooksViewController {
            self.navigationController?.pushViewController(booksVC, animated: true)
        } else {
            print("No se pudo cargar el BooksViewController")
        }
    }
    @IBAction func pruebaButton(_ sender: UIButton) {
        do {
                    try Auth.auth().signOut()
                    print("Usuario desconectado.")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        self.present(loginVC, animated: true, completion: nil)
                    }
                } catch let signOutError as NSError {
                    print("Error al cerrar sesión: \(signOutError.localizedDescription)")
                }
    }
}
