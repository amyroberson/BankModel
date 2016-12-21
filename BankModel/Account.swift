//
//  Account.swift
//  BankModel
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

enum AccountType: Int{
    case saving = 0
    case checking = 1
    
}

enum AmountError : Error{ //backing type for an enum so it can work with type ANY
    case notEnoughInAccount
    case notAReasonableAmount
}

class BankAccount: Equatable{
    var balance: Double
    let accountID: Int
    let accountType: AccountType
    
    
    init(balance: Double, accountID: Int, accountType: AccountType){
        self.balance = balance
        self.accountID = accountID
        self.accountType = accountType
    }
    
    func withdraw(amount: Double) throws {
        guard amount > -1 else{
            throw AmountError.notAReasonableAmount
        }
        if self.balance > amount {
            balance = (balance - amount)
        } else {
            throw AmountError.notEnoughInAccount
        }
    }
    
    func deposit(amount: Double) throws {
        guard amount > -1 else{
            throw AmountError.notAReasonableAmount
        }
        self.balance += amount
    }
    
    static func ==(_ lhs: BankAccount, _ rhs: BankAccount) -> Bool {
        return lhs.balance == rhs.balance &&
        lhs.accountID == rhs.accountID &&
        lhs.accountType == rhs.accountType
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "balance" : self.balance,
            "accountID": self.accountID,
            "accountType": self.accountType]
        return dictionary
    }
}
