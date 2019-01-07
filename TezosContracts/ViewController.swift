//
//  ViewController.swift
//  TezosContracts
//
//  Created by Marek Fořt on 12/17/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit
import TezosSwift 

class ViewController: UIViewController {

    let tezosClient = TezosClient(remoteNodeURL: URL(string: "https://rpcalpha.tzbeta.net/")!)

    override func viewDidLoad() {
        super.viewDidLoad()

        tezosClient.balance(of: "KT1DwASQY1uTEkzWUShbeQJfKpBdb2ugsE5k", completion: { result in
            switch result {
            case .success(let balance):
                print(balance.humanReadableRepresentation)
            case .failure(let error):
                print("Getting balance failed with error: \(error)")
            }
        })

        let mnemonic = "soccer click number muscle police corn couch bitter gorilla camp camera shove expire pill praise"
        let wallet = Wallet(mnemonic: mnemonic)!

        tezosClient.send(amount: Tez(1), to: "tz1WRFiK6eGNvP3ioWkWeP6JwDaQjj95opnQ", from: wallet, completion: { result in
            switch result {
            case .success(let transactionHash):
                print(transactionHash)
            case .failure(let error):
                print("Sending Tezos failed with error: \(error)")
            }
        })
    }


}

