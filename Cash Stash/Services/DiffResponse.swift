//
//  DiffResponse.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import Foundation

//MARK: - DiffResponse
struct DiffResponse: Codable, Equatable {
    let serverTimestamp: Int
    let instrument: [Int: Instrument]
    let country: [Country]
    let company: [Company]
    let user: [User]
    let account: [Account]
    let tag: [String: Tag]
    let budget: [Budget]?
    let merchant: [Merchant]?
    let reminder: [Reminder]?
    let reminderMarker: [ReminderMarker]?
    let transaction: [Transaction]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        serverTimestamp = try container.decode(Int.self, forKey: .serverTimestamp)
        instrument = try container.decode([Instrument].self, forKey: .instrument).reduce(into: [Int: Instrument]()) {
            $0[$1.id] = $1
        }
        country = try container.decode([Country].self, forKey: .country)
        company = try container.decode([Company].self, forKey: .company)
        user = try container.decode([User].self, forKey: .user)
        account = try container.decode([Account].self, forKey: .account)
        tag = try container.decode([Tag].self, forKey: .tag).reduce(into: [String: Tag]()) {
            $0[$1.id] = $1
        }
        budget = try? container.decode([Budget].self, forKey: .budget)
        merchant = try? container.decode([Merchant].self, forKey: .merchant)
        reminder = try? container.decode([Reminder].self, forKey: .reminder)
        reminderMarker = try? container.decode([ReminderMarker].self, forKey: .reminderMarker)
        var transactions = try container.decode([Transaction].self, forKey: .transaction)
        
        for i in transactions.indices {
            transactions[i].incomeTransactionInstrument = instrument[transactions[i].incomeInstrument]
            transactions[i].outcomeTransactionInstrument = instrument[transactions[i].outcomeInstrument]
            
            transactions[i].categories = []
            for stringTag in transactions[i].tag ?? [] {
                if let unwrappedTag = tag[stringTag] {
                    transactions[i].categories?.append(unwrappedTag)
                }
            }
            
            if let account = account.filter({ $0.id == transactions[i].incomeAccount }).first {
                transactions[i].toAccount = account
            }
            if let account = account.filter({ $0.id == transactions[i].outcomeAccount }).first {
                transactions[i].fromAccount = account
            }
        }
        transaction = transactions
    }
}

//MARK: - Account
struct Account: Codable, Equatable {
    let id: String
    let user: Int
    let instrument: Int?
    let type: String
    let role: Int?
    let accountPrivate: Bool
    let savings: Bool?
    let title: String
    let inBalance: Bool
    let creditLimit, startBalance, balance: Double?
    let company: Int?
    let archive, enableCorrection: Bool
    let startDate: String?
    let percent: Double?
    let capitalization: Bool?
    let changed: Int
    let syncID: [String]?
    let enableSMS: Bool
    let endDateOffset: Int?
    let endDateOffsetInterval: String?
    let payoffStep: Int?
    let payoffInterval: String?
    
    enum CodingKeys: String, CodingKey {
        case id, user, instrument, type, role
        case accountPrivate = "private"
        case savings, title, inBalance, creditLimit, startBalance,
             balance, company, archive, enableCorrection, startDate,
             capitalization, percent, changed, syncID, enableSMS,
             endDateOffset, endDateOffsetInterval, payoffStep, payoffInterval
    }
}

//MARK: - Budget
struct Budget: Codable, Equatable {
    let user, changed: Int
    let date: String
    let tag: String?
    let income: Int
    let outcome: Double
    let incomeLock, outcomeLock: Bool
}

//MARK: - Company
struct Company: Codable, Equatable {
    let id: Int
    let title: String
    let www: String?
    let country: Int?
    let fullTitle: String?
    let changed: Int
    let deleted: Bool
    let countryCode: String?
}

//MARK: - Country
struct Country: Codable, Equatable {
    let id: Int
    let title: String
    let currency: Int
    let domain: String?
}

//MARK: - Instrument
struct Instrument: Codable, Equatable {
    let id: Int
    let title, shortTitle, symbol: String
    let rate: Double
    let changed: Int
}

//MARK: - Merchant
struct Merchant: Codable, Equatable {
    let id: String
    let user: Int
    let title: String
    let changed: Int
}

//MARK: - Reminder
struct Reminder: Codable, Equatable {
    let id: String
    let user: Int
    let income, outcome: Double
    let changed, incomeInstrument, outcomeInstrument, step: Int
    let points: [Int]?
    let tag: [String]?
    let startDate: String
    let endDate: String?
    let notify: Bool
    let interval: String?
    let incomeAccount, outcomeAccount: String
    let comment: String?
    let payee: String?
    let merchant: String?
}

