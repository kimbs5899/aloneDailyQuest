//
//  AccountViewController.swift
//  AloneDailyQuest_Project
//
//  Created by Matthew on 12/1/23.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class SignupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var startButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(named: "btn_account_normal"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 300, height: 64)
        let attrString = NSAttributedString(
            string: "시작하기",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font : UIFont(name: "DungGeunMo", size: 22) ?? UIFont.systemFont(ofSize: 22),
                NSAttributedString.Key.strokeWidth: -2.0
            ]
        )
        button.setAttributedTitle(attrString, for: .normal)
        button.titleLabel!.layer.shadowColor = UIColor.black.cgColor
        button.titleLabel!.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        button.titleLabel!.layer.shadowOpacity = 1.0
        button.titleLabel!.layer.shadowRadius = 0
        button.titleLabel!.layer.masksToBounds = false
        button.isEnabled = false
        return button
    }()
    
    private lazy var validationText: UILabel = {
        var text = UILabel()
        text.font = UIFont(name: "DungGeunMo", size: 14)
        text.textAlignment = .center
        text.text = ""
        return text
    }()
    
    private lazy var nickNameTextField: UITextField = {
        var tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
        tf.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        tf.textAlignment = .center
        tf.font = UIFont(name: "DungGeunMo", size: 16)
        tf.textColor = .black
        return tf
    }()
    
    private lazy var info2Text: UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 0, y: 0, width: 222, height: 12)
        text.textColor = UIColor(red: 0.443, green: 0.218, blue: 0.04, alpha: 1)
        text.font = UIFont(name: "DungGeunMo", size: 12)
        text.textAlignment = .left
        text.text = "* 닉네임에는 영문자와 숫자, 한글만 사용할 수 있습니다. \n* 닉네임은 설정시 변경할 수 없습니다."
        text.numberOfLines = 0
        text.setLineSpacing(spacing: 8.0)
        return text
    }()
    
    private lazy var infoText: UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 0, y: 0, width: 279, height: 18)
        text.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        text.font = UIFont(name: "DungGeunMo", size: 18)
        text.textAlignment = .center
        text.text = "사용하실 닉네임을 입력해주세요."
        return text
    }()
    
    private lazy var backgroundBottomImageView: UIImageView = {
        var view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 430, height: 188)
        view.image = UIImage(named: "image_background_bottom")
        return view
    }()
    
    private lazy var nickNameImageView: UIImageView = {
        var view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 394, height: 204)
        view.image = UIImage(named: "img_account_background")
        return view
    }()
    
    private var logoText: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        let attrString = NSAttributedString(
            string: "나혼자만\n일일퀘스트",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font : UIFont(name: "DungGeunMo", size: 40) ?? UIFont.systemFont(ofSize: 40),
                NSAttributedString.Key.strokeWidth: -2.5
            ]
        )
        label.attributedText = attrString
        return label
    }()
    
    private var logoBackgroundText: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        let attrString = NSAttributedString(
            string: "나혼자만\n일일퀘스트",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.128, green: 0.345, blue: 0.345, alpha: 1),
                NSAttributedString.Key.font : UIFont(name: "DungGeunMo", size: 40) ?? UIFont.systemFont(ofSize: 40),
                NSAttributedString.Key.strokeWidth: -2.5
            ]
        )
        label.attributedText = attrString
        return label
    }()
    
    private let viewModel: SignupViewModel
    private lazy var input = SignupViewModel.Input(
        signupEvent: PublishRelay(),
        nickNameValidationEvent: nickNameTextField.rx.text.orEmpty)
    
    init(viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        autoLayoutConstraints()
        setupAddTarget()
        configureUI()
        bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        regiterNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterNotification()
    }
}

extension SignupViewController {
    private func bindOutput() {
        
        let output = viewModel.transform(input: input)
        
        output.isValidNickName
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) {owner, isValid in
                guard isValid else {
                    owner.startButton.isEnabled = false
                    owner.validationText.text = "잘못된 형식의 닉네임입니다."
                    owner.validationText.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                    return
                }
                owner.startButton.isEnabled = true
                owner.validationText.text = "올바른 닉네임입니다."
                owner.validationText.textColor = UIColor(hexCode: "21C131")
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, error in
                owner.completedAlert(message: error)
            }
            .disposed(by: disposeBag)
    }
}

