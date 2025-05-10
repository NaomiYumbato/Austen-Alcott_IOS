//
//  User.swift
//  Austen&Alcott
//
//  Created by DAMII on 4/05/25.
//

struct User {
    var email: String
    var firstName: String
    var lastName: String
    var password: String
    var phone: Int
    
    init(email: String, firstName: String, lastName: String, password: String, phone: Int) {
            self.email = email
            self.phone = phone
            self.firstName = firstName
            self.lastName = lastName
            self.password = password
        }
}
