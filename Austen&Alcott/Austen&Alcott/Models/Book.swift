import Foundation
import FirebaseFirestore

class Book {
    let id: String?
    var author: String?
    var description: String?
    var editorial: String?
    var imageUrl: String?
    var isReservate: Bool?
    var title: String?

    init(id: String? = nil, author: String? = nil, description: String? = nil, editorial: String? = nil, imageUrl: String? = nil, isReservate: Bool? = nil, title: String? = nil) {
        self.id = id
        self.author = author
        self.description = description
        self.editorial = editorial
        self.imageUrl = imageUrl
        self.isReservate = isReservate
        self.title = title
    }

    // Inicializador desde un Dictionary (Sirve para leer datos desde Firestore)
    init?(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let data = document.data()

        self.author = data["author"] as? String
        self.title = data["title"] as? String
        self.description = data["description"] as? String
        self.editorial = data["editorial"] as? String
        self.imageUrl = data["imageUrl"] as? String
        self.isReservate = data["isReservate"] as? Bool
    }
}
