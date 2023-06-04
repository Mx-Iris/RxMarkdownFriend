//
//  SidebarCellView.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/24.
//

import AppKit
import SnapKit

class SidebarCellView: NSTableCellView {
    let titleLabel = NSTextField(labelWithString: "")
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func commonInit() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
