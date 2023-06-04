//
//  PreviewViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/6/2.
//

import AppKit
import RxSwift
import RxCocoa

class PreviewViewModel: ViewModel, ViewModelType {
    struct Input {}

    struct Output {}

    var markdownString: Driver<String> {
        Observable.merge(
            provider.openedMarkdownFile
                .asObservable()
                .compactMap { $0 }
                .compactMap { try? String(contentsOf: $0) },
            provider.commitedMarkdownString
                .asObservable()
                .compactMap { $0 }
        ).asDriver(onErrorJustReturn: "")
    }

    var isPlaceholder: Driver<Bool> {
        markdownString.map { $0.isEmpty }
    }

    var hasContent: Driver<Bool> {
        markdownString.map { !$0.isEmpty }
    }

    func transform(_ input: Input) -> Output {
        .init()
    }
}
