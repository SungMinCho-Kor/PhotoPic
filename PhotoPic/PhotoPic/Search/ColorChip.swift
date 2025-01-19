//
//  ColorChip.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit

final class SearchColorChip: UIButton {
    init(color: SearchColor) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.title = color.chipName
        configuration.baseForegroundColor = .label
        configuration.baseBackgroundColor = .systemGray5
        configuration.image = UIImage(systemName: "circle.fill")?
            .withTintColor(
                color.uiColor,
                renderingMode: .alwaysOriginal
            )
        configuration.imagePadding = .zero
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 0,
            trailing: 12
        )
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectChip() {
        configuration?.baseBackgroundColor = .systemBlue
        configuration?.baseForegroundColor = .white
    }
    
    func deselectChip() {
        configuration?.baseBackgroundColor = .systemGray5
        configuration?.baseForegroundColor = .black
    }
}
