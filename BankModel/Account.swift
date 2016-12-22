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

enum AmountError : Error{
    case notEnoughInAccount
    case notAReasonableAmount
}

class BankAccount: Equatable{
    var balance: Double
    let accountID: Int
    let accountType: AccountType
    var transactionList: [Transaction]
    
    
    init(balance: Double, accountID: Int, accountType: AccountType, transactionList: [Transaction]){
        self.balance = balance
        self.accountID = accountID
        self.accountType = accountType
        self.transactionList = transactionList
    }
    
    init?(dictionary: [String: Any]){
        self.balance = dictionary["balance"] as? Double ?? 0.0
        guard let x = dictionary["accountID"] as? Int else { return nil }
        self.accountID = x
        self.accountType = dictionary["accountType"] as? AccountType ?? .saving
        if let tmp = dictionary["transactionList"] as? [[String:Any]] {
            self.transactionList = []
            for dictionary in tmp {
                if let tmpTransaction = Transaction(dictionary: dictionary){
                    self.transactionList.append(tmpTransaction)
                }
            }
        } else {
            self.transactionList = []
        }
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
            "accountType": self.accountType,
            "transactionList": self.transactionList.map{ $0.toDictionary() }
        ]
        return dictionary
    }
    
    func addTransaction(_ item: Transaction){
        self.transactionList.append(item)
    }
    
    func runningTotal()-> [(Transaction, Double)]{
        var array: [(Transaction,Double)] = []
        for i in self.transactionList{
            if i.operation == .withdraw{
                do{
                    try self.withdraw(amount: i.amount)
                } catch {
                print("\(error)")
                }
                let newTuple = (i,self.balance)
                array.append(newTuple)
            }else {
                do{
                    try self.deposit(amount: i.amount)
                } catch {
                    print("\(error)")
                }
                let newTuple = (i,self.balance)
                array.append(newTuple)
            }
        }
        return array
    }
}

class CheckingAccount: BankAccount {
    
}

class SavingsAccount: BankAccount{
    
}
