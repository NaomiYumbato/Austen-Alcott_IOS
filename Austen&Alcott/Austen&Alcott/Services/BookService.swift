//
//  BookService.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class BookService {
    let db = Firestore.firestore()
    
    /// completion: Es un closure que se llama de forma asíncrona con el resultado.
    /// Cuando hacemos una petición, hay un momento en que esta está en 'pendiente', así que se esperará a que la petición haya sido resuelta (ya no esté en pendiente)
    /// y entonces se ejecutará la función void.
    /// La palabra clave `@escaping` indica que este closure podría ejecutarse después de que la función `getAllBooks` haya regresado.
    /// Doc By Crhistian Ninalaya
    func getAllBooks(completion: @escaping ([Book]) -> Void) {
        db.collection("books").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al obtener todos los libros: \(error)")
                completion([]) // Llama al closure de finalización con un array vacío para indicar un error
                return
            }
            // Utiliza compactMap para iterar sobre los documentos en el query snapshot
            let books = querySnapshot?.documents.compactMap { Book(document: $0) } ?? []
            // Llama al closure de finalización con el array de objetos Book recuperados
            completion(books)
        }
    }
    
    func getBookById(conID id: String, completion: @escaping (Book?) -> Void) {
        db.collection("books").document(id).getDocument { (document, error) in
            if let error = error {
                print("Error al obtener el libro con ID \(id): \(error)")
                completion(nil)
                return
            }
            if let document = document, let data = document.data() {
                // Utilizamos el inicializador failable de la clase Book.
                if let book = Book(document: document as! QueryDocumentSnapshot) {
                    completion(book)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    func getReservedBooksForCurrentUser(completion: @escaping ([Book]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: No hay usuario logeado.")
            completion([])
            return
        }
        
        db.collection("ReserveBooks")
            .whereField("userId", isEqualTo: currentUserId)
            .getDocuments { [weak self] (reserveQuerySnapshot, reserveError) in
                guard let self = self else { return }
                
                if let reserveError = reserveError {
                    print("Error al traer reservaciones del usuario: \(reserveError)")
                    completion([])
                    return
                }
                
                guard let reserveDocuments = reserveQuerySnapshot?.documents else {
                    print("No se encontraron reservaciones del usuario actual.")
                    completion([])
                    return
                }
                
                let reservedBookIds = reserveDocuments.compactMap { $0.data()["bookId"] as? String }
                
                if reservedBookIds.isEmpty {
                    completion([])
                    return
                }
                
                db.collection("books")
                    .whereField(FieldPath.documentID(), in: reservedBookIds)
                    .getDocuments { (bookQuerySnapshot, bookError) in
                        if let bookError = bookError {
                            print("Error fetching reserved books: \(bookError)")
                            completion([])
                            return
                        }
                        
                        let reservedBooks = bookQuerySnapshot?.documents.compactMap { Book(document: $0) } ?? []
                        completion(reservedBooks)
                    }
            }
    }
    
}
