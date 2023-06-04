//
//  ContentViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/21.
//

import Cocoa
import RxSwift
import RxCocoa

class ContentViewController: TabViewController<ContentViewModel>, ViewControllerType {
    
    override func setup() {
        super.setup()
        tabStyle = .unspecified
    }
    
    override func bind() {
        super.bind()
        let input = ContentViewModel.Input()
        let output = viewModel.transform(input)
        output.tabViewItems.drive { [weak self] (tabViewItems: [ContentTabViewItem]) in
            guard let self = self else { return }
            tabViewItems.map { NSTabViewItem(viewController: $0.controller(with: self.viewModel.viewModel(for: $0))) }.do {
                self.tabViewItems = $0
            }
        }.disposed(by: disposeBag)
        
        viewModel.selectedIndex.drive(rx.selectedTabViewItemIndex).disposed(by: disposeBag)
    }
}
