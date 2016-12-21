//
//  Person.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

public class Person {
    let firstName : String
    let lastName: String
    let email: String
    let dictonary: [String: Any] = [
        "firstName": "Amy",
        "lastName": "Roberson",
        "email": "amy@roberson.xyz"
    ]
    
    public init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

class Individual: Person, Equatable {
    let accounts: [BankAccount]
    let employee: Bool
    
    init(firstName: String, lastName: String, email: String, isEmploy: Bool, accounts: [BankAccount]){
        self.employee = isEmploy
        self.accounts = accounts
        super.init(firstName: firstName, lastName: lastName, email: email)
    }
    
    func totalAccountSum() -> Double {
        var total = 0.0
        for i in self.accounts{
            total += i.balance
        }
        return total
    }
    
    static func ==(_ lhs: Individual, _ rhs: Individual) -> Bool{
        return lhs.employee == rhs.employee &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.email == rhs.email &&
        lhs.accounts == rhs.accounts
    }
    
    func toDictionary() -> [String : Any] {
        let dictionary: [String : Any] = [
            "firstName" : self.firstName,
            "lastName" : self.lastName,
            "email" : self.email,
            "accounts" : self.accounts.map{ $0.toDictionary() },
            "employee" : self.employee,
        ]
        return dictionary
    }
    
    
}
