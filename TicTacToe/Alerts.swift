//
//  Alerts.swift
//  TicTacToe
//
//  Created by Iuliia Volkova on 19.09.2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWins       = AlertItem(title: Text("You Win!"),
                                    message: Text("You beat your phone. Congrats!"),
                                    buttonTitle: Text("Hell yeah!"))
    
    static let computerWins    = AlertItem(title: Text("You lost :("),
                                    message: Text("Your phone is smarter than you."),
                                    buttonTitle: Text("Rematch"))
    
    static let draw            = AlertItem(title: Text("Draw"),
                                    message: Text("What a battle of wits we have here..."),
                                    buttonTitle: Text("Try Again"))
    
}
