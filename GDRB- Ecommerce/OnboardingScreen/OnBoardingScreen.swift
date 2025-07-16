//
//  OnBoardingScreen.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 26/06/25.
//

import UIKit

class OnBoardingScreen: UIViewController {
    
    @IBOutlet weak var AvatharImgview: UIImageView!
    @IBOutlet weak var paginationView: UIPageControl!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let AvatharImages: [UIImage?] = [UIImage(named: "Onboard01"), UIImage(named: "Onboard02"), UIImage(named: "Onboard03"), UIImage(named: "Onboard04")]
    let headerTiles: [String] = ["Fresh groceries to your doorstep!", "Shop your daily necessary!", "Stay safe, stay healthy, we deliver to your home!", "Fast shipment to your home!"]
    let descriptionValues: [String] = [
        "Lorem ipsum dolor sit amet consectetur. Odio cursus vitae nec eu dictumst quis eu ut amet. Proin sit cum cursus non arcu.",
        "Lorem ipsum dolor sit amet consectetur. Odio cursus vitae nec eu dictumst quis eu ut amet. Proin sit cum cursus non arcu.",
        "Lorem ipsum dolor sit amet consectetur. Odio cursus vitae nec eu dictumst quis eu ut amet. Proin sit cum cursus non arcu.",
        "Lorem ipsum dolor sit amet consectetur. Odio cursus vitae nec eu dictumst quis eu ut amet. Proin sit cum cursus non arcu."
    ]
    
    var currentIndex = 0
    var autoChangeTimer: Timer?
    var lastScreenTimer: Timer?
    var isViewControllerPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the first screen
        updateOnboardingContent()
        
        // Add swipe gestures
        addSwipeGestures()
        
        // Start the automatic change timer
        startAutoChangeTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Invalidate the auto-change timer for 5 seconds
        invalidateAutoChangeTimer()
        
        // Move to next or previous screen based on swipe direction
        if gesture.direction == .left {
            // Move to the next screen
            if currentIndex < AvatharImages.count - 1 {
                currentIndex += 1
            }
        } else if gesture.direction == .right {
            // If on the last screen, navigate to the login screen
            if currentIndex == AvatharImages.count - 1 {
                navigateToLoginScreen()
            } else {
                // Move to the previous screen
                if currentIndex > 0 {
                    currentIndex -= 1
                }
            }
        }
        
        // Update content after swipe
        updateOnboardingContent()
        
        // If on the last screen, show it for 3 seconds
        if currentIndex == AvatharImages.count - 1 {
            showLastScreenFor3Seconds()
        }
        
        // Resume the auto-change timer after 5 seconds
        resumeAutoChangeTimer(after: 5.0)
    }
    
    func updateOnboardingContent() {
        AvatharImgview.image = AvatharImages[currentIndex]
        HeaderLabel.text = headerTiles[currentIndex]
        descriptionLabel.text = descriptionValues[currentIndex]
        paginationView.currentPage = currentIndex
    }
    
    func showLastScreenFor3Seconds() {
        // Invalidate any previous timers
        lastScreenTimer?.invalidate()
        guard !isViewControllerPushed else{ return}
        // Set up a timer to stay on the last screen for 3 seconds
        lastScreenTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(navigateToLoginScreen), userInfo: nil, repeats: false)
    }
    
    @objc func navigateToLoginScreen() {
        // Perform any necessary actions before navigating to the login screen
        lastScreenTimer?.invalidate()
        autoChangeTimer?.invalidate()
        self.autoChangeTimer = nil
        self.lastScreenTimer = nil
        print("Navigating to login screen...")
        guard !isViewControllerPushed else{ return}
        isViewControllerPushed = true
        UserDefaults.standard.set(true, forKey: "isOnboarded")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let tabbarVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "Tabbar")
            sceneDelegate.window?.rootViewController = tabbarVC
            sceneDelegate.window?.makeKeyAndVisible()
        }

        
    }
    
    // Start the automatic change timer
    func startAutoChangeTimer() {
        autoChangeTimer?.invalidate()
        guard !isViewControllerPushed else{ return}
        autoChangeTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoChangeOnboarding), userInfo: nil, repeats: true)
    }
    
    // Auto change the onboarding content every 3 seconds
    @objc func autoChangeOnboarding() {
        // Move to the next screen automatically
        if currentIndex < AvatharImages.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0 // Loop back to the first screen
        }
        
        // Update content
        updateOnboardingContent()
        
        // Check if it's the last screen (4th index)
        if currentIndex == AvatharImages.count - 1 {
            showLastScreenFor3Seconds()
        }
    }
    
    // Invalidate the auto-change timer
    func invalidateAutoChangeTimer() {
        autoChangeTimer?.invalidate()
    }
    
    // Resume the auto-change timer after a delay
    func resumeAutoChangeTimer(after delay: TimeInterval) {
        // Start a new timer after the specified delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.startAutoChangeTimer()
        }
    }
    
    // Invalidate the timer when the view is dismissed or not needed anymore
    deinit {
        autoChangeTimer?.invalidate()
        lastScreenTimer?.invalidate()
    }
}
