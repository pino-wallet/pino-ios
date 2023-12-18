//
//  HealthScoreSystemViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/9/23.
//
import UIKit

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
	private let startHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let endHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let currentHealthScoreView = UIView()
	private let currentHealthScoreLabelContainer = UIView()
	private let currentHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let zoneInformationStackView = UIStackView()
	private let liquidationZoneStackView = UIStackView()
	private let liquidationZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let dangerZoneStackView = UIStackView()
	private let dangerZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let safetyZoneStackView = UIStackView()
	private let safetyZoneDescribtionLabel = PinoLabel(style: .title, text: "")
	private let gotItButton = PinoButton(style: .active)
	private let healthScoreTriangleWidth: Double = 14

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
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

		currentHealthScoreView.addSubview(currentHealthScoreLabelContainer)
		currentHealthScoreLabelContainer.addSubview(currentHealthScoreLabel)

		healthScoreContainerView.addSubview(healthScoreGradientStackView)
		healthScoreContainerView.addSubview(currentHealthScoreView)

		liquidationZoneStackView.addArrangedSubview(liquidationZoneDescribtionLabel)

		dangerZoneStackView.addArrangedSubview(dangerZoneDescribtionLabel)

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

		currentHealthScoreLabel.font = .PinoStyle.semiboldCallout
		currentHealthScoreLabel.textColor = .Pino.white
		currentHealthScoreLabel.text = healthScoreSystemInfoVM.formattedHealthScore
	}

	private func setupConstraints() {
		containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true

		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.verticalEdges(padding: 32), .horizontalEdges(padding: 16))
		healthScoreContainerView.pin(.fixedHeight(60))
		healthScoreGradientView.pin(.fixedHeight(8))
		healthScoreGradientStackView.pin(.horizontalEdges(padding: 0), .bottom(padding: 0))
		currentHealthScoreView.pin(
			.centerY(to: healthScoreGradientView),
			.fixedHeight(36)
		)

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
		let healthScoreGradientViewWidth = healthScoreGradientView.frame.width
		let halfCurrentHealthScoreLabelContainerWidth = currentHealthScoreView.frame.width / 2
		let healthScoreGradientRemainingWidth = healthScoreGradientViewWidth - currentHealthScorePixel

		if halfCurrentHealthScoreLabelContainerWidth > currentHealthScorePixel {
			currentHealthScoreView.pin(
				.leading(padding: -1)
			)
		} else if healthScoreGradientRemainingWidth < halfCurrentHealthScoreLabelContainerWidth {
			currentHealthScoreView.pin(
				.trailing(padding: -1)
			)
		} else {
			currentHealthScoreView.pin(
				.leading(padding: currentHealthScorePixel - halfCurrentHealthScoreLabelContainerWidth)
			)
		}
	}

	private func setupHealthScoreColors(currentHealthScorePixel: Double) {
		let currentHealthScoreColor =
			getColorOfHealthScoreGradientLayerPoint(point: CGPoint(x: currentHealthScorePixel, y: 0))
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
