//
//  PhotoDetailViewController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit
import SnapKit
import SwiftUI

final class PhotoDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileView = PhotoDetailProfileView()
    private let imageView = UIImageView()
    private let informationLabel = UILabel()
    private let informationStackView = UIStackView()
    private let sizeInformationView = InformationRowView()
    private let viewCountInformationView = InformationRowView()
    private let downloadInformationView = InformationRowView()
    private let chartLabel = UILabel()
    private let chartSegmentedControl = UISegmentedControl(
        items: [
            "조회",
            "다운로드"
        ]
    )
    private let viewChartView = UIHostingController(rootView: ChartView())
    private let downloadChartView = UIHostingController(rootView: ChartView())
    
    private let photoDetail: PhotoDetail
    
    init(photoDetail: PhotoDetail) {
        self.photoDetail = photoDetail
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStatisticsData()
        setSwiftUIView()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            profileView,
            imageView,
            informationLabel,
            informationStackView,
            chartLabel,
            chartSegmentedControl,
            viewChartView.view,
            downloadChartView.view
        ].forEach(contentView.addSubview)
        [
            sizeInformationView,
            viewCountInformationView,
            downloadInformationView
        ].forEach(informationStackView.addArrangedSubview)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(Double(photoDetail.height) / Double(photoDetail.width))
        }
        
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.width.equalTo(80)
        }
        
        informationStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.leading.equalTo(informationLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
        }
        
        chartLabel.snp.makeConstraints { make in
            make.top.equalTo(informationStackView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.width.equalTo(80)
        }
        
        chartSegmentedControl.snp.makeConstraints { make in
            make.leading.equalTo(chartLabel.snp.trailing)
            make.centerY.equalTo(chartLabel)
        }
        
        viewChartView.view.snp.makeConstraints { make in
            make.top.equalTo(chartSegmentedControl.snp.bottom).offset(16)
            make.leading.equalTo(chartSegmentedControl.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalTo(contentView).inset(40)
        }
        
        downloadChartView.view.snp.makeConstraints { make in
            make.top.equalTo(chartSegmentedControl.snp.bottom).offset(16)
            make.leading.equalTo(chartSegmentedControl.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalTo(contentView).inset(40)
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .white
        informationLabel.font = .systemFont(
            ofSize: 20,
            weight: .black
        )
        informationLabel.text = "정보"
        
        informationStackView.spacing = 16
        informationStackView.axis = .vertical
        
        chartLabel.font = .systemFont(
            ofSize: 20,
            weight: .black
        )
        chartLabel.text = "차트"
        
        downloadChartView.view.isHidden = true
        chartSegmentedControl.addTarget(
            self,
            action: #selector(chartSegmentedControlChanged),
            for: .valueChanged
        )
        chartSegmentedControl.selectedSegmentIndex = 0
        
        profileView.configure(
            image: photoDetail.user.profileImage.value,
            name: photoDetail.user.name,
            createdAt: photoDetail.createdAt
        )
        
        imageView.setImage(with: photoDetail.image.value)
        
        sizeInformationView.configure(
            title: "크기",
            content: "\(photoDetail.width) x \(photoDetail.height)"
        )
    }
    
    private func fetchStatisticsData() {
        GCDAPIService.shared.request(
            api: DefaultRouter.fetchStatistics(id: photoDetail.id)) { [weak self] (result: StatisticsResponse) in
                self?.downloadInformationView.configure(
                    title: "다운로드",
                    content: result.downloads.total.formatted()
                )
                self?.viewCountInformationView.configure(
                    title: "조회수",
                    content: result.views.total.formatted()
                )
                self?.downloadChartView.rootView.configure(elements: result.downloads.historical.values)
                self?.viewChartView.rootView.configure(elements: result.views.historical.values)
            } failureCompletion: { [weak self] (error: CustomError) in
                self?.presentErrorAlert(error: error)
            }
    }
    
    private func setSwiftUIView() {
        addChild(viewChartView)
        viewChartView.view.frame = view.frame
        viewChartView.didMove(toParent: self)
        addChild(downloadChartView)
        downloadChartView.view.frame = view.frame
        downloadChartView.didMove(toParent: self)
    }
}

//MARK: Objective-C
extension PhotoDetailViewController {
    @objc
    private func chartSegmentedControlChanged(_ sender: UISegmentedControl) {
        downloadChartView.view.isHidden = sender.selectedSegmentIndex == 0
        viewChartView.view.isHidden = sender.selectedSegmentIndex != 0
    }
}
