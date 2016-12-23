//
//  Transaction.swift
//  BankModel
//
//  Created by Amy Roberson on 12/21/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import Foundation

enum DateError: Error {
    case dateParserError
}

enum TransactionOperation: Int {
    case withdraw = -1
    case deposit = 1
}

struct Transaction: Equatable {
    let amount: Double
    let operation: TransactionOperation
    let vendorName: String
    let datePosted: Date
    let dateCreated: Date
    let memo: String?
    
    init(amount: Double, operation: TransactionOperation, vendorName: String, datePosted: Date, dateCreated: Date, memo: String?){
        self.amount = amount
        self.operation = operation
        self.vendorName = vendorName
        self.datePosted = datePosted
        self.dateCreated = dateCreated
        self.memo = memo
    }
    init?(dictionary: [String: Any]){
        self.amount = dictionary["amount"] as? Double ?? 0.0
        self.operation = dictionary["operation"] as? TransactionOperation ?? .deposit
        self.vendorName = dictionary["vendorName"] as? String ?? ""
        //need some dos
        self.datePosted = dictionary["datePosted"] as? Date ?? Date()
        self.dateCreated = dictionary["dateCreated"] as? Date ?? Date()
        self.memo = dictionary["memo"] as? String? ?? nil
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "amount": self.amount,
            "operation": self.operation.rawValue,
            "vendorName": self.vendorName,
            "datePosted": self.datePosted.toString(),
            "dateCreated": self.dateCreated.toString(),
            "memo": self.memo
            ]
        return dictionary
    }
    
    static func ==(_ lhs: Transaction, _ rhs: Transaction) -> Bool{
        return lhs.amount == rhs.amount &&
            lhs.operation == rhs.operation &&
            lhs.vendorName == rhs.vendorName &&
            lhs.datePosted == rhs.datePosted &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.memo == rhs.memo
    }

}
