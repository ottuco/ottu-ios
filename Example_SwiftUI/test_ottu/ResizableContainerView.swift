//
//  ResizableContainerView.swift
//  test_ottu
//
//  Created by Oleksandr Pylypenko on 02.01.2025.
//

import SwiftUI

class ResizableContainerView: UIView {
    var sizeChangedCallback: ((CGSize) -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        sizeChangedCallback?(self.frame.size)
    }
}
