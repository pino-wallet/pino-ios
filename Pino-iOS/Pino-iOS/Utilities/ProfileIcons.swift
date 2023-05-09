//
//  ProfileIcons.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/28/23.
//

enum Avatar: String, CaseIterable {
	case grapes
	case tangerine
	case coconut
	case green_apple
	case lemon
	case pear
	case cherries
	case garlic
	case blueberries
	case tomato
	case kiwi
	case olive
	case broccoli
	case onion
	case watermelon
	case mango
	case carrot
	case avocado
	case peach
	case strawberry
	case chilli_pepper
	case ear_of_corn
	case leafy_greens
	case pineapple

	public var name: String {
		switch self {
		case .grapes:
			return "Grapes"
		case .tangerine:
			return "Tangerine"
		case .coconut:
			return "Coconut"
		case .green_apple:
			return "Apple"
		case .lemon:
			return "Lemon"
		case .pear:
			return "Pear"
		case .cherries:
			return "Cherries"
		case .garlic:
			return "Garlic"
		case .blueberries:
			return "Blueberries"
		case .tomato:
			return "Tomato"
		case .kiwi:
			return "Kiwi"
		case .olive:
			return "Olive"
		case .broccoli:
			return "Broccoli"
		case .onion:
			return "Onion"
		case .watermelon:
			return "Watermelon"
		case .mango:
			return "Mango"
		case .carrot:
			return "Carrot"
		case .avocado:
			return "Avocado"
		case .peach:
			return "Peach"
		case .strawberry:
			return "Strewberry"
		case .chilli_pepper:
			return "Chilli pepper"
		case .ear_of_corn:
			return "Corn"
		case .leafy_greens:
			return "Lettuce"
		case .pineapple:
			return "Pineapple"
		}
	}
}
