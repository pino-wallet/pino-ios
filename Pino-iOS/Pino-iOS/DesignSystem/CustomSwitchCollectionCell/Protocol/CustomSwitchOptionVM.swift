//
//  CustomSwitchCollectionCellVM.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/3/23.
//

protocol CustomSwitchOptionVM {
	var title: String { get }
	var description: String? { get }
	var isSelected: Bool { get }
	var type: String { get }
}
