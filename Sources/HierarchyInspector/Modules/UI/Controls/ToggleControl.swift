//
//  ToggleControl.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 08.10.20.
//

import UIKit

final class ToggleControl: BaseFormControl {
    // MARK: - Properties

    var isOn: Bool {
        get {
            switchControl.isOn
        }
        set {
            setOn(newValue, animated: false)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            switchControl.isEnabled = isEnabled
        }
    }
    
    private lazy var switchControl = UISwitch().then {
        $0.addTarget(self, action: #selector(toggleOn), for: .valueChanged)
    }

    // MARK: - Init

    init(title: String?, isOn: Bool) {
        super.init(title: title)
        
        self.isOn = isOn
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()

        switchControl.onTintColor = .systemPurple
        
        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            switchControl.preferredStyle = .checkbox
            switchControl.thumbTintColor = .quaternaryLabel
        }
        #elseif swift(>=5.0)
        if #available(iOS 13.0, *) {
            switchControl.thumbTintColor = .quaternaryLabel
        }
        #endif

        contentView.addArrangedSubview(switchControl)
        
        updateViews()
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        switchControl.setOn(on, animated: animated)
        
        updateViews()
    }

    @objc
    func toggleOn() {
        updateViews()
        
        sendActions(for: .valueChanged)
    }
    
    func updateViews() {
        titleLabel.alpha = isOn ? 1 : 0.75
    }
}
