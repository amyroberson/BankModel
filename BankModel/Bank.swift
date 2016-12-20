//
//  Bank.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

class Bank : JSONSerialization {
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
}
