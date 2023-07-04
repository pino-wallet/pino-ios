//
//  SwapTokenSectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation
import UIKit

class SwapTokenSectionView: UIView {
	// MARK: - Initializers

	init(
		swapVM: SwapTokenViewModel,
		hasMaxAmount: Bool = true,
		changeSelectedToken: @escaping () -> Void,
		balanceStatusDidChange: ((AmountStatus) -> Void)? = nil
	) {
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}
