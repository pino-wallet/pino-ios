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

	// MARK: - Initializers

	init(foundAddress: @escaping (String) -> Void) {
		self.foundAddress = foundAddress
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
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			found(code: stringValue)
		}
		dismiss(animated: true)
	}

	// MARK: - Private Methods

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
