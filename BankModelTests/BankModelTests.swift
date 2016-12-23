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
    
    func testAddTransaction(){
        let transaction1 = Transaction(amount:10, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let account1 = BankAccount(balance: 0, accountID: 0, accountType: .saving, transactionList: [])
        account1.addTransaction(transaction1)
        let expected = [transaction1]
        XCTAssertEqual(expected, account1.transactionList)
    }
    
    func testAddTransaction2(){
        let transaction1 = Transaction(amount:10, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let transaction2 = Transaction(amount:10, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let account1 = BankAccount(balance: 0, accountID: 0, accountType: .saving, transactionList: [])
        account1.addTransaction(transaction1)
        account1.addTransaction(transaction2)
        let expected = [transaction1, transaction2]
        XCTAssertEqual(expected, account1.transactionList)
    }
    
    func testTransactionEquality(){
        let transaction1 = Transaction(amount:10, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let x = transaction1
        XCTAssertTrue(x == transaction1)
    }
    
    func testdeposit(){
        let account1 = BankAccount(balance: 0, accountID: 0, accountType: .saving,transactionList: [])
        do{
            try account1.deposit(amount: 125)
        } catch {
            print("\(error)")
        }
        XCTAssertEqual(account1.balance, 125.0)
    }
    
    func testdeposit1(){
        let account1 = BankAccount(balance: 0, accountID: 1, accountType: .checking, transactionList: [])
        XCTAssertThrowsError(try account1.deposit(amount: -125))
    }
    
    func testWithdraw(){
        let account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking,transactionList: [])
        do{
            try account2.withdraw(amount: 4)
        } catch {
            print("\(error)")
        }
        XCTAssertEqual(account2.balance, 1.0)
    }
    
    func testWithdraw1(){
        let account4 = BankAccount(balance: 0, accountID: 3, accountType: .checking, transactionList: [])
        XCTAssertThrowsError(try account4.withdraw(amount: -10))
    }
    
    func testNotEqual(){
    let account4 = BankAccount(balance: 0, accountID: 3, accountType: .checking, transactionList: [])
    let account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking,transactionList: [])
    XCTAssert( account4 != account2)
    }
    
    func testEqual(){
        let account1 = BankAccount(balance: 5, accountID: 2, accountType: .checking, transactionList: [])
        let account2 = BankAccount(balance: 5, accountID: 2, accountType: .checking, transactionList: [])
        XCTAssert( account1 == account2)
    }
    
    func testRunningTotal(){
        let transaction1 = Transaction(amount:10, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let transaction2 = Transaction(amount:10, operation: .deposit, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let transaction3 = Transaction(amount:40, operation: .withdraw, vendorName: "bank", datePosted: Date(), dateCreated: Date(), memo: nil)
        let account1 = BankAccount(balance: 400, accountID: 0, accountType: .saving, transactionList: [])
        account1.addTransaction(transaction1)
        account1.addTransaction(transaction2)
        account1.addTransaction(transaction3)
        let result = account1.runningTotal()
        let expected = [(transaction1, Double(390)), (transaction2, Double(400)), (transaction3, Double(360))]
        let firstResult = result[0]
        let firstExpected = expected[0]
        let secondResult = result[1]
        let secondExpected = expected[1]
        let thirdResult = result[2]
        let thirdExpected = expected[2]
        XCTAssertEqual(firstResult.0, firstExpected.0)
        XCTAssertEqual(secondResult.0, secondExpected.0)
        XCTAssertEqual(thirdResult.0, thirdExpected.0)
    }
    
    func testToDictionary(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let dictionary = account1.toDictionary()
        let expected: [String: Any] = [
            "balance": 100,
            "accountID": 0,
            "accountType": 0,
            "transactionList": []
        ]
        if let dictionary1 = (dictionary["balance"] as? Double),
            let expected1 = (expected["balance"] as? Double),
            let dictionary2 = (dictionary["transactionList"]) as? [Transaction],
            let expected2 = (expected["transactionList"]) as? [Transaction] {
            XCTAssertEqual(dictionary1, expected1)
            XCTAssertEqual(dictionary2, expected2)
            XCTAssertEqual(dictionary["accountId"] as? Int, expected["accountID"] as? Int)
        }
    }
    
    func testINIT(){
        let dictionary: [String: Any] = [
            "balance": 100.0,
            "accountID": 10,
            "accountType": "savings",
            "transactionList": []
        ]
        
        if let newAccount = SavingsAccount(dictionary: dictionary) {
                XCTAssertEqual(100, newAccount.balance)
                XCTAssertEqual(10, newAccount.accountID)
                XCTAssertEqual(AccountType.saving, newAccount.accountType)
                XCTAssertEqual([], newAccount.transactionList)
        } else {
            XCTAssert(false)
        }
    }
    
    func testINIT2(){
        let dictionary: [String: Any] = [
            "balance": 100.0,
            "accountID": 0,
            "accountType": "checking",
            "transactionList": []
        ]
        
        if let newAccount = CheckingAccount(dictionary: dictionary) {
            
                XCTAssertEqual(100, newAccount.balance)
                XCTAssertEqual(.checking, newAccount.accountType)
                XCTAssertEqual(0, newAccount.accountID)
                XCTAssertEqual([], newAccount.transactionList)
        } else {
            XCTAssert(false)
        }
    }
    
    //MARK: Person and subclass tests
    
    func testTotalAccountSum(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let x = bob.totalAccountSum()
        XCTAssertEqual(x, 105)
    }
    
    func testTotalAccountSum1(){
        let account1 = SavingsAccount(balance: 0, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 0, accountID: 1, accountType: .checking, transactionList: [])
        let bobby = Individual(firstName: "Bobby", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let x = bobby.totalAccountSum()
        XCTAssertEqual(x, 0)
    }
    
    func testAddNewCustomer(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let firstBank = Bank(address: "DownTheStreet")
        firstBank.addNewCustomer(new: bob)
        XCTAssertEqual(firstBank.customers[0], bob)
    }
    
    func testEquatable(){
        let firstBank = Bank(address: "DownTheStreet")
        let secondBank = Bank(address: "acrossTheStreet")
        XCTAssertFalse(firstBank == secondBank)
    }
    
    func testGetAllCheckingAccount(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let result = bob.allCheckingAccounts()
        let expected = [account2]
        XCTAssertEqual(result, expected)
    }
    
    func testGetAllCheckingAccount1(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1])
        let result = bob.allCheckingAccounts()
        let expected: [CheckingAccount] = []
        XCTAssertEqual(result, expected)
    }
    
    func testGetAllSavingAccount(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let result = bob.allSavingsAccounts()
        let expected = [account1]
        XCTAssertEqual(result, expected)
    }
    
    func testGetAllSavingAccount1(){
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [])
        let result = bob.allSavingsAccounts()
        let expected: [SavingsAccount] = []
        XCTAssertEqual(result, expected)
    }
    
    func testPersonINIT(){
        let dictionary: [String: Any] = [
            "firstName" : "Bob",
            "lastName": "smith",
            "email": "b@s.com",
             "employee": false,
             "accounts" : [] // test with accounts as well
        ]
        
        let newIndividual = Individual(dictionary: dictionary)
        XCTAssert((newIndividual?.employee) == (dictionary["employee"] as? Bool))
        XCTAssert((newIndividual?.email) == (dictionary["email"] as? String))
        XCTAssert((newIndividual?.lastName) == (dictionary["lastName"] as? String))
        XCTAssert((newIndividual?.firstName) == (dictionary["firstName"] as? String))
        
        let actual: [BankAccount] = newIndividual?.accounts ?? []
        let expected: [BankAccount] = dictionary["accounts"] as! [BankAccount]
        XCTAssert(actual == expected)
    }
    
    func testPersonINIT2(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let dictionary: [String: Any] = [
            "firstName" : "Bob",
            "lastName": "smith",
            "email": "b@s.com",
            "employee": false,
            "accounts" : [account1.toDictionary(), account2.toDictionary()]
        ]
        
        let newIndividual = Individual(dictionary: dictionary)
        XCTAssert((newIndividual?.employee) == (dictionary["employee"] as? Bool))
        XCTAssert((newIndividual?.email) == (dictionary["email"] as? String))
        XCTAssert((newIndividual?.lastName) == (dictionary["lastName"] as? String))
        XCTAssert((newIndividual?.firstName) == (dictionary["firstName"] as? String))
        
        let actual: [BankAccount] = newIndividual?.accounts ?? []
        let expected: [BankAccount] = [account1, account2]
        
        
        XCTAssert(actual[0] == expected[0])
        XCTAssert(actual[1] == expected[1])
    }
    
    //Mark: Bank Tests
    
    func testbankAccountTotal(){
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "Bob", lastName: "Smith", email: "bon@smith.com", isEmploy: true, accounts: [account1, account2])
        let account3 = SavingsAccount(balance: 100, accountID: 2, accountType: .saving, transactionList: [])
        let account4 = CheckingAccount(balance: 100, accountID: 3, accountType: .checking, transactionList: [])
        let bobby = Individual(firstName: "Bobby", lastName: "Smith", email: "bobby@smith.com", isEmploy: false, accounts: [account3, account4])
        
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
        let account1 = SavingsAccount(balance: 100, accountID: 0, accountType: .saving, transactionList: [])
        let account2 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
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
    
    
    
    
    func testToFromJSON1(){
        let defaultDate = Date()
        let x = defaultDate.toString()
        let y = (try? x.toDate()) ?? Date()
        let moveMoney = Transaction(amount: 45, operation: .withdraw, vendorName: "firstBank", datePosted: y, dateCreated: y, memo: "money")
        let moveMoney1 = Transaction(amount: 50, operation: .deposit, vendorName: "firstBank", datePosted: y, dateCreated: y, memo: "money")
        let account1 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [moveMoney, moveMoney1])
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [account1])
        let firstBank = Bank(address: "here")
        firstBank.employees = [bob]
        firstBank.addNewCustomer(new: bob)
        do{
            let data = try firstBank.toJSON()
            let newBank = Bank(json: data)
            XCTAssertEqual(newBank?.address, firstBank.address)
            XCTAssertEqual(newBank?.employees[0], firstBank.employees[0])
            
        } catch {
            XCTAssert(false)
        }
    }
    
    func testToFromJSON2(){ // need to "break apart bank to test!
        let account1 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [account1])
        let firstBank = Bank(address: "here")
        firstBank.employees = [bob]
        firstBank.addNewCustomer(new: bob)
        do{
            let data = try firstBank.toJSON()
            let newBank = Bank(json: data)
            XCTAssertEqual((newBank!.address), (firstBank.address))
        } catch {
            XCTAssert(false)
        }
    }
    
    func testToFromJSON3(){
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [])
        let firstBank = Bank(address: "here")
        firstBank.employees = [bob]
        firstBank.addNewCustomer(new: bob)
        do{
            let data = try firstBank.toJSON()
            let newBank = Bank(json: data)
            XCTAssert(newBank == firstBank)
        } catch {
            XCTAssert(false)
        }
    }
    
    //Mark: Transaction Tests
    
    func testTransactionToDictionary(){
        let expectedDatePostedText = "2016-12-22T23:59:40Z"
        let expecteddateCreatedText = "2016-12-22T22:59:40Z"
        let expectedDatePosted = (try? expectedDatePostedText.toDate()) ?? Date()
        let expectedDateCreated = (try? expecteddateCreatedText.toDate()) ?? Date()
        let moveMoney = Transaction(amount: 45, operation: .withdraw, vendorName: "firstBank", datePosted: expectedDatePosted, dateCreated: expectedDateCreated, memo: "money")
        let result = moveMoney.toDictionary()
        let resultAmount: Double = result["amount"] as? Double ?? 0.0
        let resultOperation: Int = result["operation"] as? Int ?? 0
        let resultVendorName: String = result["vendorName"] as? String ?? ""
        let resultDatePosted: String = result["datePosted"] as? String ?? ""
        let resultDateCreated: String = result["dateCreated"] as? String ?? ""
        let resultMemo: String = result["memo"] as? String ?? ""
        XCTAssertEqual(resultAmount, Double(45))
        XCTAssertEqual(resultOperation, -1)
        XCTAssertEqual(resultVendorName, "firstBank")
        XCTAssertEqual(resultDatePosted,  expectedDatePostedText)
        XCTAssertEqual(resultDateCreated, expecteddateCreatedText)
        XCTAssertEqual(resultMemo, "money")
    }
    
    
    //MARK: dates
    
    func testDateToAndFromString(){
        let x = (try? "2016-12-22T22:59:40Z".toDate()) ?? Date()
        let firstResult = x.toString()
        let secondResult = (try? firstResult.toDate()) ?? Date()
        XCTAssertEqual(x, secondResult)
    }
    
    //Mark: JSON Tests
    
    func testJsonForAll(){
        let defaultDate = Date()
        let defaultDate2 = Date()
        let moveMoney = Transaction(amount: 45, operation: .withdraw, vendorName: "firstBank", datePosted: defaultDate, dateCreated: defaultDate2, memo: "money")
        let moveMoney1 = Transaction(amount: 50, operation: .deposit, vendorName: "firstBank", datePosted: defaultDate, dateCreated: defaultDate2, memo: "money")
        let account1 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [moveMoney, moveMoney1])
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [account1])
        let firstBank = Bank(address: "here")
        firstBank.employees = [bob]
        firstBank.addNewCustomer(new: bob)
        do{
            let data = try firstBank.toJSON()
            let newBank = Bank(json: data)
            XCTAssert(newBank == firstBank)
        } catch {
            XCTAssert(false)
        }
    }

    
    func testJsonForSome(){
        let account1 = CheckingAccount(balance: 5, accountID: 1, accountType: .checking, transactionList: [])
        let bob = Individual(firstName: "bob", lastName: "smith", email: "b@s.com", isEmploy: true, accounts: [account1])
        let account2 = CheckingAccount(balance: 5, accountID: 2, accountType: .checking, transactionList: [])
        let linda = Individual(firstName: "Linda", lastName: "smith", email: "l@s.com", isEmploy: false, accounts: [account2])
        
        let firstBank = Bank(address: "here")
        firstBank.employees = [bob]
        firstBank.addNewCustomer(new: bob)
        firstBank.addNewCustomer(new: linda)
        do{
            let data = try firstBank.toJSON()
            if let newBank: Bank = Bank(json: data) {
                XCTAssert(newBank == firstBank)
            }
        } catch {
            XCTAssert(false)
        }
    }
}
