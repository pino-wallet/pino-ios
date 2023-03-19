//
//  CreateImportWalletCollectionViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class CreateImportWalletCollectionViewController: UICollectionViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Register cell classes
		collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

		// Do any additional setup after loading the view.
	}

	// MARK: UICollectionViewDataSource

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		0
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of items
		0
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

		// Configure the cell

		return cell
	}
}
