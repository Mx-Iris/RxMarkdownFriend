//
//  ContentTabViewItem.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit

enum ContentTabViewItem: Int, CaseIterable {
    case document
    case codeBlock

    func controller<ViewModel: ViewModelType>(with viewModel: ViewModel) -> NSViewController {
        switch (self, viewModel) {
        case let (.document, viewModel as DocumentViewModel):
            let vc = DocumentViewController(viewModel: viewModel)
            return vc
        case let (.codeBlock, viewModel as CodeBlockViewModel):
            let vc = CodeBlockViewController(viewModel: viewModel)
            return vc
        default:
            fatalError("Not found match view model: \(viewModel)")
        }
    }
}
