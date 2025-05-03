//
//  Book.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 17/04/25.
//

import Foundation

class Book {
    var title: String
    var author: String
    var progress: Int
    
    init(title: String, author: String, progress: Int) {
        self.title = title
        self.author = author
        self.progress = progress
    }
}
