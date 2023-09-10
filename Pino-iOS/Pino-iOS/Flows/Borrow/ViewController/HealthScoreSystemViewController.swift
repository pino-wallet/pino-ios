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
    private let healthScoreTriangleView = UIView()
    private let yourScoreView = UIView()
    private let yourScoreLabel = UILabel()
    private let startHealthScoreLabel = PinoLabel(style: .info, text: "")
    private let endHealthScoreLabel = PinoLabel(style: .info, text: "")
    private let currentHealthScoreLabel = PinoLabel(style: .info, text: "")
    private let healthScoreTriangleShape = CAShapeLayer()
    private let zoneInformationStackView = UIStackView()
    private let liquidationZoneStackView = HealthScoreZoneStackView()
    private let liquidationZoneDotView = HealthScoreZoneDotView()
    private let liquidationZoneDescribtionLabel = PinoLabel(style: .title, text: "")
    private let dangerZoneStackView = HealthScoreZoneStackView()
    private let dangerZoneDotView = HealthScoreZoneDotView()
    private let dangerZoneDescribtionLabel = PinoLabel(style: .title, text: "")
    private let safetyZoneStackView = HealthScoreZoneStackView()
    private let safetyZoneDotView = HealthScoreZoneDotView()
    private let safetyZoneDescribtionLabel = PinoLabel(style: .title, text: "")
    private let gotItButton = PinoButton(style: .active)
    private let healthScoreTriangleWidth: Double = 14
    

    // MARK: - View Overrides
    override func viewWillAppear(_ animated: Bool) {
        setupHealthScoreLayers()
        let gradientViewSectionWidth = healthScoreGradientView.frame.width / 100
        var currentHealthScorePixel: Double {
            let healthScoreSafeAreaNumber = 0.3
            if healthScoreSystemInfoVM.healthScoreNumber < 1 {
                return (healthScoreSystemInfoVM.healthScoreNumber + healthScoreSafeAreaNumber) * gradientViewSectionWidth
            } else if healthScoreSystemInfoVM.healthScoreNumber > 99 {
                return (healthScoreSystemInfoVM.healthScoreNumber - healthScoreSafeAreaNumber) * gradientViewSectionWidth
            } else {
                return healthScoreSystemInfoVM.healthScoreNumber * gradientViewSectionWidth
            }
        }
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
        
        healthScoreContainerView.addSubview(healthScoreGradientStackView)
        healthScoreContainerView.addSubview(healthScoreTriangleView)
        healthScoreContainerView.addSubview(yourScoreView)
        healthScoreContainerView.addSubview(currentHealthScoreLabel)
        
        liquidationZoneStackView.addArrangedSubview(liquidationZoneDotView)
        liquidationZoneStackView.addArrangedSubview(liquidationZoneDescribtionLabel)
        
        dangerZoneStackView.addArrangedSubview(dangerZoneDotView)
        dangerZoneStackView.addArrangedSubview(dangerZoneDescribtionLabel)
        
        safetyZoneStackView.addArrangedSubview(safetyZoneDotView)
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
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.setCustomSpacing(12, after: describtionLabel)
        mainStackView.setCustomSpacing(24, after: healthScoreContainerView)
        mainStackView.setCustomSpacing(40, after: zoneInformationStackView)

        titleLabel.text = healthScoreSystemInfoVM.healthScoreTitle

        describtionLabel.text = healthScoreSystemInfoVM.healthScoreDescription
        
        gotItButton.title = healthScoreSystemInfoVM.gotItButtonTitle
        
        zoneInformationStackView.axis = .vertical
        zoneInformationStackView.spacing = 16
       
        liquidationZoneDotView.color = .Pino.red
        dangerZoneDotView.color = .Pino.orange
        safetyZoneDotView.color = .Pino.green
        
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
        
        healthScoreGradientLayer.colors = [UIColor.Pino.red.cgColor, UIColor.Pino.orange.cgColor, UIColor.Pino.successGreen3.cgColor, UIColor.Pino.mediumGreen.cgColor]
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
        currentHealthScoreLabel.text = healthScoreSystemInfoVM.healthScoreNumber.description
    }

    private func setupConstraints() {
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        containerView.pin(.allEdges(padding: 0))
        mainStackView.pin(.verticalEdges(padding: 32), .horizontalEdges(padding: 16))
        healthScoreContainerView.pin(.fixedHeight(65))
        healthScoreGradientView.pin(.fixedHeight(8))
        healthScoreGradientStackView.pin(.horizontalEdges(padding: 0), .bottom(padding: 0))
        yourScoreView.pin(.fixedHeight(24), .relative(.bottom, 5, to: healthScoreTriangleView, .top))
        yourScoreLabel.pin(.centerY(), .horizontalEdges(padding: 10))
        currentHealthScoreLabel.pin(.relative(.top, 4, to: healthScoreGradientView, .bottom), .centerX(to: healthScoreTriangleView))
    }
    
    private func setupHealthScoreLayers() {
        healthScoreGradientLayer.frame = healthScoreGradientView.bounds
    }
    
    private func getColorOfHealthScoreGradientLayerPoint(point: CGPoint) -> UIColor {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context!.translateBy(x: -point.x, y: -point.y)

        healthScoreGradientLayer.render(in: context!)

        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0

        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)

        return color
    }
    
    private func setupHealthScoreConstraints(currentHealthScorePixel: Double) {
        let halfYourScoreViewWidth = (yourScoreView.frame.width - healthScoreTriangleWidth) / 2
        let healthScoreGradientViewWidth = healthScoreGradientView.frame.width
        let healthScoreGradientRemainingWidth = healthScoreGradientViewWidth - currentHealthScorePixel
        
        healthScoreTriangleView.pin(.relative(.bottom, -2, to: healthScoreGradientView, .top), .leading(padding: currentHealthScorePixel - 9), .fixedHeight(14), .fixedWidth(18))
        if halfYourScoreViewWidth > currentHealthScorePixel {
            yourScoreView.pin(.leading(padding: -healthScoreTriangleWidth))
        } else if healthScoreGradientRemainingWidth < halfYourScoreViewWidth {
            yourScoreView.pin(.trailing(padding: -healthScoreTriangleWidth))
        } else {
            yourScoreView.pin(.centerX(to: healthScoreTriangleView))
        }
    }
    
    private func setupHealthScoreColors(currentHealthScorePixel: Double) {
        let currentHealthScoreColor = getColorOfHealthScoreGradientLayerPoint(point: CGPoint(x: currentHealthScorePixel, y: 0))
        healthScoreTriangleShape.fillColor = currentHealthScoreColor.cgColor
        yourScoreView.backgroundColor = currentHealthScoreColor
    }
    
    private func setupHealthScoreStyles(currentHealthScorePixel: Double) {
        let healthScoreNumberSafeAreaSize: CGFloat = 5
        let currentHealthScoreLabelHalfWidth = currentHealthScoreLabel.frame.width / 2
        let startHealthScoreNumberLabelWidth = startHealthScoreLabel.frame.width + healthScoreNumberSafeAreaSize + currentHealthScoreLabelHalfWidth
        let endtHealthScoreNumberLabelWidth = endHealthScoreLabel.frame.width + healthScoreNumberSafeAreaSize + currentHealthScoreLabelHalfWidth
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

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

}
