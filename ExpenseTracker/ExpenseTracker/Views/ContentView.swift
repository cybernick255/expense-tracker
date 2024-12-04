//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 11/27/24.
//

import SwiftUI
import Charts

import CoreData

struct ContentView: View
{
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController: DataController
    
    @State private var showAddTransaction: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                // Display total balance
                Text("Total Balance: $\(dataController.totalBalance(), specifier: "%.2f")")
                    .font(.largeTitle)
                    .padding()
                
                // List of transactions
                TransactionsListView()
                
                if !dataController.transactions.isEmpty
                {
                    SpendingByCategoryChartView()
                }
                
                Spacer()
                
                Button(action: { showAlert = true })
                {
                    Text("Delete All Transactions")
                        .padding()
                        .background(Capsule().fill(.red))
                        .foregroundStyle(.white)
                }
                .alert("Are you sure?", isPresented: $showAlert)
                {
                    Button("No", role: .cancel){}
                    Button("Yes", role: .destructive)
                    {
                        deleteAllTransactions()
                    }
                }
            }
            .toolbar
            {
                ToolbarItem(placement: .topBarTrailing)
                {
                    // Add transaction button
                    Button(action: { showAddTransaction.toggle() })
                    {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showAddTransaction)
                    {
                        AddTransactionView()
                            .environment(\.colorScheme, .dark)
                    }
                }
            }
            .navigationTitle("Expense Tracker")
        }
    }
    
    private func deleteAllTransactions()
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Transaction")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do
        {
            try moc.execute(batchDeleteRequest)
            try moc.save()
            dataController.transactions.removeAll()
        }
        catch
        {
            // Handle the error here
            print("Error deleting transactions: \(error.localizedDescription)")
        }
    }
}

#Preview
{
    ContentView()
        .environmentObject(DataController())
}
