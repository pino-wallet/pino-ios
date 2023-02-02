//
//  CoinInfoView.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/5/23.
//

import Combine
import UIKit

class CoinInfoHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var contentStackView = UIStackView()
	public var contentView = UIView()
	private var topStackView = UIStackView()
	private var lineView = UIView()
	private var bottonStackView = UIStackView()

	private var coinStackView = UIStackView()
	private var coinInfoView = UIView()
	private var amountStackView = UIStackView()
	private var amountLabel = UILabel()
	private var assetsIcon = UIImageView()
	private var assetsTitleLabel = UILabel()
	private var userAmountLabel = UILabel()
	private var changingRateStackView = UIStackView()
	private var changingRateIcon = UIImageView()
	private var changingRateLabel = UILabel()

	private var investStackView = UIStackView()
	private var investInfoStackView = UIStackView()
	private var investTitleLabel = UILabel()
	private var investInfoButtton = UIButton()
	private var investLabel = UILabel()

	private var collateralStackView = UIStackView()
	private var collateralInfoStackView = UIStackView()
	private var collateralTitleLabel = UILabel()
	private var collateralInfoButton = UIButton()
	private var collateralLabel = UILabel()

	private var borrowStackView = UIStackView()
	private var borrowInfoStackView = UIStackView()
	private var borrowTitleLabel = UILabel()
	private var borrowInfoButton = UIButton()
	private var borrowLabel = UILabel()

	private var cancellables = Set<AnyCancellable>()

	// MARK: - public properties

	public static let headerReuseID = "coinInfoHeader"

	public var coinInfoVM: CoinInfoPageViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupBinding()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .Pino.background
		contentView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(topStackView)
		contentStackView.addArrangedSubview(lineView)
		contentStackView.addArrangedSubview(bottonStackView)
		topStackView.addArrangedSubview(amountStackView)
		amountStackView.addArrangedSubview(amountLabel)
		amountStackView.addArrangedSubview(changingRateStackView)
		changingRateStackView.addArrangedSubview(changingRateIcon)
		changingRateStackView.addArrangedSubview(changingRateLabel)
		topStackView.addArrangedSubview(coinStackView)
		coinStackView.addArrangedSubview(assetsIcon)
		coinStackView.addArrangedSubview(assetsTitleLabel)
		coinStackView.addArrangedSubview(userAmountLabel)

		bottonStackView.addArrangedSubview(investStackView)
		bottonStackView.addArrangedSubview(collateralStackView)
		bottonStackView.addArrangedSubview(borrowStackView)

		investStackView.addArrangedSubview(investInfoStackView)
		investStackView.addArrangedSubview(investLabel)

		investInfoStackView.addArrangedSubview(investTitleLabel)
		investInfoStackView.addArrangedSubview(investInfoButtton)

		collateralStackView.addArrangedSubview(collateralInfoStackView)
		collateralStackView.addArrangedSubview(collateralLabel)

		collateralInfoStackView.addArrangedSubview(collateralTitleLabel)
		collateralInfoStackView.addArrangedSubview(collateralInfoButton)

		borrowStackView.addArrangedSubview(borrowInfoStackView)
		borrowStackView.addArrangedSubview(borrowLabel)

		borrowInfoStackView.addArrangedSubview(borrowTitleLabel)
		borrowInfoStackView.addArrangedSubview(borrowInfoButton)

		addSubview(contentView)
	}

	private func setupStyle() {
		contentView.layer.cornerRadius = 10
		contentView.backgroundColor = .white

		lineView.backgroundColor = .Pino.gray5

		contentStackView.axis = .vertical
		topStackView.axis = .vertical
		amountStackView.axis = .horizontal
		changingRateStackView.axis = .horizontal

		coinStackView.axis = .vertical
		coinStackView.spacing = 13
		coinStackView.alignment = .center
		coinStackView.distribution = .fill

		assetsTitleLabel.font = .PinoStyle.semiboldTitle2

		contentStackView.distribution = .fill
		contentStackView.spacing = 30

		topStackView.spacing = -20

		bottonStackView.axis = .vertical
		bottonStackView.distribution = .fillEqually
		bottonStackView.spacing = 25

		[investStackView, collateralStackView, borrowStackView].forEach {
			$0.axis = .horizontal
			$0.spacing = 8
			$0.distribution = .equalCentering
		}

		[investInfoButtton, borrowInfoButton, collateralInfoButton].forEach {
			$0.setImage(UIImage(named: "Info-Circle, error"), for: .normal)
			$0.tintColor = .Pino.gray3
		}

		[investInfoStackView, collateralInfoStackView, borrowInfoStackView].forEach {
			$0.spacing = 5
			$0.alignment = .center
		}

		investInfoStackView.axis = .horizontal
		collateralInfoStackView.axis = .horizontal
		borrowInfoStackView.axis = .horizontal

		investTitleLabel.text = "Invest"
		collateralTitleLabel.text = "Collateral"
		borrowTitleLabel.text = "Borrow"

		[investTitleLabel, collateralTitleLabel, borrowTitleLabel].forEach {
			$0.font = .PinoStyle.mediumBody
			$0.textColor = .Pino.secondaryLabel
		}

		[investLabel, collateralLabel, borrowLabel].forEach {
			$0.font = .PinoStyle.mediumBody
		}
	}

	private func setupBinding() {
		coinInfoVM.$coinInfo.sink { [weak self] coininfo in
			guard let coininfo = coininfo else { return }
			self?.amountLabel.text = coininfo.coinAmount
			self?.assetsIcon.image = UIImage(named: coininfo.assetImage)
			self?.assetsTitleLabel.text = coininfo.name
			self?.userAmountLabel.text = coininfo.userAmount
			self?.changingRateLabel.text = coininfo.changingRate
			self?.investLabel.text = coininfo.investAmount
			self?.collateralLabel.text = coininfo.callateralAmount
			self?.borrowLabel.text = coininfo.borrowAmount
			self?.investTitleLabel.text = "Invest"
			self?.collateralTitleLabel.text = "Collateral"
			self?.borrowTitleLabel.text = "Borrow"

		}.store(in: &cancellables)
	}

	private func setupConstraint() {
		contentView.pin(.top(padding: 32), .leading(padding: 16), .trailing(padding: 16), .bottom(padding: 0))

		contentStackView.pin(.verticalEdges(padding: 16), .horizontalEdges(padding: 14))

		assetsIcon.pin(.fixedHeight(70), .fixedWidth(70))
		lineView.pin(.leading(padding: 8), .trailing(padding: 8), .fixedHeight(1))

		[investInfoButtton, collateralInfoButton, borrowInfoButton].forEach {
			$0.pin(.fixedHeight(20), .fixedWidth(20))
		}
	}
}
