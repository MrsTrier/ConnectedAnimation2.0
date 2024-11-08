//
//  ConnectedAnimationViewController.swift
//  ConnectedAnimation
//
//  Created by Daria Cheremina on 07/11/2024.
//

import UIKit

class ConnectedAnimationViewController: UIViewController {

    private lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.value = 1
        slider.tintColor = .black
        
        setupSliderActions(for: slider)

        return slider
    }()

    private lazy var viewToAnimate: UIView = {
        let view = UIImageView(image: UIImage(named: "Otets"))
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = 150 / 6
        return view
    }()

    private var animator: UIViewPropertyAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(viewToAnimate)
        view.addSubview(slider)

        setupDeviceOrientationNotifications()
        setupLayout()
        setupAnimator()
    }

    private func setupLayout() {
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        viewToAnimate.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            viewToAnimate.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            viewToAnimate.widthAnchor.constraint(equalToConstant: 150),
            viewToAnimate.heightAnchor.constraint(equalToConstant: 150),
            viewToAnimate.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            slider.topAnchor.constraint(equalTo: viewToAnimate.bottomAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
         ])
    }

    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.viewToAnimate.center = CGPoint(
                x: self.view.layoutMargins.left + 25,
                y: self.viewToAnimate.center.y
            )

            self.viewToAnimate.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                .concatenating(CGAffineTransform(rotationAngle: -CGFloat(Float.pi / 2)))
        }
        animator?.pausesOnCompletion = true
    }

    private func setupSliderActions(for slider: UISlider) {
        slider.addAction(UIAction { _ in
            self.animator?.isReversed = false
            self.animator?.fractionComplete = CGFloat(slider.maximumValue) - CGFloat(slider.value)
        }, for: .valueChanged)

        slider.addAction(UIAction { _ in
            slider.setValue(1, animated: true)

            self.animator?.isReversed = true
            self.animator?.startAnimation()
        }, for: [.touchUpInside, .touchUpOutside])
    }

    private func setupDeviceOrientationNotifications() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.onOrientationChange),
            name: UIDevice.orientationDidChangeNotification, object: nil
        )
    }

    @objc func onOrientationChange() {
        animator?.stopAnimation(true)
        setupAnimator()
    }
}

