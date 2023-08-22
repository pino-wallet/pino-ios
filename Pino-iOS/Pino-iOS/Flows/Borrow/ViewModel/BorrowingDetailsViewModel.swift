//
//  CollateralDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Combine

class BorrowingDetailsViewModel {

    // MARK: - Public Properties
    public var borrowVM: BorrowViewModel

    public var titleText: String {
        switch borrowingType {
        case .borrow:
            return borrowVM.borrowTitle
        case .collateral:
            return borrowVM.collateralTitle
        }
    }
    public var titleImage = "primary_right_arrow"

    @Published public var properties: BorrowingPropertiesViewModel!

    public enum BorrowingDetailsType {
        case borrow
        case collateral
    }

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var borrowingType: BorrowingDetailsType
    private var globalAssetsList = GlobalVariables.shared.manageAssetsList

    // MARK: - Initializers
    init(borrowVM: BorrowViewModel, borrowingType: BorrowingDetailsType) {
        self.borrowVM = borrowVM
        self.borrowingType = borrowingType
        updateBorrowingProperties(userBorrowingDetails: borrowVM.userBorrowingDetails)


        setupBindigns()
    }

    // MARK: - Private Methods
    
    private func setupBindigns() {
        borrowVM.$userBorrowingDetails.sink { userBorrowingDetails in
            self.updateBorrowingProperties(userBorrowingDetails: userBorrowingDetails)
        }.store(in: &cancellables)
    }

    private func updateBorrowingProperties(userBorrowingDetails: UserBorrowingModel?) {
        switch borrowingType {
        case .borrow:
            self.properties = BorrowingPropertiesViewModel(borrowingAssetsList: userBorrowingDetails?.borrowTokens ?? [])
        case .collateral:
        self.properties = BorrowingPropertiesViewModel(borrowingAssetsList: userBorrowingDetails?.collateralTokens ?? [])
        }
    }
}
