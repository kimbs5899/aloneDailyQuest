//
//  RankingViewController.swift
//  AloneDailyQuest_Project
//
//  Created by Wooseok on 3/24/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class RankingViewController: UIViewController {
    private let profileBoxView: ProfileBoxView = ProfileBoxView()
    private let tabView: TabView = TabView()
    private let backgroundBottomImageView = UIImageView()
    private let titleText = UILabel()
    private let titleBackgroundText = UILabel()
    private let rankingLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let levelLabel = UILabel()
    private var rank1 = UIStackView()
    private var rank2 = UIStackView()
    private var rank3 = UIStackView()
    private var rank4 = UIStackView()
    private var rank5 = UIStackView()
    private var rank6 = UIStackView()
    private var rank7 = UIStackView()
    private var rank8 = UIStackView()
    private var rank9 = UIStackView()
    private var rank10 = UIStackView()
    private lazy var topStackView = UIStackView()
    private lazy var ranks = [rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10]
    
    private lazy var centerStackView = UIStackView()
    private lazy var myRank = UIStackView()
    lazy var backgroundView = UIImageView()
    
    private let viewModel: RankingViewModel
    private var viewDidLoadEvent: Observable<Void> = Observable(())
    private lazy var input = RankingViewModel.Input(viewDidLoad: viewDidLoadEvent,
                                                    qeusetViewEvent: tabView.qeusetViewEvent,
                                                    rankViewEvent: tabView.rankiViewEvent, 
                                                    profileViewEvent: tabView.profileViewEvent)
    private lazy var output = viewModel.transform(input: input)
    
    init(viewModel: RankingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        bindOutput()
        setupProfile()
        input.viewDidLoad.value = ()
    }
    
}

extension RankingViewController {
    private func setStyle() {
        view.backgroundColor = UIColor(red: 0.22, green: 0.784, blue: 0.784, alpha: 1)
        
        backgroundBottomImageView.do { $0.image = UIImage(named: "image_background_bottom") }
        
        titleText.do {
            $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
            $0.attributedText = makeAttributedTitle(title: "월드랭킹")
        }
        
        titleBackgroundText.do {
            $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
            $0.attributedText = makeAttributedTitleBackground(title: "월드랭킹")
        }
        
        rankingLabel.do {
            $0.text = "랭킹"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont(name: "DungGeunMo", size: 14)
        }
        
        nickNameLabel.do {
            $0.text = "닉네임"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont(name: "DungGeunMo", size: 14)
        }
        
        levelLabel.do {
            $0.text = "레벨"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont(name: "DungGeunMo", size: 14)
        }
        
        topStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        centerStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .bottom
        }
        
        backgroundView.do {
            $0.image = UIImage(named: "img_background_history")
            $0.contentMode = .scaleToFill
        }
        
        zip(ranks, 1...10).forEach { rankStackView, ranking in
            rankStackView.do {
                $0.addArrangedSubviews([makeRankView(rank: ranking), makeLabel(text: "-", size: 14), makeLabel(text: "-", size: 14)])
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.alignment = .center
                if ranking % 2 == 0 {
                    $0.backgroundColor =  UIColor(hexCode: "FEE5C8")
                }
            }
        }
        
        myRank.do {
            $0.addArrangedSubviews([makeLabel(text: "-", size: 25), makeLabel(text: "-", size: 25), makeLabel(text: "-", size: 25)])
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
    }
    
