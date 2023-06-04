//
//  ContentViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit
import RxSwift
import RxCocoa

class ContentViewModel: ViewModel, ViewModelType {
    struct Input {}

    struct Output {
        let tabViewItems: Driver<[ContentTabViewItem]>
    }

    let selectedIndex: Driver<Int>
    
    init(selectedIndex: Driver<Int>, provider: MarkdownFileProvider) {
        self.selectedIndex = selectedIndex
        super.init(provider: provider)
    }

    func transform(_ input: Input) -> Output {
        let tabViewItems = Observable.just(ContentTabViewItem.allCases).asDriver(onErrorJustReturn: [])
        return Output(tabViewItems: tabViewItems)
    }

    func viewModel(for tabViewItem: ContentTabViewItem) -> any ViewModelType {
        switch tabViewItem {
        case .document:
            return DocumentViewModel(provider: provider)
        case .codeBlock:
            return CodeBlockViewModel(provider: provider)
        }
    }
}
