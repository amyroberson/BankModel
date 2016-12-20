//
//  Account.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

enum AccountType{
    case saving
    case checking
}

enum AmountError : Error{
    case notEnoughInAccount
    case notAReasonableAmount
}

public struct BankAccount: Equatable {
    var balance: Double
    let accountID: Int
    let accountType: AccountType
    
    public mutating func withdraw(amount: Double) throws {
        guard amount > -1 else{
            throw AmountError.notAReasonableAmount
        }
        if self.balance > amount {
            balance = (balance - amount)
        } else {
            throw AmountError.notEnoughInAccount
        }
    }
    
    public mutating func deposit(amount: Double) throws {
        guard amount > -1 else{
            throw AmountError.notAReasonableAmount
        }
        self.balance += amount
    }
    
    public static func ==(_ lhs: BankAccount, _ rhs: BankAccount) -> Bool {
        return lhs.balance == rhs.balance &&
        lhs.accountID == rhs.accountID &&
        lhs.accountType == rhs.accountType
    }
}
