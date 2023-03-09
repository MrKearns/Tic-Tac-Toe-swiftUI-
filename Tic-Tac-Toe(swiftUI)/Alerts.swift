//
//  Alerts.swift
//  Tic-Tac-Toe(swiftUI)
//
//  Created by Jonathan Kearns on 3/9/23.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), message: Text("You did it. You Beat the Computer."), buttonTitle: Text("Again?"))
    
    static let computerWin = AlertItem(title: Text("Computer Wins!"), message: Text("The Computer bested you today."), buttonTitle: Text("Again?"))
    
    static let draw = AlertItem(title: Text("Meow - Cat's Game"), message: Text("It's a draw."), buttonTitle: Text("Again?"))
    
    
}


