//
//  ViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/21.
//

import AppKit
import SnapKit
import RxSwift
import ArrayBuilderModule

class MainSplitViewController: NSSplitViewController {
    var sidebarViewController: SidebarViewController!

    var contentViewController: ContentViewController!

    var previewViewController: PreviewViewController!

    let provider: MarkdownFileProvider

    init(provider: MarkdownFileProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @ArrayBuilder<NSSplitViewItem>
    func makeSplitViewItems() -> [NSSplitViewItem] {
        NSSplitViewItem(sidebarWithViewController: sidebarViewController)
        NSSplitViewItem(viewController: contentViewController)
        NSSplitViewItem(viewController: previewViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sidebarViewModel = SidebarViewModel(provider: provider)

        let contentViewModel = ContentViewModel(selectedIndex: sidebarViewModel.selectedIndex.asDriver(onErrorJustReturn: 0), provider: provider)

        let previewViewModel = PreviewViewModel(provider: provider)

        sidebarViewController = SidebarViewController(viewModel: sidebarViewModel)
        contentViewController = ContentViewController(viewModel: contentViewModel)
        previewViewController = PreviewViewController(viewModel: previewViewModel)

        splitViewItems = makeSplitViewItems()

        splitView.autosaveName = "MainSplitView.AutoSaveName"
        
        sidebarViewController.view.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(200)
            make.width.lessThanOrEqualTo(300)
            make.height.greaterThanOrEqualTo(500)
        }

        contentViewController.view.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(350)
            make.height.greaterThanOrEqualTo(500)
        }

        previewViewController.view.snp.makeConstraints { make in
            make.width.equalTo(contentViewController.view)
            make.height.greaterThanOrEqualTo(500)
        }
    }
}
