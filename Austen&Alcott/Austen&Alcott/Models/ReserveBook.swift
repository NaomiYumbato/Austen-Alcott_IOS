//
//  ReserveBook.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import Foundation
import FirebaseFirestore

class ReserveBook: Identifiable {
    // Conformando a Identifiable para usar en List o ForEach en SwiftUI
    var id: String?
    let userId: String
    let bookId: String
    let reservationDate: Date
    var status: String = "active"

    
    init(id: String? = nil, userId: String, bookId: String, reservationDate: Date, status: String = "active") {
        self.id = id
        self.userId = userId
        self.bookId = bookId
        self.reservationDate = reservationDate
        self.status = status
    }
    
    // Función para convertir el objeto a un Dictionary para guardar en Firestore
    func toFirestore() -> [String: Any] {
        let firestoreData: [String: Any] = [
            "userId": userId,
            "bookId": bookId,
            "reservationDate": Timestamp(date: reservationDate),
            "status": status
        ]
        
        return firestoreData
    }
    
    // Inicializador desde un Dictionary para desde Firestore
    init?(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let data = document.data()
        
        guard
            let userId = data["userId"] as? String,
            let bookId = data["bookId"] as? String,
            let reservationDateTimestamp = data["reservationDate"] as? Timestamp
        else {
            return nil
        }
        
        self.userId = userId
        self.bookId = bookId
        self.reservationDate = reservationDateTimestamp.dateValue()
        self.status = data["status"] as? String ?? "active"
        
    }
}
