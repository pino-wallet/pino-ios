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
	private var currentIndex = 0

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
			currentIndex = index
			checkIfFinished(index: index)
			for x in index ..< tutorialVM.tutorials.count {
				if let cell = cellForItem(at: .init(row: x, section: 0)) as? TutorialStepperCell {
					cell.resetProgress()
				}
			}

			for x in 0 ..< index {
				if let cell = cellForItem(at: .init(row: x, section: 0)) as? TutorialStepperCell {
					cell.fillProgress()
				}
			}

			if let cell = cellForItem(at: .init(row: index, section: 0)) as? TutorialStepperCell {
				cell.startProgress { [self] in
					tutorialVM.nextTutorial()
				}
			}

		}.store(in: &cancellables)

		tutorialVM.$isPaused.compactMap { $0 }.sink { [self] isPaused in
			let cell = cellForItem(at: .init(row: currentIndex, section: 0)) as! TutorialStepperCell

			if isPaused {
				cell.pauseProgress()
			} else {
				cell.progressFilling {
					self.tutorialVM.nextTutorial()
				}
			}
		}.store(in: &cancellables)
	}

	private func checkIfFinished(index: Int) {
		if index == tutorialVM.tutorials.count {
			for i in 0 ..< tutorialVM.tutorials.count {
				if let cell = cellForItem(at: .init(row: i, section: 0)) as? TutorialStepperCell {
					cell.pauseProgress()
				}
			}
			tutorialVM.watchedTutorial()
			return
		}
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
		assert(!tutorialVM.tutorials.isEmpty, "Tutorials shouldn't be empty")
		let tutorialsCount = tutorialVM.tutorials.count
		let spacingPixels = ((tutorialsCount - 1) * 12) / tutorialsCount
		return CGSize(width: (Int(collectionView.frame.width) / tutorialsCount) - spacingPixels, height: 3)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		12
	}
}
