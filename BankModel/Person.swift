//
//  Person.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

class Person: JSONSerialization {
    let firstName : String
    let lastName: String
    let email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

class Individual: Person, Equatable{
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
}
