//
//  TransactionsListView.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 12/3/24.
//

import SwiftUI

struct TransactionsListView: View
{
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController: DataController
    
    var body: some View
    {
        List
        {
            ForEach($dataController.transactions, editActions: .delete)
            { $transaction in
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text(transaction.title ?? "Error")
                            .font(.headline)
                        Text("\(transaction.category ?? "Error") - \(transaction.date?.formatted(.dateTime.year().month().day()) ?? "Error")")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Text(transaction.amount < 0 ? "-$\(abs(transaction.amount), specifier: "%.2f")" : "$\(transaction.amount, specifier: "%.2f")")
                        .foregroundStyle(transaction.amount < 0 ? .red : .green)
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(offsets: IndexSet)
    {
        offsets.map { dataController.transactions[$0] }.forEach(moc.delete)
        dataController.transactions.remove(atOffsets: offsets)
        do
        {
            try moc.save()
        }
        catch
        {
            // Handle the Core Data error here
            print("Error saving managed object context: \(error.localizedDescription)")
        }
    }
}

#Preview
{
    TransactionsListView()
}
