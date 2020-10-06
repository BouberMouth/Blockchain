//
//  BlockChain.swift
//  Blockchain
//
//  Created by Antoine on 06/10/2020.
//

import Foundation

class BlockChain {
    var chain = [Block]()
    
    func createInitialBlock(data: String) {
        let initialBlock = Block()
        initialBlock.data = data
        initialBlock.id = 0
        initialBlock.hash = initialBlock.generateHash()
        initialBlock.previousHash = "0000"
        chain = [initialBlock]
    }
    
    func createBlock(data: String) {
        let newBlock = Block()
        newBlock.data = data
        newBlock.id = chain.count
        newBlock.hash = newBlock.generateHash()
        newBlock.previousHash = chain[chain.count - 1].hash
        chain.append(newBlock)
    }
}
