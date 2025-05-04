//
//  Book.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 17/04/25.
//

import Foundation

class Book: Identifiable {
    var id: String?
    let author: String?
    let description: String?
    let editorial: String?
    let imageUrl: String?
    let isReservate: Bool?
    let title: String?
    
    init(id: String? = nil, author: String? = nil, description: String? = nil, editorial: String? = nil, imageUrl: String? = nil, isReservate: Bool? = nil, title: String? = nil) {
        self.id = id
        self.author = author
        self.description = description
        self.editorial = editorial
        self.imageUrl = imageUrl
        self.isReservate = isReservate
        self.title = title
    }
}