extension SignupViewController {
    private func setupAddTarget() {
        startButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
    }
    
    @objc private func signup() {
        guard let nickName = nickNameTextField.text else {
            return
        }
        input.signupEvent.accept(nickName)
    }
    
    func regiterNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    func unRegisterNotification() {
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardEvent(notiInfo: Notification){
        guard let userInfo = notiInfo.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notiInfo.name == UIResponder.keyboardWillShowNotification {
//            self.nextBtnBottomConstraint.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
            nickNameImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        }else{
            nickNameImageView.topAnchor.constraint(equalTo: logoBackgroundText.bottomAnchor, constant: 60).isActive = true
        }
    }
}

extension SignupViewController {
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.22, green: 0.784, blue: 0.784, alpha: 1)
    }
    
    func addViews() {
        view.addSubview(logoBackgroundText)
        view.addSubview(logoText)
        view.addSubview(backgroundBottomImageView)
        view.addSubview(nickNameImageView)
        view.addSubview(nickNameTextField)
        view.addSubview(infoText)
        view.addSubview(info2Text)
        view.addSubview(validationText)
        view.addSubview(startButton)
        
    }
    func autoLayoutConstraints() {
        logoText.translatesAutoresizingMaskIntoConstraints = false
        logoBackgroundText.translatesAutoresizingMaskIntoConstraints = false
        backgroundBottomImageView.translatesAutoresizingMaskIntoConstraints = false
        nickNameImageView.translatesAutoresizingMaskIntoConstraints = false
        infoText.translatesAutoresizingMaskIntoConstraints = false
        info2Text.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        validationText.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoText.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        logoText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoText.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        
        logoBackgroundText.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoBackgroundText.heightAnchor.constraint(equalToConstant: 80).isActive = true
        logoBackgroundText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -3).isActive = true
        logoBackgroundText.topAnchor.constraint(equalTo: view.topAnchor, constant: 123).isActive = true
        
        backgroundBottomImageView.widthAnchor.constraint(equalToConstant: 430).isActive = true
        backgroundBottomImageView.heightAnchor.constraint(equalToConstant: 188).isActive = true
        backgroundBottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        nickNameImageView.widthAnchor.constraint(equalToConstant: 394).isActive = true
        nickNameImageView.heightAnchor.constraint(equalToConstant: 204).isActive = true
        nickNameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nickNameImageView.topAnchor.constraint(equalTo: logoBackgroundText.bottomAnchor, constant: 60).isActive = true
        
        infoText.widthAnchor.constraint(equalToConstant: 279).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: 18).isActive = true
        infoText.topAnchor.constraint(equalTo: nickNameImageView.topAnchor, constant: 20).isActive = true
        infoText.centerXAnchor.constraint(equalTo: nickNameImageView.centerXAnchor).isActive = true
        
        info2Text.widthAnchor.constraint(equalToConstant: 324).isActive = true
        info2Text.heightAnchor.constraint(equalToConstant: 50).isActive = true
        info2Text.topAnchor.constraint(equalTo: nickNameImageView.topAnchor, constant: 40).isActive = true
        info2Text.centerXAnchor.constraint(equalTo: nickNameImageView.centerXAnchor).isActive = true
        
        nickNameTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        nickNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nickNameTextField.topAnchor.constraint(equalTo: nickNameImageView.topAnchor, constant: 96).isActive = true
        nickNameTextField.centerXAnchor.constraint(equalTo: nickNameImageView.centerXAnchor).isActive = true
        
        validationText.topAnchor.constraint(equalTo: nickNameImageView.topAnchor, constant: 156).isActive = true
        validationText.centerXAnchor.constraint(equalTo: nickNameImageView.centerXAnchor).isActive = true
        
        startButton.topAnchor.constraint(equalTo: nickNameImageView.bottomAnchor, constant: 36).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
