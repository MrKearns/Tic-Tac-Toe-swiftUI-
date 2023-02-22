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
                        .onTapGesture {
                            if isOccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(player: .human, boardIndex: i)
                            boardDisabled = true
                            
                            //check for win or draw
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = computerMove(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                boardDisabled = false
                            }
                            
                        }
                    }
                }

                Spacer()
            }
        }
        .disabled(boardDisabled)
        .padding()
    }
    
//    --------------- CHECK IF OCCUPIED FUNC ---------------
    
    func isOccupied(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
//    --------------- COMP MOVE FUNC ---------------
    
    func computerMove(in moves: [Move?]) -> Int{
        var movePosition = Int.random(in: 0..<9)
        
        while isOccupied(in: moves, forIndex: movePosition) {
           movePosition = Int.random(in: 0..<9)
        }
        return movePosition
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





