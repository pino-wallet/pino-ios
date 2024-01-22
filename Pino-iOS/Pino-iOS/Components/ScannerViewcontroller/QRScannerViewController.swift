//
//  ScannerViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/14/23.
//

import AVFoundation
import UIKit

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	// MARK: - Private Properties

	private var captureSession: AVCaptureSession!
	private var previewLayer: AVCaptureVideoPreviewLayer!
	private var foundAddress: (String) -> Void

	private let scannerTitle: String
	private let overlayView = UIImageView()
	private let dimmingView = UIView()
	private let scanTitleLabel = UILabel()

	// MARK: - Initializers

	init(scannerTitle: String, foundAddress: @escaping (String) -> Void) {
		self.foundAddress = foundAddress
		self.scannerTitle = scannerTitle
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.black
		captureSession = AVCaptureSession()

		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput

		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}

		if captureSession.canAddInput(videoInput) {
			captureSession.addInput(videoInput)
		} else {
			scanningIsNotSupported()
			return
		}

		let metadataOutput = AVCaptureMetadataOutput()

		if captureSession.canAddOutput(metadataOutput) {
			captureSession.addOutput(metadataOutput)

			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
		} else {
			scanningIsNotSupported()
			return
		}

		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)

		setupView()
		setupStyle()
		setupConstraint()

		startScanning()
	}

	fileprivate func startScanning() {
		if captureSession?.isRunning == false {
			DispatchQueue.global(qos: .userInitiated).async {
				self.captureSession.startRunning()
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		startScanning()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if captureSession?.isRunning == true {
			captureSession.stopRunning()
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateDimmingView()
	}

	override var prefersStatusBarHidden: Bool {
		true
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.portrait
	}

	// MARK: - Internal Properties

	internal func metadataOutput(
		_ output: AVCaptureMetadataOutput,
		didOutput metadataObjects: [AVMetadataObject],
		from connection: AVCaptureConnection
	) {
		captureSession.stopRunning()

		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			try? AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			found(code: stringValue)
		}
		dismiss(animated: true)
	}

	// MARK: - Private Methods

	private func setupView() {
		view.addSubview(dimmingView)
		view.bringSubviewToFront(dimmingView)

		view.addSubview(overlayView)
		view.bringSubviewToFront(overlayView)

		view.addSubview(scanTitleLabel)
		view.bringSubviewToFront(scanTitleLabel)
	}

	private func setupStyle() {
		view.backgroundColor = UIColor.black

		scanTitleLabel.text = scannerTitle
		scanTitleLabel.textColor = .Pino.white
		scanTitleLabel.font = .PinoStyle.boldBody

		overlayView.image = UIImage(named: "scanner_border")
		overlayView.backgroundColor = .clear
		dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
	}

	private func setupConstraint() {
		overlayView.pin(
			.centerX,
			.centerY(padding: -64)
		)
		dimmingView.pin(
			.allEdges
		)
		scanTitleLabel.pin(
			.centerX,
			.relative(.top, 64, to: overlayView, .bottom)
		)

		NSLayoutConstraint.activate([
			overlayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
			overlayView.heightAnchor.constraint(equalTo: overlayView.widthAnchor),
		])
	}

	private func updateDimmingView() {
		view.layoutIfNeeded()

		dimmingView.frame = view.bounds

		let path = UIBezierPath(rect: view.bounds)
		let overlayFrame = CGRect(
			x: overlayView.frame.minX + (overlayView.frame.width * 0.026),
			y: overlayView.frame.minY + (overlayView.frame.width * 0.026),
			width: overlayView.frame.width - (overlayView.frame.width * 0.052),
			height: overlayView.frame.height - (overlayView.frame.width * 0.052)
		)
		let transparentPath = UIBezierPath(roundedRect: overlayFrame, cornerRadius: 8)
		path.append(transparentPath)
		path.usesEvenOddFillRule = true

		// Create a shape layer that will act as a mask for the dimming view
		let fillLayer = CAShapeLayer()
		fillLayer.path = path.cgPath
		fillLayer.fillRule = .evenOdd
		fillLayer.fillColor = UIColor.black.cgColor

		// Set the mask to the dimming view
		dimmingView.layer.mask = fillLayer
	}

	private func scanningIsNotSupported() {
		let ac = UIAlertController(
			title: "Scanning not supported",
			message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
			preferredStyle: .alert
		)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
		captureSession = nil
	}

	private func found(code: String) {
		foundAddress(code)
	}
}
