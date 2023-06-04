//
//  PreviewViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/29.
//

import AppKit
import SnapKit
import SwiftUI
import Combine
import MarkdownUI
import RxSwift
import RxCocoa

class PreviewViewController: ViewController<PreviewViewModel>, ViewControllerType {
    let markdownView: NSHostingView<MarkdownView> = .init(rootView: .init(content: ""))

    let placeholderView: NSHostingView<PlaceholderView> = .init(rootView: .init())

    override func setup() {
        super.setup()
        view.addSubview(markdownView)
        view.addSubview(placeholderView)
        markdownView.isHidden = true
    }

    override func bind() {
        super.bind()

        viewModel.markdownString.drive { [weak self] in
            guard let self = self else { return }
            markdownView.rootView = .init(content: $0)
        }.disposed(by: disposeBag)

        viewModel.hasContent.drive(placeholderView.rx.isHidden).disposed(by: disposeBag)

        viewModel.isPlaceholder.drive(markdownView.rx.isHidden).disposed(by: disposeBag)
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        markdownView.frame = view.bounds
        placeholderView.frame = view.bounds
    }
}

struct PlaceholderView: View {
    var body: some View {
        Text("No Markdown")
            .font(.largeTitle)
    }
}

struct MarkdownView: View {
    let content: String
    var body: some View {
        ScrollView {
            Markdown(content)
                .markdownTheme(.docC)
                .markdownCodeSyntaxHighlighter(.splash(theme: .wwdc17(withFont: .init(size: 13))))
                .padding(20)
        }
    }

    init(content: String) {
        self.content = content
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(content: try! String(contentsOfFile: "/Users/JH/Desktop/4. 红黑树.md"))
    }
}
