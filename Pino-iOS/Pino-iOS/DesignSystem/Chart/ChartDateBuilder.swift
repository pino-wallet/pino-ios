//
//  ChartDateBuilder.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/23/23.
//

import Foundation

class ChartDateBuilder {
	// MARK: - Private Properties

	private var dateFilter: ChartDateFilter = .day
	private var dateRange = ""

	// MARK: - Initializers

	init(dateFilter: ChartDateFilter) {
		self.dateFilter = dateFilter
	}

	// MARK: - Public Methods

	public func timeFrame() -> String {
		switch dateFilter {
		case .day:
			return "Past day"
		case .week:
			return "Past week"
		case .month:
			return "Past month"
		case .year:
			return "Past year"
		case .all:
			return ""
		}
	}

	public func dateRange(firstDate: Date, lastDate: Date) -> String {
		switch dateFilter {
		case .day, .week:
			return buildDayMonth(firstDate: firstDate, lastDate: lastDate)
		case .month:
			return buildDayMonthYear(firstDate: firstDate, lastDate: lastDate)
		case .year:
			return buildMonthYear(firstDate: firstDate, lastDate: lastDate)
		case .all:
			return ""
		}
	}

	public func selectedDate(date: Date) -> String {
		switch dateFilter {
		case .day:
			return buildTime(date: date)
		case .week, .month:
			return buildDayMonthTime(date: date)
		case .year, .all:
			return buildDayMonthYear(date: date)
		}
	}

	public func buildDayMonthYear(date: Date) -> String {
		setMonth(date: date)
		setSpace()
		setDay(date: date)
		setComma()
		setYear(date: date)
		return dateRange
	}

	public func buildDayMonthYear(firstDate: Date, lastDate: Date) -> String {
		setMonth(date: firstDate)
		setSpace()
		setDay(date: firstDate)
		if firstDate.get(.year) != lastDate.get(.year) {
			setComma()
			setYear(date: firstDate)
		}
		setDash()
		setMonth(date: lastDate)
		setSpace()
		setDay(date: lastDate)
		setComma()
		setYear(date: lastDate)
		return dateRange
	}

	public func buildMonthYear(firstDate: Date, lastDate: Date) -> String {
		setMonth(date: firstDate)
		setComma()
		setYear(date: firstDate)
		setDash()
		setMonth(date: lastDate)
		setComma()
		setYear(date: lastDate)
		return dateRange
	}

	public func buildDayMonth(date: Date) -> String {
		setMonth(date: date)
		setSpace()
		setDay(date: date)
		return dateRange
	}

	public func buildDayMonth(firstDate: Date, lastDate: Date) -> String {
		setMonth(date: firstDate)
		setSpace()
		setDay(date: firstDate)
		setDash()
		setMonth(date: lastDate)
		setSpace()
		setDay(date: lastDate)
		return dateRange
	}

	public func buildDayMonthTime(date: Date) -> String {
		setMonth(date: date)
		setSpace()
		setDay(date: date)
		setAt()
		setTime(date: date)
		return dateRange
	}

	public func buildTime(date: Date) -> String {
		setTime(date: date)
		return dateRange
	}

	// MARK: - Private Methods

	private func setTime(date: Date) {
		let time = date.getHourMinuteTime()
		dateRange.append(time)
	}

	private func setDay(date: Date) {
		let day = String(date.get(.day))
		dateRange.append(day)
	}

	private func setMonth(date: Date) {
		let month = date.monthName()
		dateRange.append(month)
	}

	private func setYear(date: Date) {
		let year = String(date.get(.year))
		dateRange.append(year)
	}

	private func setDash() {
		dateRange.append(" - ")
	}

	private func setComma() {
		dateRange.append(", ")
	}

	private func setSpace() {
		dateRange.append(" ")
	}

	private func setAt() {
		dateRange.append(" at ")
	}
}
