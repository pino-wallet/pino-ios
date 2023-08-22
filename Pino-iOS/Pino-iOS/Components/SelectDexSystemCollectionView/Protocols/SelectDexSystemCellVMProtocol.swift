//
//  SelectDexCellVMProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//

protocol SelectDexSystemCellVMProtocol {
	var dexModel: DexSystemModelProtocol { get set }
	var name: String { get }
	var image: String { get }
	var description: String { get }
	var type: String { get }
}
