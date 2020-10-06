//
//  Block.swift
//  Blockchain
//
//  Created by Antoine on 06/10/2020.
//

import Foundation

class Block {
    var data: String!
    var hash: String!
    var previousHash: String!
    var id: Int!
    
    func generateHash() -> String{
        return UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
