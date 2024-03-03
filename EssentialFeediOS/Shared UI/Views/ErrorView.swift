//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Hari on 07/12/23.
//

import UIKit

public final class ErrorView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    public var message: String? {
        get { return isVisible ? label.text : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public var onHide: (() -> Void )?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .errorBackgroundColor
        
        configureLabel()
        hideMessage()
    }
    
    private func configureLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: 8.0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0)
        ])
    }
    
    private var isVisible: Bool {
        return alpha > 0
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        hideMessage()
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }
    
    private func showAnimated(_ message: String) {
        label.text = message
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed {
                    self.hideMessage()
                }
            })
    }
    
    private func hideMessage() {
        label.text = nil
        alpha = 0
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor (red: 0.99951404330000004, green: 0.41759261489999999,
                        blue: 0.4154433012, alpha: 1)
    }
    
}
