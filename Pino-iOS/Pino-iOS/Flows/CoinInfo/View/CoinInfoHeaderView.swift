//
//  CoinInfoHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import Kingfisher
import UIKit

class CoinInfoHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var contentView = UIView()
	private var contentStackView = UIStackView()
	private var userCoinInfoStackView = UIStackView()
	private var separatorLineView = UIView()
	private var coinTitleStackView = UIStackView()
	private var coinInfoStackView = UIStackView()
	private var amountLabel = UILabel()
	private var assetsIcon = UIImageView()
	private var assetsTitleLabel = UILabel()
	private var userAmountLabel = UILabel()
	private var volatilityRateStackView = UIStackView()
	private var volatilityRateIcon = UIImageView()
	private var volatilityRateLabel = UILabel()
	private var activitiesTimeTitleLabel = UILabel()
	private var coinInfoStatsView = CoinInfoStatsView()

	// MARK: - public properties

	public static let headerReuseID = "coinInfoHeader"

	public var coinInfoVM: CoinInfoViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}
    
    public var activitiesTimeTitle: String? {
        didSet {
            activitiesTimeTitleLabel.text = activitiesTimeTitle
            activitiesTimeTitleLabel.isHidden = false
        }
    }

	// MARK: - Private Methods

	private func setupView() {
		coinInfoStatsView.coinInfoVM = coinInfoVM

		contentView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(userCoinInfoStackView)
		contentStackView.addArrangedSubview(separatorLineView)
		contentStackView.addArrangedSubview(coinInfoStatsView)
		userCoinInfoStackView.addArrangedSubview(coinInfoStackView)
		volatilityRateStackView.addArrangedSubview(volatilityRateIcon)
		volatilityRateStackView.addArrangedSubview(volatilityRateLabel)
		coinInfoStackView.addArrangedSubview(assetsIcon)
		coinInfoStackView.addArrangedSubview(coinTitleStackView)
		coinTitleStackView.addArrangedSubview(assetsTitleLabel)
		coinTitleStackView.addArrangedSubview(userAmountLabel)

		addSubview(contentView)
		addSubview(activitiesTimeTitleLabel)
	}

	private func setupStyle() {

		contentView.backgroundColor = .Pino.secondaryBackground
		separatorLineView.backgroundColor = .Pino.gray5

		activitiesTimeTitleLabel.textColor = .Pino.label
		amountLabel.textColor = .Pino.secondaryLabel
		userAmountLabel.textColor = .Pino.secondaryLabel
		assetsTitleLabel.textColor = .Pino.label

		assetsIcon.isSkeletonable = true
		assetsTitleLabel.isSkeletonable = true
		userAmountLabel.isSkeletonable = true

		contentView.layer.borderWidth = 1
		contentView.layer.borderColor = UIColor.Pino.white.cgColor
		contentView.isSkeletonBordered = true

		activitiesTimeTitleLabel.font = .PinoStyle.mediumSubheadline
		amountLabel.font = .PinoStyle.mediumSubheadline
		userAmountLabel.font = .PinoStyle.mediumCallout
		volatilityRateLabel.font = .PinoStyle.mediumSubheadline
		assetsTitleLabel.font = .PinoStyle.semiboldTitle2

		contentStackView.axis = .vertical
		userCoinInfoStackView.axis = .vertical
		volatilityRateStackView.axis = .horizontal
		coinInfoStackView.axis = .vertical
		coinTitleStackView.axis = .vertical

		coinInfoStackView.spacing = 14
		contentStackView.spacing = 20
		userCoinInfoStackView.spacing = -18
		coinTitleStackView.spacing = 8
		volatilityRateStackView.spacing = 2

		coinInfoStackView.alignment = .center
		coinTitleStackView.alignment = .center
		volatilityRateStackView.alignment = .top
		volatilityRateIcon.contentMode = .scaleAspectFill

		coinInfoStackView.distribution = .fill
		contentStackView.distribution = .fill

		contentView.layer.cornerRadius = 10

		amountLabel.text = coinInfoVM.coinPortfolio.price
		volatilityRateLabel.text = coinInfoVM.coinPortfolio.volatilityRatePercentage
		assetsTitleLabel.text = coinInfoVM.coinPortfolio.userAmountAndCoinSymbol
        
        activitiesTimeTitleLabel.isHidden = true

		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			userAmountLabel.text = coinInfoVM.coinPortfolio.userAmountInDollar

			assetsIcon.kf.indicatorType = .activity
			assetsIcon.kf.setImage(with: coinInfoVM.coinPortfolio.logo)

		case .unVerified:
			userAmountLabel.text = coinInfoVM.noUserAmountInDollarText

			assetsIcon.image = UIImage(named: coinInfoVM.unverifiedAssetIcon)

		case .position:
			userAmountLabel.text = coinInfoVM.positionAssetTitle

			assetsIcon.kf.indicatorType = .activity
			assetsIcon.kf.setImage(with: coinInfoVM.coinPortfolio.logo)
		}
	}

	private func setupConstraint() {
		contentView.pin(
			.top(padding: 24),
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(
			.verticalEdges(padding: 16),
			.horizontalEdges(padding: 14)
		)
		assetsIcon.pin(
			.fixedHeight(64),
			.fixedWidth(64)
		)
		separatorLineView.pin(
			.fixedHeight(1)
		)
		volatilityRateIcon.pin(
			.fixedWidth(12),
			.fixedHeight(12)
		)
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			activitiesTimeTitleLabel.pin(
				.relative(.top, 16, to: contentView, .bottom),
				.bottom(padding: 8),
				.horizontalEdges(padding: 16)
			)
		case .unVerified:
			activitiesTimeTitleLabel.pin(
				.relative(.top, 24, to: contentView, .bottom),
				.bottom(padding: 8),
				.horizontalEdges(padding: 16)
			)
		case .position:
			activitiesTimeTitleLabel.pin(
				.relative(.top, 0, to: contentView, .bottom),
				.bottom(padding: 0),
				.horizontalEdges(padding: 16),
				.fixedHeight(0)
			)
		}
	}
}
