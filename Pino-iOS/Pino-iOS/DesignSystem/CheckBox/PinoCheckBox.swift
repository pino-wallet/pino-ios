//
//  PinoCheckBox.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public class PinoCheckBox: UIButton {
    
    // MARK: - Initializers
    
    public init(style: Style = .defaultStyle) {
        self.style = style
        
        super.init(frame: .zero)
        
        addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        updateUI(isChecked: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: - Public properties
    
    public var style: Style
    

    // MARK: - private properties
    
    private var isChecked: Bool = false {
        didSet {
            updateUI(isChecked: isChecked)
        }
    }
    
    
    // MARK: - Private methods
    
    private func updateUI(isChecked: Bool){
        
        let checkBoxIcon = isChecked ? style.checkedImage : style.UncheckedImage
        let checkBoxTintColor = isChecked ? style.checkedTintColor : style.unchekedTintColor
        
        setImage(checkBoxIcon, for: .normal)
        tintColor = checkBoxTintColor
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
        
    // MARK: - UI overrides

    public override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        updateUI(isChecked: false)
    }
    
}
