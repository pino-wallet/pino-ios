//
//  CustomSwitchCollectionCellVM.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/3/23.
//

protocol CustomSwitchCollectionCellVM {
	var title: String { get }
	var isSelected: Bool { get }
	var tooltipText: String! { get }
	var type: String { get }
}
