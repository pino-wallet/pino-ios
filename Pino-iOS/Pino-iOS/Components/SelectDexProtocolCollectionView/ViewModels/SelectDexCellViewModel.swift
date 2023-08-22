//
//  SelectDexViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//

struct SelectDexCellViewModel: SelectDexProtocolCellVMProtocol {
	// MARK: - Public Properties

	public var dexModel: DexProtocolModelProtocol

	public var name: String {
		dexModel.name
	}

	public var image: String {
		dexModel.image
	}

	public var description: String {
		dexModel.description
	}

	public var type: String {
		dexModel.type
	}
}
