//
//  ResizableContainerView.swift
//  OttuApp
//
//  Created by Ottu on 06.05.2025.
//

import UIKit

class ResizableContainerView: UIView {
    var sizeChangedCallback: ((CGSize) -> Void)?
    private var lastSize: CGSize = .zero

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.frame.size != lastSize {
            lastSize = self.frame.size
            sizeChangedCallback?(self.frame.size)
        }
    }
}
