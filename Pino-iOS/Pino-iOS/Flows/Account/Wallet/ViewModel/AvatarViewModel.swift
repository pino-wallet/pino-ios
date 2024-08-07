//
//  AvatarViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/15/23.
//

struct AvatarViewModel {
	// MARK: - Public Properties

	public var selectedAvatar: String
	public var avatarsList = Avatar.allCases

	// MARK: - Initializers

	init(selectedAvatar: String) {
		self.selectedAvatar = selectedAvatar
	}
}
