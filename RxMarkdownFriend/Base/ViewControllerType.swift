//
//  ViewControllerType.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit

protocol ViewControllerType: NSViewController {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel { get }
    init(viewModel: ViewModel)
    init?(coder: NSCoder, viewModel: ViewModel)
}
