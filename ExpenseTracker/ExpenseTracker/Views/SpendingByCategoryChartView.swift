//
//  SpendingByCategoryChartView.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 11/27/24.
//

import SwiftUI
import Charts

struct SpendingByCategoryChartView: View
{
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController: DataController
    
    @State private var isShowingDetailsSheet: Bool = false
        
    var body: some View
    {
        Chart(dataController.totalSpentByCategory().sorted(by: { $0.value > $1.value }), id: \.key)
        { category, total in
            BarMark(
                x: .value("Category", category),
                y: .value("Total Spent", total)
            )
            .foregroundStyle(by: .value("Category", category))
        }
        .chartXAxisLabel("Category")
        .chartYAxisLabel("Amount Spent")
        .padding()
        .onTapGesture
        {
            isShowingDetailsSheet = true
        }
        .sheet(isPresented: $isShowingDetailsSheet)
        {
            CategoryDetailsView()
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview
{
    SpendingByCategoryChartView()
}
