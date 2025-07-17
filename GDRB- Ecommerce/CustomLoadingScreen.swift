//
//  Untitled.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 08/07/25.
//
import UIKit
import FLAnimatedImage

class LoadingView: UIView {
    
    static let shared = LoadingView()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gifView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        containerView.addSubview(gifView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            containerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 150),
            containerView.heightAnchor.constraint(equalToConstant: 150),

            gifView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            gifView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            gifView.widthAnchor.constraint(equalToConstant: 80),
            gifView.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Load GIF
        if let path = Bundle.main.path(forResource: "shopping", ofType: "gif"),
           let data = NSData(contentsOfFile: path) {
            let gif = FLAnimatedImage(animatedGIFData: data as Data)
            gifView.animatedImage = gif
        }else{
            print("Missing")
        }
    }

    func show(on view: UIView? = UIApplication.shared.keyWindow) {
        guard let targetView = view else { return }
        if self.superview == nil {
            targetView.addSubview(self)
        }
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
