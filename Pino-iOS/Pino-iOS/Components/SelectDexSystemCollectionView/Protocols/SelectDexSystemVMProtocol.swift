//
//  SelectDexVMProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//

protocol SelectDexSystemVMProtocol {
	associatedtype dexModelType: DexSystemModelProtocol
	var dexSystemList: [dexModelType] { get }
}
