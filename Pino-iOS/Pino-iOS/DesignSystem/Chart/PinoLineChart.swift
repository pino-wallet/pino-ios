//
//  LineChart.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/20/23.
//

import Charts
import Combine
import UIKit

class PinoLineChart: LineChartView {
	// MARK: - Private Properties

	private var chartDataSet: LineChartDataSet!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartDataEntries: [ChartDataEntry]
	public weak var chartDelegate: LineChartDelegate?

	// MARK: Initializers

	init(chartDataEntries: [ChartDataEntry]) {
		self.chartDataEntries = chartDataEntries
		super.init(frame: .zero)
		setupBindings()
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupBindings() {
		$chartDataEntries.sink { dataEntries in
			self.chartDataSet = LineChartDataSet(entries: dataEntries)
			self.updateChartView()
		}.store(in: &cancellables)
	}

	private func setupView() {
		drawGridBackgroundEnabled = false
		chartDataSet.setColor(.Pino.green3)

		chartDataSet.drawCirclesEnabled = false
		chartDataSet.lineWidth = 2
		chartDataSet.mode = .cubicBezier
		chartDataSet.fillAlpha = 0.5
		if let chartGradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [UIColor.Pino.lightBlue.cgColor, UIColor.Pino.secondaryBackground.cgColor] as CFArray,
			locations: [1, 0]
		) {
			chartDataSet.fill = LinearGradientFill(gradient: chartGradient, angle: 90)
		}
		chartDataSet.drawFilledEnabled = true
		chartDataSet.highlightColor = .Pino.green2
		chartDataSet.drawCircleHoleEnabled = false

		xAxis.enabled = false
		leftAxis.enabled = false
		rightAxis.enabled = false

		legend.enabled = false
		data = LineChartData(dataSets: [chartDataSet])
		data?.setDrawValues(false)
		doubleTapToZoomEnabled = false
		pinchZoomEnabled = false
		setScaleEnabled(false)

		highlightPerDragEnabled = false
		highlightPerTapEnabled = false

		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
		longPressGesture.allowableMovement = 50
		longPressGesture.delegate = self
		addGestureRecognizer(longPressGesture)
	}

	private func updateChartView() {
		chartDataSet.setColor(.Pino.green3)
		chartDataSet.drawCirclesEnabled = false
		chartDataSet.lineWidth = 2
		chartDataSet.mode = .cubicBezier
		chartDataSet.fillAlpha = 0.5
		if let chartGradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [UIColor.Pino.lightBlue.cgColor, UIColor.Pino.secondaryBackground.cgColor] as CFArray,
			locations: [1, 0]
		) {
			chartDataSet.fill = LinearGradientFill(gradient: chartGradient, angle: 90)
		}
		chartDataSet.drawFilledEnabled = true
		chartDataSet.highlightColor = .Pino.green2
		chartDataSet.drawCircleHoleEnabled = false

		data = LineChartData(dataSets: [chartDataSet])
		data?.setDrawValues(false)
	}

	@objc
	private func longPressDetected(gesture: UILongPressGestureRecognizer) {
		if gesture.state == .ended {
			updateHighlightValue(selectedPoint: nil)
		} else {
			guard let selectedPoint = getHighlightByTouchPoint(gesture.location(in: self)) else { return }
			updateHighlightValue(selectedPoint: selectedPoint)
		}
	}

	private func updateHighlightValue(selectedPoint: Highlight?) {
		highlightValue(selectedPoint)
		if let selectedPoint {
			let previousPoint = getPreviousPoint(point: selectedPoint)
			chartDelegate?.valueDidChange(pointValue: selectedPoint.y, previousValue: previousPoint?.y)
		} else {
			chartDelegate?.valueDidChange(pointValue: nil, previousValue: nil)
		}
	}

	private func getPreviousPoint(point: Highlight) -> ChartDataEntry? {
		let pointData = ChartDataEntry(x: point.x, y: point.y)
		if let pointIndex = chartDataEntries.firstIndex(of: pointData), pointIndex > 0 {
			let previousPoint = chartDataEntries[pointIndex - 1]
			return previousPoint
		} else {
			return nil
		}
	}
}
