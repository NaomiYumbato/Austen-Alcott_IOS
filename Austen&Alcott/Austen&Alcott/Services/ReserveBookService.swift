//
//  ReserveBookService.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import FirebaseFirestore
import FirebaseAuth

class ReserveBookService {
    let db = Firestore.firestore()

    func reserveBook(userId: String, bookId: String, reservationDate: Date, completion: @escaping (Error?) -> Void) {
        let reservationData: [String: Any] = [
            "userId": userId,
            "bookId": bookId,
            "reservationDate": Timestamp(date: reservationDate),
            "status": "active"
        ]

        db.collection("ReserveBooks").addDocument(data: reservationData) { error in
            completion(error)
        }
    }

    func updateBookReservationStatus(bookId: String, isReserved: Bool, completion: @escaping (Error?) -> Void) {
        db.collection("books").document(bookId).updateData(["isReservate": isReserved]) { error in
            completion(error)
        }
    }
}
