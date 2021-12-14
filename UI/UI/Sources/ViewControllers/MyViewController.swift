//
//  MyViewController.swift
//  UI
//
//  Created by Jmy on 2021/11/05.
//

import UIKit

final class MyViewController: BaseViewController {
    // MARK: - Constants

    private struct Image {
        static let pencil: UIImage? = UIImage(systemName: "pencil")
    }

    private struct Font {
        static let nicknameButton: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let mailButton: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    }

    private let vcName: String = "마이"

    // MARK: - Views

    private let nicknameButton: UIButton = {
        var configuration: UIButton.Configuration = .filled()
        configuration.title = "Edit Nickname"
        configuration.subtitle = "닉네임 수정"
        configuration.buttonSize = .large
        configuration.cornerStyle = .capsule
        configuration.image = Image.pencil
        configuration.imagePlacement = .leading
        configuration.imagePadding = 16
        configuration.baseBackgroundColor = .systemIndigo
        configuration.baseForegroundColor = .systemPink
        let button: UIButton = UIButton(configuration: configuration, primaryAction: nil)
        button.sizeToFit()
        return button
    }()

    private let alertButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("경보", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = Font.mailButton
        return button
    }()

    private let mailButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("메일", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = Font.mailButton
        return button
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setTitleLabel(vcName)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        toast("실행 오류\n\n주소가 유효하지 않기 때문에\n해당 페이지를 열 수 없습니다.", bottom: true)
    }

    // MARK: - Methods

    private func setupViews() {
        view.add(nicknameButton, heightConstant: 44, center: view, centerYConstant: -44)
        view.add(alertButton, heightConstant: 44, center: view)
        view.add(mailButton, heightConstant: 44, center: view, centerYConstant: 44)

        nicknameButton.addTarget(self, action: #selector(nicknameButtonTouched(_:)), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(alertButtonTouched(_:)), for: .touchUpInside)
        mailButton.addTarget(self, action: #selector(mailButtonTouched(_:)), for: .touchUpInside)
    }

    @objc private func nicknameButtonTouched(_ sender: Any) {
        pushViewController(TextViewController())
    }

    @objc private func alertButtonTouched(_ sender: Any) {
        actionSheet(
            title: "title",
            message: "message",
            actions:
            .default("default", { _ in
                "default".log()
            }),
            .destructive("destructive", { _ in
                "destructive".log()
            })
        ) { _ in
            "cancel".log()
        } completion: {
            "completion".log()
        }
    }

    @objc private func mailButtonTouched(_ sender: Any) {
        pushViewController(MailComposeViewController())
    }
}
