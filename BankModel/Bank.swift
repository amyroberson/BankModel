//
//  Bank.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation



class Bank : Equatable {
    var employees: [Individual]
    var customers: [Individual]
    var address: String
    var accounts: [BankAccount] { //look up flatmap to clean this up
        var totalAccounts: [BankAccount] = []
        for customer in customers{
            for account in customer.accounts{
                totalAccounts.append(account)
            }
        }
        return totalAccounts
    }
    
    init(address: String){
        employees = []
        customers = []
        self.address = address
    }
    
    init?(json: Data) {
        do{
            guard let jsonObject = try JSONSerialization.jsonObject(with:json, options: []) as? [String: Any] else {
                return nil
            }
            self.employees = jsonObject["employees"] as? [Individual] ?? []
            self.customers = jsonObject["customers"] as? [Individual] ?? []
            self.address = jsonObject["address"] as? String ?? ""
        } catch {
            return nil
        }
    }
    
    
    func addNewCustomer(new: Individual){
        customers.append(new)
    }
    
   func bankAccountTotals() -> Double{
        var total = 0.0
        for account in accounts{
            total += account.balance
        }
        return total
    }
    
    static func ==(_ lhs: Bank, _ rhs: Bank) -> Bool {
        return lhs.accounts == rhs.accounts &&
            lhs.customers == rhs.customers &&
            lhs.employees == rhs.employees &&
            lhs.address == rhs.address
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary: [String : Any] = [
            "employees": self.employees.map{ $0.toDictionary() },
            "customers": self.employees.map{ $0.toDictionary() },
            "address": self.address,
            "accounts": self.accounts.map{ $0.toDictionary() }
        ]
        return dictionary
    }
    
    func toJSON() throws -> Data {
        let jsonRepresentation = try JSONSerialization.data(withJSONObject: self.toDictionary(), options: [])
        return jsonRepresentation
    }
    
}