//MARK: - ReminderMarker
struct ReminderMarker: Codable, Equatable {
    let id: String
    let user: Int
    let date: String
    let income, outcome: Double
    let changed, incomeInstrument, outcomeInstrument: Int
    let state: State
    let reminder, incomeAccount, outcomeAccount: String
    let comment: String?
    let payee, merchant: String?
    let notify: Bool
    let tag: [String]?
}

enum State: String, Codable {
    case deleted
    case planned
    case processed
}

//MARK: - Tag
struct Tag: Codable, Equatable {
    let id: String
    let user: Int?
    let changed: Int
    let icon: String?
    let budgetIncome, budgetOutcome: Bool
    let tagRequired: Bool?
    let color: Int?
    let picture: String?
    let title: String
    let showIncome, showOutcome: Bool
    let parent: String?
    
    enum CodingKeys: String, CodingKey {
        case id, user, changed, icon, budgetIncome, budgetOutcome
        case tagRequired = "required"
        case color, picture, title, showIncome, showOutcome, parent
    }
}

//MARK: - Transaction
struct Transaction: Codable, Equatable {
    let id: String
    let user: Int
    let date: Date
    let income, outcome: Double
    let changed, incomeInstrument, outcomeInstrument, created: Int
    let originalPayee: String?
    let deleted, viewed: Bool
    let hold: Bool?
    let qrCode: String?
    let incomeAccount, outcomeAccount: String
    let tag: [String]?
    let comment: String?
    let payee: String?
    let opIncome: Double?
    let opOutcome: Double?
    let opIncomeInstrument: Int?
    let opOutcomeInstrument: Int?
    let latitude, longitude: Double?
    let merchant, incomeBankID, outcomeBankID, reminderMarker: String?
    var incomeTransactionInstrument, outcomeTransactionInstrument: Instrument?
    var categories: [Tag]?
    var fromAccount: Account?
    var toAccount: Account?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        user = try container.decode(Int.self, forKey: .user)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date = formatter.date(from: try container.decode(String.self, forKey: .date))!
        
        income = try container.decode(Double.self, forKey: .income)
        outcome = try container.decode(Double.self, forKey: .outcome)
        changed = try container.decode(Int.self, forKey: .changed)
        incomeInstrument = try container.decode(Int.self, forKey: .incomeInstrument)
        outcomeInstrument = try container.decode(Int.self, forKey: .outcomeInstrument)
        created = try container.decode(Int.self, forKey: .created)
        originalPayee = try? container.decode(String.self, forKey: .originalPayee)
        deleted = try container.decode(Bool.self, forKey: .deleted)
        viewed = try container.decode(Bool.self, forKey: .viewed)
        hold = try? container.decode(Bool.self, forKey: .hold)
        qrCode = try? container.decode(String.self, forKey: .qrCode)
        incomeAccount = try container.decode(String.self, forKey: .incomeAccount)
        outcomeAccount = try container.decode(String.self, forKey: .outcomeAccount)
        tag = try? container.decode([String].self, forKey: .tag)
        comment = try? container.decode(String.self, forKey: .comment)
        payee = try? container.decode(String.self, forKey: .payee)
        opIncome = try? container.decode(Double.self, forKey: .opIncome)
        opOutcome = try? container.decode(Double.self, forKey: .opOutcome)
        opIncomeInstrument = try? container.decode(Int.self, forKey: .opIncomeInstrument)
        opOutcomeInstrument = try? container.decode(Int.self, forKey: .opOutcomeInstrument)
        latitude = try? container.decode(Double.self, forKey: .latitude)
        longitude = try? container.decode(Double.self, forKey: .longitude)
        merchant = try? container.decode(String.self, forKey: .merchant)
        incomeBankID = try? container.decode(String.self, forKey: .incomeBankID)
        outcomeBankID = try? container.decode(String.self, forKey: .outcomeBankID)
        reminderMarker = try? container.decode(String.self, forKey: .reminderMarker)
        incomeTransactionInstrument = try? container.decode(Instrument.self, forKey: .incomeTransactionInstrument)
        outcomeTransactionInstrument = try? container.decode(Instrument.self, forKey: .outcomeTransactionInstrument)
        categories = try? container.decode([Tag].self, forKey: .categories)
        fromAccount = try? container.decode(Account.self, forKey: .fromAccount)
        toAccount = try? container.decode(Account.self, forKey: .toAccount)
    }
}

//MARK: - User
struct User: Codable, Equatable {
    let id, country: Int
    let login: String?
    let changed, currency, paidTill: Int
    let parent: Int?
    let countryCode, email: String
    let monthStartDay: Int
    let subscription: String?
}
