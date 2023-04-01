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
		let point: Highlight?
		let valueChange: Double?
		if gesture.state == .ended {
			point = nil
			valueChange = nil
		} else {
			point = getHighlightByTouchPoint(gesture.location(in: self))
			let pointData = ChartDataEntry(x: point!.x, y: point!.y)
			if let pointIndex = chartDataEntries.firstIndex(of: pointData), pointIndex > 0 {
				let selectedPointValue = point!.y
				let previousPointValue = chartDataEntries[pointIndex - 1].y
				valueChange = ((selectedPointValue - previousPointValue) / previousPointValue) * 100
			} else {
				valueChange = 0
			}
		}
		highlightValue(point)
		if let chartDelegate {
			chartDelegate.valueDidChange(pointValue: point?.y, valueChangePercentage: valueChange)
		}
	}
}
