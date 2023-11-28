//
//  TutorialStepperCell.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import UIKit
import Combine

class TutorialStepperCell: UICollectionViewCell {
	
    // MARK: Private Properties

	private let stepProgressView = UIProgressView()
    private var cancellables = Set<AnyCancellable>()
    
    var timer: Timer?
    let duration = 8.0 // Duration in seconds
    let timeInterval = 0.1 // Time interval for the timer
    
	// MARK: Public Properties

	public static let cellReuseID = "tutStepperCell"
	public var tutStepperCellVM: TutorialStepViewModel!
    
	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(stepProgressView)
	}
    
    private func setupBinding() {
        tutStepperCellVM.progressValue.sink { progValue in
            self.stepProgressView.setProgress(progValue.value, animated: progValue.animated)
        }.store(in: &cancellables)
    }

	private func setupStyle() {
		stepProgressView.progressViewStyle = .bar
		stepProgressView.trackTintColor = UIColor.Pino.white
		stepProgressView.progressTintColor = UIColor.Pino.primary
		stepProgressView.layer.cornerRadius = 2
        stepProgressView.setProgress(tutStepperCellVM.progressValue.value.value, animated: tutStepperCellVM.progressValue.value.animated)
	}

	private func setupConstraint() {
		stepProgressView.pin(
			.centerX,
			.centerY,
			.horizontalEdges(padding: 0),
			.top(padding: 0),
			.bottom(padding: 0),
			.fixedHeight(2)
		)
	}

	// MARK: Public Methods

    public func configCell() {
        setupView()
        setupStyle()
        setupConstraint()
        setupBinding()
    }
    
    public func startProgressFrom(value: Int, completed:@escaping ()->Void) {
        tutStepperCellVM.isPause = false
        for x in value ... 100000 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                if tutStepperCellVM.isPause {
                    return
                } else {
                    tutStepperCellVM.setProgress(value: Float(x), animated: true)
                    if x == 100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            completed()
                        }
                    }
                }
            }
            
        }
	}
    
    func startProgress() {
        stepProgressView.progress = 0
        var elapsedTime = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            
            elapsedTime += strongSelf.timeInterval
            let progress = Float(elapsedTime / strongSelf.duration)
            
            // Update the progress view
            strongSelf.stepProgressView.setProgress(progress, animated: true)
            
            // Check if the progress is complete
            if elapsedTime >= strongSelf.duration {
                timer.invalidate()
                print("Progress complete")
            }
        }
    }

	public func pauseProgress() {
        tutStepperCellVM.isPause = true
	}
    
    public func resetProgress() {
        tutStepperCellVM.isPause = true
        tutStepperCellVM.setProgress(value: Float(0), animated: false)
    }
}
