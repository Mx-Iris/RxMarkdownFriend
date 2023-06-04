//
//  TabViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit
import RxSwift

class TabViewController<ViewModel: ViewModelType>: NSTabViewController {
    let viewModel: ViewModel
    let disposeBag = DisposeBag()
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        bind()
    }
    
    func setup() {}

    func layout() {}

    func bind() {}
}
