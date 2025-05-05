//
//  ReserveBook.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import Foundation
import FirebaseFirestore

class ReserveBook {
    let id: String?
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
}
