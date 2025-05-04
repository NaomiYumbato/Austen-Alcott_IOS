//
//  User.swift
//  Austen&Alcott
//
//  Created by DAMII on 4/05/25.
//

class User {
    var email: String
    var lastName: String
    var firstName: String
    var password: String
    var phone: Int
    
    init(email: String, lastName: String, firstName: String, password: String, phone: Int) {
            self.email = email
            self.phone = phone
            self.lastName = lastName
            self.firstName = firstName
            self.password = password
        }
}
