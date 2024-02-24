//
//  LineChart.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/20/23.
//

import Combine
import DGCharts
import UIKit

class PinoLineChart: LineChartView {
	// MARK: - Private Properties

	private var chartDataSet: LineChartDataSet!
	private var cancellables = Set<AnyCancellable>()
	private var loadingChartData = [
		ChartDataEntry(x: 0, y: 0),
		ChartDataEntry(x: 1, y: 0.5),
		ChartDataEntry(x: 2, y: 0.2),
		ChartDataEntry(x: 3, y: 2),
		ChartDataEntry(x: 4, y: 1),
		ChartDataEntry(x: 5, y: 3),
		ChartDataEntry(x: 6, y: 1.3),
		ChartDataEntry(x: 7, y: 3),
		ChartDataEntry(x: 8, y: 1.5),
		ChartDataEntry(x: 9, y: 4),
		ChartDataEntry(x: 10, y: 0.5),
		ChartDataEntry(x: 11, y: 4),
	]

	// MARK: - Public Properties

	@Published
	public var chartDataEntries: [ChartDataEntry]
	public weak var chartDelegate: LineChartDelegate?
	public let chartHasHighlight: Bool

	// MARK: Initializers

	init(chartDataEntries: [ChartDataEntry], chartHasHighlight: Bool = true) {
		self.chartDataEntries = chartDataEntries
		self.chartHasHighlight = chartHasHighlight
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

		if chartHasHighlight {
			marker = CircleMarker(color: .Pino.primary)

			let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
			longPressGesture.minimumPressDuration = 0.05
			longPressGesture.delegate = self
			addGestureRecognizer(longPressGesture)
		}
	}

	private func updateChartView() {
		chartDataSet.setColor(.Pino.green3)
		chartDataSet.drawCirclesEnabled = false
		chartDataSet.lineWidth = 2
		chartDataSet.mode = .horizontalBezier
		chartDataSet.fillAlpha = 0.5
		if let chartGradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [UIColor.Pino.lightBlue.cgColor, UIColor.Pino.secondaryBackground.cgColor] as CFArray,
			locations: [1, 0]
		) {
			chartDataSet.fill = LinearGradientFill(gradient: chartGradient, angle: 90)
		}
		chartDataSet.drawFilledEnabled = true
		chartDataSet.highlightColor = .Pino.primary
		chartDataSet.drawCircleHoleEnabled = false

		data = LineChartData(dataSets: [chartDataSet])
		data?.setDrawValues(false)
		chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
		chartDataSet.highlightLineDashLengths = [3, 3]
		chartDataSet.highlightLineWidth = 1
		isUserInteractionEnabled = true
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
		if let selectedPoint {
			generateHapticFeedback(selectedPoint)
			let selectedPointData = getSelectedPointData(point: selectedPoint)
			let previousPointData = getPreviousPointData(point: selectedPoint)
			chartDelegate?.valueDidChange(selectedPointData: selectedPointData, previousPointData: previousPointData)
		} else {
			chartDelegate?.valueDidChange(selectedPointData: nil, previousPointData: nil)
		}
		highlightValue(selectedPoint)
		lastHighlighted = selectedPoint
	}

	private func getSelectedPointData(point: Highlight) -> Any? {
		chartDataEntries.first(where: { $0.x == point.x })?.data
	}

	private func getPreviousPointData(point: Highlight) -> Any? {
		guard let selectedPointIndex = chartDataEntries.firstIndex(where: { $0.x == point.x }), selectedPointIndex > 0
		else { return nil }
		return chartDataEntries[selectedPointIndex - 1].data
	}

	private func generateHapticFeedback(_ selectedPoint: Highlight) {
		if lastHighlighted != selectedPoint {
			let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
			hapticFeedback.impactOccurred()
		}
	}

	// MARK: - Public Methods

	public func showLoading() {
		chartDataSet = LineChartDataSet(entries: loadingChartData)
		chartDataSet.setColor(.Pino.gray5)
		chartDataSet.drawCirclesEnabled = false
		chartDataSet.lineWidth = 2
		chartDataSet.mode = .cubicBezier
		chartDataSet.drawFilledEnabled = false
		chartDataSet.drawCircleHoleEnabled = false
		data = LineChartData(dataSets: [chartDataSet])
		data?.setDrawValues(false)
		chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
		isUserInteractionEnabled = false
	}
}
