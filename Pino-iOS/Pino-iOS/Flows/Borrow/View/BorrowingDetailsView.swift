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
	private let titleBetweenView = UIView()
	private let titleArrowImageView = UIImageView()
	private let amountLabel = PinoLabel(style: .title, text: "")
	private var borrowingTokensCollectionView: BorrowingTokensCollectionView!
	private var borrowingDetailsVM: BorrowingDetailsViewModel
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
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let onTappedGesture = UITapGestureRecognizer(target: self, action: #selector(onTappedSelf))
		containerView.addGestureRecognizer(onTappedGesture)

		borrowingTokensCollectionView = BorrowingTokensCollectionView(borrowingDetailsVM: borrowingDetailsVM)

		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(titleBetweenView)
		titleStackView.addArrangedSubview(titleArrowImageView)

		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(amountLabel)
		mainStackView.addArrangedSubview(borrowingTokensCollectionView)
		#warning("we should add assets progress bar collection view here")

		containerView.addSubview(mainStackView)

		addSubview(containerView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 16

		titleStackView.axis = .horizontal
		titleStackView.alignment = .center

		titleLabel.text = borrowingDetailsVM.titleText

		titleArrowImageView.image = UIImage(named: borrowingDetailsVM.titleImage)?.withRenderingMode(.alwaysTemplate)

		amountLabel.font = .PinoStyle.mediumLargeTitle
	}

	private func setupConstraints() {
		amountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 41).isActive = true

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
		}.store(in: &cancellables)
	}

	private func updateAmountLabel(newAmount: String) {
		amountLabel.text = newAmount
	}

	private func updateViewColors(borrowingDetailsProperties: BorrowingPropertiesViewModel) {
		if borrowingDetailsProperties.borrowingAssetsDetailList.isEmpty {
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

	@objc
	private func onTappedSelf() {
		if !borrowingDetailsVM.properties.borrowingAssetsDetailList.isEmpty {
			onTapped()
		}
	}
}
