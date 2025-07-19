
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 18/07/25.
//

import UIKit

extension UIViewController{
    func setCustomTitle( withImage image: String, withTitle title: String ){
        let titleView = UIStackView()
        titleView.axis = .horizontal
        titleView.alignment = .center
        titleView.spacing = 6
        
        let imageView = UIImageView(image: UIImage(systemName: image))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        
        titleView.addArrangedSubview(imageView)
        titleView.addArrangedSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    func showAlert(title: String, message: String) {
      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    func setNavigationBarColors(backgroundColor: UIColor, titleColor: UIColor, tintColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = tintColor
    }
}