    private func setLayout() {
        view.addSubviews([titleBackgroundText, titleText, backgroundBottomImageView,
                          profileBoxView, backgroundView, topStackView,
                          centerStackView, myRank, tabView])
        topStackView.addArrangedSubviews([rankingLabel, nickNameLabel, levelLabel])
        centerStackView.addArrangedSubviews(ranks)
        
        titleText.snp.makeConstraints {
            $0.width.equalTo(123)
            $0.height.equalTo(33)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(63)
        }
        
        titleBackgroundText.snp.makeConstraints {
            $0.width.equalTo(123)
            $0.height.equalTo(33)
            $0.centerX.equalToSuperview().inset(3)
            $0.top.equalToSuperview().inset(66)
        }
        
        profileBoxView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom).offset(20)
            $0.width.equalTo(500)
            $0.height.equalTo(104)
        }
        
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileBoxView.snp.bottom).offset(20)
            $0.width.equalTo(374)
            $0.height.equalTo(404)
        }
        
        backgroundBottomImageView.snp.makeConstraints {
            $0.width.equalTo(430)
            $0.height.equalTo(188)
            $0.bottom.equalToSuperview()
        }
        
        tabView.snp.makeConstraints {
            $0.height.equalTo(146)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top)
            $0.leading.equalTo(backgroundView.snp.leading)
            $0.trailing.equalTo(backgroundView.snp.trailing)
            $0.height.equalTo(44)
        }
        
        centerStackView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom)
            $0.leading.equalTo(backgroundView.snp.leading)
            $0.trailing.equalTo(backgroundView.snp.trailing)
            $0.bottom.equalTo(backgroundView.snp.bottom).offset(-65)
        }
        
        ranks.forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.trailing.equalToSuperview().inset(4)
            }
        }
        
        myRank.snp.makeConstraints {
            $0.top.equalTo(centerStackView.snp.bottom).offset(15)
            $0.leading.equalTo(backgroundView.snp.leading)
            $0.trailing.equalTo(backgroundView.snp.trailing)
            $0.bottom.equalTo(backgroundView.snp.bottom).offset(-20)
        }
    }
}

extension RankingViewController {
    private func bindOutput() {
        output.rankingList.bind { [weak self] rankingList in
            self?.setupRankingTable(rankingList: rankingList)
        }
        output.myRanking.bind { [weak self] myRanking in
            self?.setupMyRanking(myRanking: myRanking)
        }
        output.errorMessage.bind { [weak self] errorMessage in
            self?.completedAlert(message: "네트워크 오류가 발생했습니다.")
        }
    }
    
    private func setupProfile() {
        guard
            let nickName = myRank.arrangedSubviews[1] as? UILabel,
            let level = myRank.arrangedSubviews[2] as? UILabel
        else {
            return
        }
        let user = UserInfo(nickName: UserDefaults.standard.string(forKey: "nickName")!,
                 experience: UserDefaults.standard.integer(forKey: "experience"))
        profileBoxView.configureLabel(nickName: user.fetchNickName(), level: String(user.fetchLevel()))
        profileBoxView.updateExperienceBar(currentExp: user.fetchExperience() % 10)
        nickName.text = user.fetchNickName()
        level.text = "\(user.fetchLevel())"
    }
    
    private func setupRankingTable(rankingList: [UserInfo]) {
        for (user, rankBoxLow) in zip(rankingList, ranks) {
            guard
                let nickName = rankBoxLow.arrangedSubviews[1] as? UILabel,
                let level = rankBoxLow.arrangedSubviews[2] as? UILabel
            else {
                return
            }
            nickName.text = user.fetchNickName()
            level.text = "\(user.fetchLevel())"
        }
    }
    
    private func setupMyRanking(myRanking: Int) {
        guard
            let ranking = myRank.arrangedSubviews[0] as? UILabel
        else {
            return
        }
        ranking.text = "\(myRanking)위"
    }
}

extension RankingViewController {
    private func makeRankView(rank: Int) -> UIView {
        switch rank{
        case 1, 2, 3:
            return makeRankingImage(rank: rank)
        default:
            return makeLabel(text: "\(rank)위", size: 14)
        }
    }
    
    private func makeLabel(text: String, size: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont(name: "DungGeunMo", size: CGFloat(size))
        label.textAlignment = .center
        return label
    }
    
    private func makeRankingImage(rank: Int) -> UIStackView {
        let rankImg = UIImage(named: makeRankerImage(rank: rank))
        let rankImgView = UIImageView(image: rankImg)
        let imageStackView = UIStackView()
        imageStackView.addSubview(rankImgView)
        imageStackView.snp.makeConstraints { $0.height.equalTo(20) }
        rankImgView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.leading.equalToSuperview().inset(35)
        }
        return imageStackView
    }
    
    private func makeRankerImage(rank: Int) -> String {
        return switch rank {
        case 1:
            "img_rank_first"
        case 2:
            "img_rank_second"
        default:
            "img_rank_third"
        }
    }
}
