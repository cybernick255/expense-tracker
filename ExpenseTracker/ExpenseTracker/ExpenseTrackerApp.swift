//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Nicolas Deleasa on 11/27/24.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App
{
    @StateObject var dataController = DataController()
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environment(\.colorScheme, .dark)
        }
    }
}
