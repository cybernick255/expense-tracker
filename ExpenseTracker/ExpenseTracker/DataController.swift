//
//  DataController.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 11/27/24.
//

import Foundation
import CoreData

class DataController: ObservableObject
{
    let container = NSPersistentContainer(name: "ExpenseTracker")
    
    @Published var transactions: [Transaction] = []
    
    init()
    {
        container.loadPersistentStores
        { description, error in
            if let error = error
            {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        fetchTransactions()
    }
    
    // Call this to update views
    func fetchTransactions()
    {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        do
        {
            transactions = try container.viewContext.fetch(fetchRequest)
        }
        catch
        {
            print("Failed to fetch transactions: \(error.localizedDescription)")
            transactions = []
        }
    }
    
    // Calculate total balance
    func totalBalance() -> Double
    {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    // Calculate total spent by category
    func totalSpentByCategory() -> [String: Double]
    {
        Dictionary(grouping: transactions, by: { $0.category ?? "Error" }).mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
}
