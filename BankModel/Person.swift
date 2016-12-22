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
    let employee: Bool
  
    
    public init(firstName: String, lastName: String, email: String, isEmployee: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.employee = isEmployee
    }
    
    init?(dictionary: [String: Any]){
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.employee = dictionary["employee"] as? Bool ?? false
    }
}

class Individual: Person, Equatable {
    var accounts: [BankAccount]
    
    init(firstName: String, lastName: String, email: String, isEmploy: Bool, accounts: [BankAccount]){
        self.accounts = accounts
        super.init(firstName: firstName, lastName: lastName, email: email, isEmployee: isEmploy)
    }
    
    override init?(dictionary: [String: Any]){
        if let tmp = dictionary["accounts"] as? [[String: Any]] {
            self.accounts = []
            for dictionary in tmp {
                if let tmpAccount = BankAccount(dictionary: dictionary){
                    self.accounts.append(tmpAccount)
                }
            }
        } else {
            self.accounts = []
        }
        super.init(dictionary: dictionary)
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
    
    func allCheckingAccounts() -> [CheckingAccount] {
        var checking: [CheckingAccount] = []
        for i in self.accounts {
            if i.accountType == .checking {
                checking.append(i as! CheckingAccount) // is a force unwrap ok here?
            }
        }
        return checking
    }
    
    
    func allSavingsAccounts() -> [SavingsAccount] {
        var savings: [SavingsAccount] = []
        for i in self.accounts {
            if i.accountType == .saving{
                savings.append(i as! SavingsAccount) // is a force unwrap ok here?
            }
        }
        return savings
    }
    
    
}
