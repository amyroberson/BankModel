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
    
    func testNotEqual(){
    let account4 = BankAccount(balance: 0, accountID: 3, accountType: .checking)
    let account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking)
    XCTAssert( account4 != account2)
    }
    
    func testEqual(){
        let account1 = BankAccount(balance: 5, accountID: 2, accountType: .checking)
        let account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking)
        XCTAssert( account1 == account2)
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
        let bobby = Individual(firstName: "Bobby", lastName: "Smith", email: "bobby@smith.com", isEmploy: false, accounts:[account3, account4])
        
        let firstBank = Bank(address: "DownTheStreet")
        firstBank.addNewCustomer(new: bob)
        firstBank.addNewCustomer(new: bobby)
        
        let result = firstBank.bankAccountTotals()
        let expected: Double = 305
        XCTAssertEqual(expected, result)
    }
    
    func testBankToDictionary(){
        let firstBank = Bank(address: "overThere")
        let result = firstBank.toDictionary()
        let employees: [Individual] = []
        let expected: [String: Any] = [
            "employees" : employees,
            "customers" : [],
            "address" : "overThere",
            "accounts" : []
        ]
        let result1 = (result["employees"] as? [Individual])!
        let expected1 = (expected["employees"] as? [Individual])!
        XCTAssertEqual(result1, expected1)
        XCTAssertEqual(result["address"] as? String, expected["address"] as? String)
        XCTAssertEqual((result["customers"] as? [Individual])!, (expected["customers"] as? [Individual])!)
    }
   
    func testBankToDictionary1(){
        let firstBank = Bank(address: "overThere")
        let account1 = BankAccount(balance: 100, accountID: 0, accountType: .saving)
        let account2 = BankAccount(balance: 5, accountID: 1, accountType: .checking)
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [account1, account2])
        firstBank.employees.append(bob)
        let result = firstBank.toDictionary()
        let employees: [Individual] = [bob]
        let expected: [String: Any] = [
            "employees" : employees,
            "customers" : [],
            "address" : "overThere",
            "accounts" : []
        ]
       if let result1 = (result["employees"] as? [Individual]),
        let expected1 = (expected["employees"] as? [Individual]) {
            XCTAssertEqual(result1, expected1)
            XCTAssertEqual(result["address"] as? String, expected["address"] as? String)
            XCTAssertEqual((result["customers"] as? [Individual])!, (expected["customers"] as? [Individual])!)
        }
    }
    
    func testToFromJSON(){
        let firstBank = Bank(address: "Here")
        do{
            let data = try firstBank.toJSON()
            let newBank = Bank(json: data)
            XCTAssert(newBank == firstBank)
        } catch {
            XCTAssert(false)
        }
    }
    
    
}
