//
//  OrderChip.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit

final class SearchOrderChip: UIButton {
    init() {
        super.init(frame: .zero)
        var orderButtonConfiguration = UIButton.Configuration.filled()
        
        orderButtonConfiguration.cornerStyle = .capsule
        orderButtonConfiguration.title = "관련순"
        orderButtonConfiguration.baseForegroundColor = .label
        orderButtonConfiguration.baseBackgroundColor = .systemGray6
        orderButtonConfiguration.image = UIImage(systemName: "align.horizontal.left")?
            .withTintColor(
                .black,
                renderingMode: .alwaysOriginal
            )
        orderButtonConfiguration.imagePadding = .zero
        configuration = orderButtonConfiguration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
