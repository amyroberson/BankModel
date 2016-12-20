//
//  BankModelTests.swift
//  BankModelTests
//
//  Created by Amy Roberson on 12/20/16.
//  Copyright © 2016 Amy Roberson. All rights reserved.
//

import XCTest
@testable import BankModel

class BankModelTests: XCTestCase {
    
    //MARK: BankAccount tests
    
    func testdeposit(){
        var account1 = BankAccount(balance: 0, accountID: 0, accountType: .saving)
        do{
            try account1.deposit(amount: 125)
        } catch {
            print("\(error)")
        }
        XCTAssertEqual(account1.balance, 125.0)
    }
    
    func testdeposit1(){
        var account1 = BankAccount(balance: 0, accountID: 1, accountType: .checking)
        XCTAssertThrowsError(try account1.deposit(amount: -125))
    }
    
    func testWithdraw(){
        var account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking)
        do{
            try account2.withdraw(amount: 4)
        } catch {
            print("\(error)")
        }
        XCTAssertEqual(account2.balance, 1.0)
    }
    
    func testWithdraw1(){
        var account4 = BankAccount(balance: 0, accountID: 3, accountType: .checking)
        XCTAssertThrowsError(try account4.withdraw(amount: -10))
    }
    
    //MARK: Person and subclass tests
    
    func testTotalAccountSum(){
        let account1 = BankAccount(balance: 100, accountID: 0, accountType: .saving)
        let account2 = BankAccount(balance: 5, accountID: 1, accountType: .checking)
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts:[account1, account2])
        let x = bob.totalAccountSum()
        XCTAssertEqual(x, 105)
    }
    
    func testTotalAccountSum1(){
        let account1 = BankAccount(balance: 0, accountID: 0, accountType: .saving)
        let account2 = BankAccount(balance: 0, accountID: 1, accountType: .checking)
        let bobby = Individual(firstName: "Bobby", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts:[account1, account2])
        let x = bobby.totalAccountSum()
        XCTAssertEqual(x, 0)
    }
    
    func testAddNewCustomer(){
        let account1 = BankAccount(balance: 100, accountID: 0, accountType: .saving)
        let account2 = BankAccount(balance: 5, accountID: 1, accountType: .checking)
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts:[account1, account2])
        let firstBank = Bank(address: "DownTheStreet")
        firstBank.addNewCustomer(new: bob)
        XCTAssertEqual(firstBank.customers[0], bob)
    }
    
    func testEquatable(){
        let firstBank = Bank(address: "DownTheStreet")
        let secondBank = Bank(address: "acrossTheStreet")
        XCTAssertFalse(firstBank == secondBank)
    }
    
    func testbankAccountTotal(){
        let account1 = BankAccount(balance: 100, accountID: 0, accountType: .saving)
        let account2 = BankAccount(balance: 5, accountID: 1, accountType: .checking)
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts:[account1, account2])
                let account3 = BankAccount(balance: 100, accountID: 2, accountType: .saving)
        let account4 = BankAccount(balance: 100, accountID: 3, accountType: .checking)
        let bobby = Individual(firstName: "Bobby", lastName: "Smith", email: "bobby@smith.com", isEmploy: false, accounts:[account3, account3])
        
        let firstBank = Bank(address: "DownTheStreet")
        firstBank.addNewCustomer(new: bob)
        firstBank.addNewCustomer(new: bobby)
        
        let result = firstBank.bankAccountTotals()
        let expected: Double = 305
        XCTAssertEqual(expected, result)

        
    }
    
    
}
