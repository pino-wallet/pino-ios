//
//  HealthScoreSystemViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/9/23.
//
import UIKit
import BigInt

class HealthScoreSystemViewController: UIAlertController {
	// MARK: - Private Properties

	private var healthScoreSystemInfoVM: HealthScoreSystemViewModel!

	private let containerView = UIView()
	private let mainStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let describtionLabel = PinoLabel(style: .description, text: "")
	private let healthScoreContainerView = UIView()
	private let healthScoreGradientStackView = UIStackView()
	private let healthScoreGradientView = UIView()
	private let healthScoreGradientLayer = CAGradientLayer()
	private let healthScoreNumbersStackView = UIStackView()
	private let healthScoreNumbersSpacerView = UIView()
	private let healthScoreTriangleView = UIView()
	private let yourScoreView = UIView()
	private let yourScoreLabel = UILabel()
	private let startHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let endHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let currentHealthScoreView = UIView()
	private let currentHealthScoreLabelContainer = UIView()
	private let currentHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let healthScoreTriangleShape = CAShapeLayer()
	private let zoneInformationStackView = UIStackView()
	private let liquidationZoneStackView = UIStackView()
	private let liquidationZoneDotContainerView = UIView()
	private let liquidationZoneDotView = UIView()
	private let liquidationZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let dangerZoneStackView = UIStackView()
	private let dangerZoneDotContainerView = UIView()
	private let dangerZoneDotView = UIView()
	private let dangerZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let safetyZoneStackView = UIStackView()
	private let safetyZoneDotContainerView = UIView()
	private let safetyZoneDotView = UIView()
	private let safetyZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let gotItButton = PinoButton(style: .active)
	private let healthScoreTriangleWidth: Double = 14

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
        Web3Core.shared.getCompoundBorrowCAaveContractDetails(amount: 100.bigNumber.bigUInt).done { contractDetails in
            Web3Core.shared.getCompoundBorrowCTokenGasInfo(contractDetails: contractDetails).done { gasInfo in
                print("heh", gasInfo)
            }.catch { error in
                print("heh", error)
            }
        }
		setupHealthScoreLayers()
		let currentHealthScorePixel = calculateCurrentHealthScorePixel()
		setupHealthScoreColors(currentHealthScorePixel: currentHealthScorePixel)
		setupHealthScoreConstraints(currentHealthScorePixel: currentHealthScorePixel)
		setupHealthScoreStyles(currentHealthScorePixel: currentHealthScorePixel)
	}

	// MARK: - Initializers

	convenience init(healthScoreSystemInfoVM: HealthScoreSystemViewModel) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		self.healthScoreSystemInfoVM = healthScoreSystemInfoVM

		setupView()
		setupStyles()
		setupConstraints()
	}

	// MARK: - Private Methods

	private func setupView() {
		gotItButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

		healthScoreNumbersStackView.addArrangedSubview(startHealthScoreLabel)
		healthScoreNumbersStackView.addArrangedSubview(healthScoreNumbersSpacerView)
		healthScoreNumbersStackView.addArrangedSubview(endHealthScoreLabel)

		healthScoreGradientStackView.addArrangedSubview(healthScoreGradientView)
		healthScoreGradientStackView.addArrangedSubview(healthScoreNumbersStackView)

		yourScoreView.addSubview(yourScoreLabel)

		currentHealthScoreView.addSubview(currentHealthScoreLabelContainer)
		currentHealthScoreLabelContainer.addSubview(currentHealthScoreLabel)

		healthScoreContainerView.addSubview(healthScoreGradientStackView)
		healthScoreContainerView.addSubview(healthScoreTriangleView)
		healthScoreContainerView.addSubview(yourScoreView)
		healthScoreContainerView.addSubview(currentHealthScoreView)

		liquidationZoneDotContainerView.addSubview(liquidationZoneDotView)

		liquidationZoneStackView.addArrangedSubview(liquidationZoneDotContainerView)
		liquidationZoneStackView.addArrangedSubview(liquidationZoneDescribtionLabel)

		dangerZoneDotContainerView.addSubview(dangerZoneDotView)

		dangerZoneStackView.addArrangedSubview(dangerZoneDotContainerView)
		dangerZoneStackView.addArrangedSubview(dangerZoneDescribtionLabel)

		safetyZoneDotContainerView.addSubview(safetyZoneDotView)

		safetyZoneStackView.addArrangedSubview(safetyZoneDotContainerView)
		safetyZoneStackView.addArrangedSubview(safetyZoneDescribtionLabel)

		zoneInformationStackView.addArrangedSubview(liquidationZoneStackView)
		zoneInformationStackView.addArrangedSubview(dangerZoneStackView)
		zoneInformationStackView.addArrangedSubview(safetyZoneStackView)

		mainStackView.addArrangedSubview(titleLabel)
		mainStackView.addArrangedSubview(describtionLabel)
		mainStackView.addArrangedSubview(healthScoreContainerView)
		mainStackView.addArrangedSubview(zoneInformationStackView)
		mainStackView.addArrangedSubview(gotItButton)

		containerView.addSubview(mainStackView)

		view.addSubview(containerView)
	}

	private func setupStyles() {
		containerView.backgroundColor = .Pino.secondaryBackground
		containerView.layer.cornerRadius = 16

		currentHealthScoreLabelContainer.layer.cornerRadius = 16
		currentHealthScoreView.layer.cornerRadius = 18
		currentHealthScoreView.backgroundColor = .Pino.white

		mainStackView.axis = .vertical
		mainStackView.spacing = 8
		mainStackView.setCustomSpacing(15, after: describtionLabel)
		mainStackView.setCustomSpacing(26, after: healthScoreContainerView)
		mainStackView.setCustomSpacing(40, after: zoneInformationStackView)

		liquidationZoneStackView.axis = .horizontal
		liquidationZoneStackView.spacing = 4
		liquidationZoneStackView.alignment = .top

		dangerZoneStackView.axis = .horizontal
		dangerZoneStackView.spacing = 4
		dangerZoneStackView.alignment = .top

		safetyZoneStackView.axis = .horizontal
		safetyZoneStackView.spacing = 4
		safetyZoneStackView.alignment = .top

		titleLabel.text = healthScoreSystemInfoVM.healthScoreTitle

		describtionLabel.text = healthScoreSystemInfoVM.healthScoreDescription

		gotItButton.title = healthScoreSystemInfoVM.gotItButtonTitle

		zoneInformationStackView.axis = .vertical
		zoneInformationStackView.spacing = 16

		liquidationZoneDotView.backgroundColor = .Pino.red
		liquidationZoneDotView.layer.cornerRadius = 6
		dangerZoneDotView.backgroundColor = .Pino.orange
		dangerZoneDotView.layer.cornerRadius = 6
		safetyZoneDotView.backgroundColor = .Pino.green
		safetyZoneDotView.layer.cornerRadius = 6

		liquidationZoneDescribtionLabel.font = .PinoStyle.mediumFootnote
		liquidationZoneDescribtionLabel.text = healthScoreSystemInfoVM.liquidationZoneDescription
		liquidationZoneDescribtionLabel.numberOfLines = 0

		dangerZoneDescribtionLabel.font = .PinoStyle.mediumFootnote
		dangerZoneDescribtionLabel.text = healthScoreSystemInfoVM.dangerZoneDescribtion
		dangerZoneDescribtionLabel.numberOfLines = 0

		safetyZoneDescribtionLabel.font = .PinoStyle.mediumFootnote
		safetyZoneDescribtionLabel.text = healthScoreSystemInfoVM.safetyZoneDescribtion
		safetyZoneDescribtionLabel.numberOfLines = 0

		healthScoreGradientStackView.axis = .vertical
		healthScoreGradientStackView.spacing = 4

		healthScoreNumbersStackView.axis = .horizontal

		startHealthScoreLabel.font = .PinoStyle.mediumFootnote
		startHealthScoreLabel.text = healthScoreSystemInfoVM.startHealthScoreNumber
		endHealthScoreLabel.font = .PinoStyle.mediumFootnote
		endHealthScoreLabel.text = healthScoreSystemInfoVM.endHealthScoreNumber

		yourScoreLabel.font = .PinoStyle.semiboldFootnote
		yourScoreLabel.text = healthScoreSystemInfoVM.yourScoreText
		yourScoreLabel.textColor = .Pino.white

		yourScoreView.layer.cornerRadius = 12

		healthScoreGradientLayer.colors = [
			UIColor.Pino.red.cgColor,
			UIColor.Pino.orange.cgColor,
			UIColor.Pino.successGreen3.cgColor,
			UIColor.Pino.mediumGreen.cgColor,
		]
		healthScoreGradientLayer.locations = [0.0, 0.1, 0.2, 1.0]
		healthScoreGradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
		healthScoreGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

		healthScoreGradientView.layer.addSublayer(healthScoreGradientLayer)

		let healthScoreTraianglePath = UIBezierPath()
		healthScoreTraianglePath.move(to: CGPoint(x: 9.5, y: healthScoreTriangleWidth))
		healthScoreTraianglePath.addLine(to: CGPoint(x: 18, y: 0))
		healthScoreTraianglePath.addLine(to: CGPoint(x: 0, y: 0))
		healthScoreTraianglePath.addLine(to: CGPoint(x: 8.5, y: healthScoreTriangleWidth))

		healthScoreTriangleShape.path = healthScoreTraianglePath.cgPath

		healthScoreTriangleView.layer.addSublayer(healthScoreTriangleShape)

		currentHealthScoreLabel.font = .PinoStyle.semiboldCallout
		currentHealthScoreLabel.textColor = .Pino.white
		currentHealthScoreLabel.text = healthScoreSystemInfoVM.healthScoreNumber.description
	}

	private func setupConstraints() {
		containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
		liquidationZoneDotView.heightAnchor.constraint(equalToConstant: 12).isActive = true
		liquidationZoneDotView.widthAnchor.constraint(equalToConstant: 12).isActive = true
		dangerZoneDotView.heightAnchor.constraint(equalToConstant: 12).isActive = true
		dangerZoneDotView.widthAnchor.constraint(equalToConstant: 12).isActive = true
		safetyZoneDotView.heightAnchor.constraint(equalToConstant: 12).isActive = true
		safetyZoneDotView.widthAnchor.constraint(equalToConstant: 12).isActive = true

		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.verticalEdges(padding: 32), .horizontalEdges(padding: 16))
		healthScoreContainerView.pin(.fixedHeight(75))
		healthScoreGradientView.pin(.fixedHeight(8))
		healthScoreGradientStackView.pin(.horizontalEdges(padding: 0), .bottom(padding: 0))
		yourScoreView.pin(.fixedHeight(24), .relative(.bottom, 5, to: healthScoreTriangleView, .top))
		yourScoreLabel.pin(.centerY(), .horizontalEdges(padding: 10))
		currentHealthScoreView.pin(
			.centerY(to: healthScoreGradientView),
			.centerX(to: healthScoreTriangleView),
			.fixedHeight(36)
		)
		liquidationZoneDotContainerView.pin(.fixedWidth(12), .fixedHeight(18))
		dangerZoneDotContainerView.pin(.fixedWidth(12), .fixedHeight(18))
		safetyZoneDotContainerView.pin(.fixedWidth(12), .fixedHeight(18))
		liquidationZoneDotView.pin(.horizontalEdges(padding: 0), .top(padding: 1))
		dangerZoneDotView.pin(.horizontalEdges(padding: 0), .top(padding: 1))
		safetyZoneDotView.pin(.horizontalEdges(padding: 0), .top(padding: 1))

		currentHealthScoreLabel.pin(.centerY, .horizontalEdges(padding: 8))
		currentHealthScoreLabelContainer.pin(.verticalEdges(padding: 2), .horizontalEdges(padding: 2))
	}

	private func setupHealthScoreLayers() {
		healthScoreGradientLayer.frame = healthScoreGradientView.bounds
	}

	private func getColorOfHealthScoreGradientLayerPoint(point: CGPoint) -> UIColor {
		var pixel: [CUnsignedChar] = [0, 0, 0, 0]

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

		let context = CGContext(
			data: &pixel,
			width: 1,
			height: 1,
			bitsPerComponent: 8,
			bytesPerRow: 4,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		)

		context!.translateBy(x: -point.x, y: -point.y)

		healthScoreGradientLayer.render(in: context!)

		let red = CGFloat(pixel[0]) / 255.0
		let green = CGFloat(pixel[1]) / 255.0
		let blue = CGFloat(pixel[2]) / 255.0
		let alpha = CGFloat(pixel[3]) / 255.0

		let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

		return color
	}

	private func setupHealthScoreConstraints(currentHealthScorePixel: Double) {
		let halfYourScoreViewWidth = (yourScoreView.frame.width - healthScoreTriangleWidth) / 2
		let healthScoreGradientViewWidth = healthScoreGradientView.frame.width
		let halfCurrentHealthScoreLabelContainerWidth = currentHealthScoreView.frame.width / 2
		let healthScoreGradientRemainingWidth = healthScoreGradientViewWidth - currentHealthScorePixel

		if halfCurrentHealthScoreLabelContainerWidth > currentHealthScorePixel {
			healthScoreTriangleView.pin(
				.relative(.bottom, -2, to: currentHealthScoreLabelContainer, .top),
				.leading(padding: halfCurrentHealthScoreLabelContainerWidth - 9.4),
				.fixedHeight(14),
				.fixedWidth(18)
			)
		} else if healthScoreGradientRemainingWidth < halfCurrentHealthScoreLabelContainerWidth {
			healthScoreTriangleView.pin(
				.relative(.bottom, -2, to: currentHealthScoreLabelContainer, .top),
				.trailing(padding: halfCurrentHealthScoreLabelContainerWidth - 9.4),
				.fixedHeight(14),
				.fixedWidth(18)
			)
		} else {
			healthScoreTriangleView.pin(
				.relative(.bottom, -2, to: currentHealthScoreLabelContainer, .top),
				.leading(padding: currentHealthScorePixel - 9),
				.fixedHeight(14),
				.fixedWidth(18)
			)
		}

		if halfYourScoreViewWidth > currentHealthScorePixel {
			yourScoreView.pin(.leading(padding: 0))
		} else if healthScoreGradientRemainingWidth < halfYourScoreViewWidth {
			yourScoreView.pin(.trailing(padding: 0))
		} else {
			yourScoreView.pin(.centerX(to: healthScoreTriangleView))
		}
	}

	private func setupHealthScoreColors(currentHealthScorePixel: Double) {
		let currentHealthScoreColor =
			getColorOfHealthScoreGradientLayerPoint(point: CGPoint(x: currentHealthScorePixel, y: 0))
		healthScoreTriangleShape.fillColor = currentHealthScoreColor.cgColor
		yourScoreView.backgroundColor = currentHealthScoreColor
		currentHealthScoreLabelContainer.backgroundColor = currentHealthScoreColor
	}

	private func setupHealthScoreStyles(currentHealthScorePixel: Double) {
		let healthScoreNumberSafeAreaSize: CGFloat = 5
		let currentHealthScoreLabelContainerHalfWidth = currentHealthScoreView.frame.width / 2
		let startHealthScoreNumberLabelWidth = startHealthScoreLabel.frame
			.width + healthScoreNumberSafeAreaSize + currentHealthScoreLabelContainerHalfWidth
		let endtHealthScoreNumberLabelWidth = endHealthScoreLabel.frame
			.width + healthScoreNumberSafeAreaSize + currentHealthScoreLabelContainerHalfWidth
		let healthScoreGradientViewWidth = healthScoreGradientView.frame.width
		let endHealthScoreSafeArea = healthScoreGradientViewWidth - endtHealthScoreNumberLabelWidth

		if currentHealthScorePixel < startHealthScoreNumberLabelWidth {
			startHealthScoreLabel.isHidden = true
		} else if currentHealthScorePixel > endHealthScoreSafeArea {
			endHealthScoreLabel.isHidden = true
		} else {
			startHealthScoreLabel.isHidden = false
			endHealthScoreLabel.isHidden = false
		}
	}

	private func calculateCurrentHealthScorePixel() -> Double {
		let gradientViewSectionWidth = healthScoreGradientView.frame.width / 100
		let healthScoreSafeAreaNumber = 0.3
		if healthScoreSystemInfoVM.healthScoreNumber < 1 {
			return (healthScoreSystemInfoVM.healthScoreNumber + healthScoreSafeAreaNumber) *
				gradientViewSectionWidth
		} else if healthScoreSystemInfoVM.healthScoreNumber > 99 {
			return (healthScoreSystemInfoVM.healthScoreNumber - healthScoreSafeAreaNumber) *
				gradientViewSectionWidth
		} else {
			return healthScoreSystemInfoVM.healthScoreNumber * gradientViewSectionWidth
		}
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
