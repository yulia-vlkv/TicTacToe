//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Iuliia Volkova on 22.09.2021.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    // Поле
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    func processPlayerMove(for posotion: Int) {
        if isSquareOccupied(in: moves, forIndex: posotion) { return }
        moves[posotion] = Move(player: .human, boardIndex: posotion)
        
        // Проверка выигрыша игроком
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWins
            return
        }
        
        if checkForDeaw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        
        // Задержка
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineCompuyerMove(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            
            // Проверка выигрыша компьютером
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWins
                return
            }
            
            if checkForDeaw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    
    }
    
    //
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    // Переменная, чтобы отключить игровое поле для игрока во время хода машины
    @Published var isGameboardDisabled = false
    // 
    @Published var alertItem: AlertItem?
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineCompuyerMove(in moves: [Move?]) -> Int {
        
        // Если можно выиграть - выиграть
        let winPatterns: Set<Set<Int>> = [[0, 1 ,2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter{ $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(computerPositions)
            
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable { return winPosition.first!}
            }
        }
        
        // Если нельзя выиграть - блокировать ход соперника
        let humanMoves = moves.compactMap { $0 }.filter{ $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(humanPositions)
            
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable { return winPosition.first!}
            }
        }
        
        // Если нельзя блокировать ход соперника - занять центральную клетку
        let centralSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centralSquare) { return centralSquare }
        
        // Если нельзя занять центральную клетку - занять рандомную пустую клетку
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    // Проверка выиграл ли один из игроков
    func checkWinCondition( for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1 ,2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    // Проверка на ничью
    func checkForDeaw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame(){
        return moves = Array(repeating: nil, count: 9)
    }
    
}
