//
//  RecentAddressViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

struct RecentAddressViewModel {
	// MARK: - Private Properties

	private var recentAddressModel: RecentAddressModel

	// MARK: - Public Properties

	public var shortEndAddress: String {
		recentAddressModel.address.addressFormating()
	}

	public var logoText: String {
		recentAddressModel.address[0 ..< 2]
	}

	// MARK: - Initializers

	init(recentAddressModel: RecentAddressModel) {
		self.recentAddressModel = recentAddressModel
	}
}
