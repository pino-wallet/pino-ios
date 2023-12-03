//
//  TutorialStepperView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Combine
import UIKit

class TutorialStepperContainerView: UICollectionView {
	// MARK: - Private Properties

	private let tutorialVM: TutorialContainerViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var currentInex = 0

	private func configureCollectionView() {
		delegate = self
		dataSource = self

		register(TutorialStepperCell.self, forCellWithReuseIdentifier: TutorialStepperCell.cellReuseID)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.setupBindings()
		}
	}

	// MARK: - Initializers

	init(tutorialVM: TutorialContainerViewModel) {
		self.tutorialVM = tutorialVM

		let collectionViewFlowLayout = UICollectionViewFlowLayout(scrollDirection: .horizontal)
		super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)

		configureCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	public func setupBindings() {
		tutorialVM.$currentIndex.sink { [self] index in
			currentInex = index
			for x in index ..< tutorialVM.tutorials.count {
				if let cell = cellForItem(at: .init(row: x, section: 0)) as? TutorialStepperCell {
					cell.tutStepperCellVM.resetProgress()
				}
			}
			for x in 0 ..< index {
				if let cell = cellForItem(at: .init(row: x, section: 0)) as? TutorialStepperCell {
					cell.tutStepperCellVM.fillProgress()
				}
			}

			if let cell = cellForItem(at: .init(row: index, section: 0)) as? TutorialStepperCell {
				cell.startProgressFrom { [self] in
					tutorialVM.nextTutorial()
				}
			}

		}.store(in: &cancellables)

		tutorialVM.$isPaused.compactMap { $0 }.sink { [self] isPaused in
			let cell = cellForItem(at: .init(row: currentInex, section: 0)) as! TutorialStepperCell

			if isPaused {
				cell.tutStepperCellVM.pauseProgress()
			} else {
				cell.progressFilling {
					self.tutorialVM.nextTutorial()
				}
			}
		}.store(in: &cancellables)
	}
}

// MARK: - CollectionView Delegate

extension TutorialStepperContainerView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		tutorialVM.tutorials.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: TutorialStepperCell.cellReuseID,
			for: indexPath
		) as! TutorialStepperCell
		cell.tutStepperCellVM = TutorialStepViewModel()
		cell.configCell()
		return cell
	}
}

// MARK: - CollectionView DataSource

extension TutorialStepperContainerView: UICollectionViewDelegate {}

extension TutorialStepperContainerView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: Int(collectionView.frame.width) / tutorialVM.tutorials.count, height: 3)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		8
	}
}
