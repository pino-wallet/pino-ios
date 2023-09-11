//
//  BorrowingDetailsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Combine
import UIKit

class BorrowingDetailsView: UIView {
	// MARK: - Closures

	public var onTapped: () -> Void

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .description, text: "")
	private let titleSpacerView = UIView()
	private let titleArrowImageView = UIImageView()
	private let amountStackView = UIStackView()
	private let amountLabel = PinoLabel(style: .title, text: "")
	private let amountSpacerView = UIView()
	private var borrowingTokensCollectionView: BorrowingTokensCollectionView!
	private var borrowingDetailsVM: BorrowingDetailsViewModel
	private var titleLabelHeightConstraint: NSLayoutConstraint!
	private var amountLabelHeightConstraint: NSLayoutConstraint!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(borrowingDetailsVM: BorrowingDetailsViewModel, onTapped: @escaping () -> Void) {
		self.borrowingDetailsVM = borrowingDetailsVM
		self.onTapped = onTapped

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		setupSkeletonViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func showLoading() {
		titleLabelHeightConstraint.isActive = true
		amountLabelHeightConstraint.isActive = true
        titleArrowImageView.isHidden = true
		showSkeletonView()
	}

	public func hideLoading() {
		titleLabelHeightConstraint.isActive = false
		amountLabelHeightConstraint.isActive = false
        titleArrowImageView.isHidden = false
		hideSkeletonView()
	}

	// MARK: - Private Methods

	private func setupView() {
		let onTappedGesture = UITapGestureRecognizer(target: self, action: #selector(onTappedSelf))
		containerView.addGestureRecognizer(onTappedGesture)

		borrowingTokensCollectionView = BorrowingTokensCollectionView(borrowingDetailsVM: borrowingDetailsVM)

		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(titleSpacerView)
		titleStackView.addArrangedSubview(titleArrowImageView)

		amountStackView.addArrangedSubview(amountLabel)
		amountStackView.addArrangedSubview(amountSpacerView)

		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(amountStackView)
		mainStackView.addArrangedSubview(borrowingTokensCollectionView)

		containerView.addSubview(mainStackView)

		addSubview(containerView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 16

		titleStackView.axis = .horizontal
		titleStackView.alignment = .center

		amountStackView.axis = .horizontal
		amountStackView.alignment = .center

		titleArrowImageView.image = UIImage(named: borrowingDetailsVM.titleImage)?.withRenderingMode(.alwaysTemplate)

		amountLabel.font = .PinoStyle.mediumLargeTitle
	}

	private func setupConstraints() {
		titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 14)

		amountLabelHeightConstraint = amountLabel.heightAnchor.constraint(equalToConstant: 30)

		titleStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		amountStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 41).isActive = true

		amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 171).isActive = true

		titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true

		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 24))
		borrowingTokensCollectionView.pin(.fixedHeight(32))
	}

	private func setupBindings() {
		borrowingDetailsVM.$properties.sink { borrowingDetailsProperties in
			guard let newBorrowingDetailsProperties = borrowingDetailsProperties else {
				return
			}
			self.updateAmountLabel(newAmount: newBorrowingDetailsProperties.borrowingAmount)
			self.updateViewColors(borrowingDetailsProperties: newBorrowingDetailsProperties)
			self.updateView(borrowingDetailsProperties: newBorrowingDetailsProperties)
		}.store(in: &cancellables)
	}

	private func updateAmountLabel(newAmount: String) {
		amountLabel.text = newAmount
	}

	private func updateViewColors(borrowingDetailsProperties: BorrowingPropertiesViewModel) {
		guard let newBorrowingDetailsPropertiesAssetList = borrowingDetailsProperties.borrowingAssetsDetailList else {
			return
		}
		if newBorrowingDetailsPropertiesAssetList.isEmpty {
			amountLabel.textColor = .Pino.gray3
			titleArrowImageView.tintColor = .Pino.gray3
			titleLabel.textColor = .Pino.gray3
			borrowingTokensCollectionView.isHidden = true
		} else {
			amountLabel.textColor = .Pino.label
			titleArrowImageView.tintColor = .Pino.primary
			titleLabel.textColor = .Pino.secondaryLabel
			borrowingTokensCollectionView.isHidden = false
		}
	}

	private func updateView(borrowingDetailsProperties: BorrowingPropertiesViewModel) {
		guard borrowingDetailsProperties.borrowingAssetsDetailList != nil else {
			titleArrowImageView.alpha = 0
			return
		}
		titleArrowImageView.alpha = 1
		titleLabel.text = borrowingDetailsVM.titleText
	}

	private func setupSkeletonViews() {
		titleLabel.isSkeletonable = true
		amountLabel.isSkeletonable = true
	}

	@objc
	private func onTappedSelf() {
		guard let newBorrowingDetailsPropertiesAssetList = borrowingDetailsVM.properties.borrowingAssetsDetailList
		else {
			return
		}
		if !newBorrowingDetailsPropertiesAssetList.isEmpty {
			onTapped()
		}
	}
}
