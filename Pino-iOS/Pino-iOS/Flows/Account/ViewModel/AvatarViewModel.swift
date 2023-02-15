//
//  AvatarViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/15/23.
//

struct AvatarViewModel {
	public var selectedAvatar: String
	public var avatarsList: [String]!

	init(selectedAvatar: String) {
		self.selectedAvatar = selectedAvatar
		setAvatarList()
	}

	private mutating func setAvatarList() {
		avatarsList = [
			"grapes",
			"tangerine",
			"coconut",
			"green_apple",
			"lemon", "pear",
			"cherries",
			"garlic",
			"blueberries",
			"tomato",
			"kiwi",
			"olive",
			"broccoli",
			"onion",
			"watermelon",
			"mango",
			"carrot",
			"avocado",
			"peach",
			"strawberry",
			"chilli_pepper",
			"ear_of_corn",
			"leafy_greens",
			"pineapple",
		]
	}
}
