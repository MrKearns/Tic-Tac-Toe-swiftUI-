//
//  ContentView.swift
//  Tic-Tac-Toe(swiftUI)
//
//  Created by Jonathan Kearns on 2/10/23.
//

import SwiftUI



struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var boardDisabled = false
    @State private var playerOneTurn = true
    @State private var alertItem: AlertItem?
    
    // MARK:  ---------- VIEW BODY ----------
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 15){
                    ForEach(0..<9) { i in
                        ZStack{
                            Rectangle()
                                .foregroundColor(.blue)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 60, height: 60)
                                
                              
                        }
                        // ---------- TAP GESTURE --------
                        .onTapGesture {
                            if isOccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(player: .human, boardIndex: i)
                            
                            
                            //check for win or draw
                            if checkWinConditions(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            boardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = computerMove(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                boardDisabled = false
                                
                                if checkWinConditions(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                            
                        }
                    }
                }

                Spacer()
            }
        }
        .disabled(boardDisabled)
        .padding()
        .alert(item: $alertItem, content: {alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                resetGame() }))
        })
    }
    
    
//    --------------- CHECK IF SQUARE IS OCCUPIED FUNC ---------------
    
    func isOccupied(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    
//    --------------- COMP MOVE FUNC ---------------------
    
    func computerMove(in moves: [Move?]) -> Int{
        
        // If Computer can win, take winning space
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6],]
        
        // Compact Map Removes Nils -- Filter filters out other comp's moves
        let computerMoves = moves.compactMap {$0}.filter{$0.player == .computer}
        
        // Go through computerMoves get boardIndexes where all markers are for .player ex: [1, 2, 3]
        let computerPositions = Set(computerMoves.map{$0.boardIndex})
        
        // Subtracting moves from winPatters to check if only 1 move left
        for pattern in winPatterns{
            let winPositinos = pattern.subtracting(computerPositions)
            
            // if only one move left to win, take that space
            if winPositinos.count == 1 {
                let isAvailable = !isOccupied(in: moves, forIndex: winPositinos.first!)
                if isAvailable {return winPositinos.first!}
            }
        }
        
        // -- Computer block player if 1 move left to win --
        
        
        // Compact Map Removes Nils -- Filter filters out other human's moves
        let humanMoves = moves.compactMap {$0}.filter{$0.player == .human}
        
        // Go through computerMoves get boardIndexes where all markers are for .player ex: [1, 2, 3]
        let humanPositions = Set(humanMoves.map{$0.boardIndex})
        
        // Subtracting moves from winPatters to check if only 1 move left
        for pattern in winPatterns{
            let winPositinos = pattern.subtracting(humanPositions)
            
            // if only one move left for HUMAN to win, comp take that space
            if winPositinos.count == 1 {
                let isAvailable = !isOccupied(in: moves, forIndex: winPositinos.first!)
                if isAvailable {return winPositinos.first!}
            }
        }
        
        var movePosition = Int.random(in: 0..<9)
        
        while isOccupied(in: moves, forIndex: movePosition) {
           movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    
//   --------------- WIN CONDITIONS FUNCTION  -------------
    
    func checkWinConditions(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6],]
        
        // Compact Map Removes Nils -- Filter filters out other player's moves
        let playerMoves = moves.compactMap {$0}.filter{$0.player == player}
        
        // Go through playerMoves get boardIndexes where all markers are for .player ex: [1, 2, 3]
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        // Check if player position patterns match any of winPatters sets
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true}
        
        
        return false
    }
    
    
    // --------------- CHECK FOR DRAW FUNC ----------
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        // if moves = 9 and no win, then draw
        return moves.compactMap {$0}.count == 9
    }
    
    
    // --------------- RESET GAME FUNC ---------------
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
    
}


enum Player{
    case human
    case computer
}

struct Move{
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





