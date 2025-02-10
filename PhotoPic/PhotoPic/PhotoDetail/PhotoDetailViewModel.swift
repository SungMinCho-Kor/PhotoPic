//
//  PhotoDetailViewModel.swift
//  PhotoPic
//
//  Created by 조성민 on 2/10/25.
//

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}


final class PhotoDetailViewModel: ViewModel {
    struct Input {
        let segmentedControlChanged: Observable<Int> = Observable(0)
        let viewDidLoad: Observable<Void> = Observable(())
    }
    
    struct Output {
        let configureDetail: Observable<PhotoDetail>
        let loadStatisticsData: Observable<StatisticsResponse?> = Observable(nil)
        let convertChart: Observable<Bool> = Observable(true)
        let presentErrorAlert: Observable<CustomError?> = Observable(nil)
    }
    
    private let photoDetail: PhotoDetail
    
    init(photoDetail: PhotoDetail) {
        self.photoDetail = photoDetail
        print(self, #function)
    }
    
    deinit {
        print(self, #function)
    }
    
    func transform(input: Input) -> Output {
        let output = Output(configureDetail: Observable<PhotoDetail>(photoDetail))
        
        input.segmentedControlChanged.bind { index in
            output.convertChart.value = index == 0
        }
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            output.configureDetail.value = photoDetail
            self.fetchData(output: output)
        }
        
        return output
    }
    
    func fetchData(output: Output) {
        GCDAPIService.shared.request(
            api: DefaultRouter.fetchStatistics(id: photoDetail.id)
        ) { (result: StatisticsResponse) in
            output.loadStatisticsData.value = result
        } failureCompletion: { (error: CustomError) in
            output.presentErrorAlert.value = error
        }
    }
}
