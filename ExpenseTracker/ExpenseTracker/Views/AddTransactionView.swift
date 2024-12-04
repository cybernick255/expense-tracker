//
//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 11/27/24.
//

import SwiftUI

struct AddTransactionView: View
{
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
        
    @State private var title: String = ""
    @State private var amount: String = "" // Use string to allow validation
    @State private var formattedAmount: String = "$0.00"
    @State private var category: String = "Food"
    @State private var date: Date = Date()
    
    let categories = ["Food", "Transport", "Shopping", "Entertainment", "Other"]
    
    var body: some View
    {
        NavigationStack
        {
            Form
            {
                TextField("Title", text: $title)
                TextField("Amount", text: $formattedAmount)
                    .keyboardType(.decimalPad)
                    .onChange(of: formattedAmount)
                    { oldValue, newValue in
                        formatCurrency(input: newValue)
                    }
                                
                Picker("Category", selection: $category)
                {
                    ForEach(categories, id: \.self)
                    {
                        Text($0)
                    }
                }
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add Transaction")
            .toolbar
            {
                ToolbarItem(placement: .topBarLeading)
                {
                    Button("Cancel")
                    {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button("Save")
                    {
                        addTransaction()
                    }
                    .disabled(title.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func formatCurrency(input: String)
    {
        // Remove any non-numeric characters
        let sanitizedInput = input.filter { $0.isNumber }
                
        // Convert to a Double value in cents
        let cents = Double(sanitizedInput) ?? 0.0
                
        // Format the cents as dollars
        let dollars = cents / 100
                
        // Update the formatted amount
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
                
        if let formatted = formatter.string(from: NSNumber(value: dollars))
        {
            formattedAmount = formatted
            if dollars == 0
            {
                amount = ""
            }
            else
            {
                amount = String(dollars)
            }
        }
        else
        {
            formattedAmount = "$0.00"
            amount = ""
        }
    }
    
    func addTransaction()
    {
        if let amount = Double(amount)
        {
            let transaction = Transaction(context: moc)
            transaction.id = UUID()
            transaction.title = title
            transaction.amount = amount
            transaction.category = category
            transaction.date = date
            try? moc.save()
            dataController.fetchTransactions()
            dismiss()
        }
    }
}

#Preview
{
    AddTransactionView()
}
