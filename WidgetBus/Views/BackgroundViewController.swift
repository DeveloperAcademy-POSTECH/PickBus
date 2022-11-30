//
//  BackgroundViewController.swift
//  WidgetBus
//
//  Created by LeeJaehoon on 2022/11/24.
//

import UIKit

class BackgroundViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "제목을\n입력해주세요"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let indicatorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progressIndicator_default")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSuperUI()
    }

    // MARK: - Helpers
    /**
     타이틀 명과 인디케이터 이미지를 설정합니다.
     */
    final func setTitleAndIndicator(titleText: String, indicatorStep: IndicatorStep) {
        titleLabel.text = titleText
        indicatorImage.image = UIImage(named: indicatorStep.rawValue)
    }

    final func configureSuperUI() {
        let guide = view.safeAreaLayoutGuide

        view.backgroundColor = UIColor.duduDeepBlue

        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true

        view.addSubview(indicatorImage)
        indicatorImage.widthAnchor.constraint(equalToConstant: 176).isActive = true
        indicatorImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        indicatorImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        indicatorImage.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 78).isActive = true

        view.addSubview(bottomBackgroundView)
        bottomBackgroundView.topAnchor
            .constraint(equalTo: indicatorImage.bottomAnchor, constant: 8).isActive = true
        bottomBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomBackgroundView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        bottomBackgroundView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true

        bottomBackgroundView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor).isActive = true

    }
}

// 인디케이터 단계별 이미지 ASSET 명
enum IndicatorStep: String {
    case stepOne = "progressIndicator1"
    case stepTwo = "progressIndicator2"
    case stepThree = "progressIndicator3"
    case stepFour = "progressIndicator4"
}
