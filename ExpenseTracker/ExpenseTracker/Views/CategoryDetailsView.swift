//
//  CategoryDetailsView.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 12/3/24.
//

import SwiftUI

struct CategoryDetailsView: View
{
    @EnvironmentObject var dataController: DataController
    
    var body: some View
    {
        List
        {
            ForEach(dataController.totalSpentByCategory().sorted(by: { $0.value > $1.value }), id: \.key)
            { category, total in
                Text("\(category): $\(String(format: "%.2f", total))")
            }
        }
    }
}

#Preview
{
    CategoryDetailsView()
}
