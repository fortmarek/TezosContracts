// Generated using TezosGen 
// swiftlint:disable file_length

import Foundation
import TezosSwift

/// Struct for function currying
struct HelloContractBox {
    fileprivate let tezosClient: TezosClient 
    fileprivate let at: String

    fileprivate init(tezosClient: TezosClient, at: String) {
       self.tezosClient = tezosClient 
       self.at = at 
    }

    /**
     Call HelloContract with specified params.
     **Important:**
     Params are in the order of how they are specified in the Tezos structure tree
    */
    func call(param1: [UInt]) -> ContractMethodInvocation {
        let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Void
        let input: [UInt] = param1.sorted()
        send = { from, amount, operationFees, completion in
            self.tezosClient.send(amount: amount, to: self.at, from: from, input: input, operationFees: operationFees, completion: completion)
        }

        return ContractMethodInvocation(send: send)
    }

    /// Call this method to obtain contract status data
	func status(completion: @escaping RPCCompletion<HelloContractStatus>) {
        let endpoint = "/chains/main/blocks/head/context/contracts/" + at
        tezosClient.sendRPC(endpoint: endpoint, method: .get, completion: completion)
    }
}

/// Status data of HelloContract
struct HelloContractStatus: Decodable {
    /// Balance of HelloContract in Tezos
    let balance: Tez
    /// Is contract spendable
    let spendable: Bool
    /// HelloContract's manager address
    let manager: String
    /// HelloContract's delegate
    let delegate: StatusDelegate
    /// HelloContract's current operation counter 
    let counter: Int
    /// HelloContract's storage
    let storage: [UInt]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContractStatusKeys.self)
        self.balance = try container.decode(Tez.self, forKey: .balance)
        self.spendable = try container.decode(Bool.self, forKey: .spendable)
        self.manager = try container.decode(String.self, forKey: .manager)
        self.delegate = try container.decode(StatusDelegate.self, forKey: .delegate)
        self.counter = try container.decodeRPC(Int.self, forKey: .counter)

        let scriptContainer = try container.nestedContainer(keyedBy: ContractStatusKeys.self, forKey: .script)
        self.storage = try scriptContainer.decodeRPC([UInt].self, forKey: .storage)
    }
}

extension TezosClient {
    /**
     This function returns type that you can then use to call HelloContract specified by address.

     - Parameter at: String description of desired address.

     - Returns: Callable type to send Tezos with.
    */
    func helloContract(at: String) -> HelloContractBox {
        return HelloContractBox(tezosClient: self, at: at)
    }
}
