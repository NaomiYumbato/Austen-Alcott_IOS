import Foundation
import FirebaseFirestore

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
    
}
