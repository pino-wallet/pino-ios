//
//  SwapProtocolModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import Foundation

struct dexProtocolModel: DexProtocolModelProtocol, Equatable {
	// MARK: - Public Properties
	public var name: String
	public var image: String
	public var description: String
    public var type: String
    
    // MARK: - Initializers
   private init(name: String, image: String, description: String, type: String) {
        self.name = name
        self.image = image
        self.description = description
        self.type = type
    }
}

extension dexProtocolModel {
    public static var bestRate = dexProtocolModel(
        name: "Best rate",
        image: "best_rate_protocol",
        description: "Find the best rate",
        type: "best_rate"
    )
    public static var uniswap = dexProtocolModel(
        name: "Uniswap",
        image: "uniswap_protocol",
        description: "uniswap.org",
        type: "uniswap"
    )
     public static var curve = dexProtocolModel(
       name: "Curve",
       image: "curve_protocol",
       description: "curve.fi",
       type: "curve"
       )
    public static var balancer = dexProtocolModel(
         name: "Balancer",
         image: "balancer_protocol",
         description: "balancer.fi",
         type: "balancer"
     )
    public static var aave = dexProtocolModel(
      name: "Aave",
      image: "aave",
      description: "aave.com",
      type: "aave"
      )
   public static var compound = dexProtocolModel(
        name: "Compound",
        image: "compound",
        description: "compound.finance",
        type: "compound"
    )
}
