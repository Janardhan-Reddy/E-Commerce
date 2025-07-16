//
//  CustomToast.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 08/07/25.
//

import UIKit

class ToastMessageView: UIView {
    
    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()
    
    init(message: String, iconName: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupUI(message: message, iconName: iconName, backgroundColor: backgroundColor)
    }
    
    private func setupUI(message: String, iconName: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.alpha = 0
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIViewController {
    func showToast(message: String, iconName: String = "checkmark.circle.fill", backgroundColor: UIColor = .systemGreen, duration: TimeInterval = 2.0) {
        
        let toast = ToastMessageView(message: message, iconName: iconName, backgroundColor: backgroundColor)
        toast.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toast)
        
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        // Animate in
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            // Animate out after delay
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
