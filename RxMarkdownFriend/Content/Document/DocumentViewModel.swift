//
//  DocumentViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit

class DocumentViewModel: ViewModel, ViewModelType {
    struct Input {}

    struct Output {}

    func transform(_ input: Input) -> Output {
        .init()
    }
}
