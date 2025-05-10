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
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    let bookService = BookService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        loadBooksFromFirestore()
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
    
    func loadBooksFromFirestore() {
        bookService.getAllBooks { books in
            DispatchQueue.main.async {
                for book in books {
                    guard
                        let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)?.first as? DayView,
                        let urlString = book.imageUrl,
                        let url = URL(string: urlString)
                    else {
                        continue
                    }
                    
                    dayView.book = book
                    
                    dayView.translatesAutoresizingMaskIntoConstraints = false
                    dayView.widthAnchor.constraint(equalToConstant: self.horizontallyScrollableStackView.frame.height).isActive = true
                    
                    self.horizontallyScrollableStackView.addArrangedSubview(dayView)
                    
                    
                    URLSession.shared.dataTask(with: url) { data, _, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            dayView.bookImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
            }
        }
    }
    
}

