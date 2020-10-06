//
//  ContentView.swift
//  Blockchain
//
//  Created by Antoine on 06/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    let account1 = "1010"
    let account2 = "1011"
    let bitcoinChain = BlockChain()
    let reward = 100
    @State var accounts: [String: Int] = ["0000": 1000000]
    
    @State var textfield1 = ""
    @State var textfield2 = ""
    @State var showAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                HStack {
                    Text("Account 1")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                    Spacer()
                }
                
                HStack {
                    Text("Account: \(account1)")
                    Spacer()
                    Text("Balance: \(accounts["1010"] ?? 0) BTC")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
                
                TextField("Coins to send", text: $textfield1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color.red)
                            .frame(width: 70)
                        Button("Mine") {
                            mine(with: "1010")
                        }
                        .foregroundColor(.white)
                    }
                    
                    ZStack {
                        Circle().fill(Color.red)
                            .frame(width: 70)
                        Button("Send") {
                            if let amount = Int(textfield1) {
                                send(from: "1010", to: "1011", amount: amount)
                                textfield1 = ""
                            } else {
                                alertMessage = "Wrong amount"
                                showAlert.toggle()
                            }
                            
                        }
                        .foregroundColor(.white)
                    }
                }
                .frame(height: 70)
                
            }
            .padding(.horizontal, 50)
            .offset(y: -200)
            
            VStack(alignment: .center) {
                HStack {
                    Text("Account 2")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                    Spacer()
                }
                
                HStack {
                    Text("Account: \(account2)")
                    Spacer()
                    Text("Balance: \(accounts["1011"] ?? 0) BTC")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
                
                TextField("Coins to send", text: $textfield1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color.green)
                            .frame(width: 70)
                        Button("Mine") {
                            mine(with: "1011")
                        }
                        .foregroundColor(.white)
                    }
                    
                    ZStack {
                        Circle().fill(Color.green)
                            .frame(width: 70)
                        Button("Send") {
                            if let amount = Int(textfield2) {
                                send(from: "1011", to: "1010", amount: amount)
                                textfield2 = ""
                            } else {
                                alertMessage = "Wrong amount"
                                showAlert.toggle()
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .frame(height: 70)
                
            }
            .padding(.horizontal, 50)
            .offset(y: 200)
        }.onAppear {
            transaction(from: "0000", to: "1010", amount: 50, type: "genesis")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage))
        }
        
    }
    
    func transaction(from sender: String, to receiver: String, amount: Int, type: String) {
        if accounts[sender] == nil {
            alertMessage = ""
            showAlert.toggle()
        } else if accounts[sender]! - amount < 0 {
            alertMessage = ""
            showAlert.toggle()
        } else {
            accounts.updateValue(accounts[sender]! - amount, forKey: sender)
        }
        
        if accounts[receiver] == nil {
            accounts.updateValue(amount, forKey: receiver)
        } else {
            accounts.updateValue(accounts[receiver]! + amount, forKey: receiver)
        }
        
        if type == "genesis" {
            bitcoinChain.createInitialBlock(data: "FROM: \(sender), TO: \(receiver), AMOUNT: \(amount) BTC")
        } else if type == "normal" {
            bitcoinChain.createBlock(data: "FROM: \(sender), TO: \(receiver), AMOUNT: \(amount) BTC")
        }
    }
    
    func chainState() {
        for i in 0..<bitcoinChain.chain.count {
            print("\tBlock: \(bitcoinChain.chain[i].id!)\n\tHash: \(bitcoinChain.chain[i].hash!)\n\tPrevious Hash: \(bitcoinChain.chain[i].previousHash!)\n\tData: \(bitcoinChain.chain[i].data!)")
        }
        print(accounts)
        print("Chain is \(chainValidity() ? "" : "not ") valid.")
    }
    
    func chainValidity() -> Bool {
        for i in 1..<bitcoinChain.chain.count {
            if bitcoinChain.chain[i].previousHash != bitcoinChain.chain[i-1].hash {
                return false
            }
        }
        return true
    }
    
    func mine(with account: String) {
        transaction(from: "0000", to: account, amount: reward, type: "normal")
        print("New block mined by \(account).")
        chainState()
    }
    
    func send(from sender: String, to receiver: String, amount: Int) {
        transaction(from: sender, to: receiver, amount: amount, type: "normal")
        print("\(amount) BTC sent from \(sender) to \(receiver).")
        chainState()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
