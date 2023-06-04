//
//  CodeBlockViewModel.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit
import RxSwift
import RxCocoa

class CodeBlockViewModel: ViewModel, ViewModelType {
    struct Input {
        let changeFormatter: Observable<String?>
        let selectFormatterConfigFile: Observable<Void>
        let commit: Observable<Void>
    }

    struct Output {
        let selectedConfigFileURL: Observable<URL?>
    }

    let supportedLanguages = Observable.just(CodeBlockModels.SupportedLanguage.allCases)

    let supportedFormatters = Observable.just(CodeBlockModels.SupportedFormatter.allCases)

    var supportedLanguageStrings: Driver<[String]> { supportedLanguages.map { $0.map(\.rawValue) }.asDriver(onErrorJustReturn: []) }

    var supportedFormatterStrings: Driver<[String]> { supportedFormatters.map { $0.map(\.rawValue) }.asDriver(onErrorJustReturn: []) }

    var selectedFormatter: CodeBlockModels.SupportedFormatter?

    var configurationFileURL: URL?

    func transform(_ input: Input) -> Output {
        input.changeFormatter
            .compactMap {
                CodeBlockModels.SupportedFormatter(rawValue: $0 ?? "")
            }
            .subscribe(with: self) { target, selectedFormatter in
                target.selectedFormatter = selectedFormatter
            }
            .disposed(by: disposeBag)

        let selectedConfigFileURL = input.selectFormatterConfigFile
            .flatMap { [weak self] _ -> Observable<URL?> in
                guard let self = self, let selectedFormatter = self.selectedFormatter else { return .just(nil) }
                return NSOpenPanel().then {
                    $0.allowedContentTypes = [selectedFormatter.contentType]
                    $0.allowsMultipleSelection = false
                    $0.canChooseFiles = true
                    $0.canChooseDirectories = false
                }.rx.begin()
                    .filter { $0.result == .OK }
                    .map {
                        let url = $0.panel.url
                        self.configurationFileURL = url
                        return url
                    }
            }

        input.commit
            .withLatestFrom(provider.openedMarkdownFile.compactMap { $0 }.asObservable())
            .subscribe(with: self) { target, url in
                guard let selectedFormatter = target.selectedFormatter,
                      let commitedMarkdownString = CodeBlockModels.Committer(url: url, configuration: target.configurationFileURL, formatter: selectedFormatter).commit()
                else { return }

                target.provider.commitedMarkdownString.on(.next(commitedMarkdownString))
            }.disposed(by: disposeBag)

//        let supportedLanguages = Observable.just(CodeBlockModels.SupportedLanguage.allCases)
//        let supportedFormatters = Observable.just(CodeBlockModels.SupportedFormatter.allCases)
        return Output(
            //            supportedLanguages: supportedLanguages,
//            supportedFormatters: supportedFormatters,
            selectedConfigFileURL: selectedConfigFileURL
        )
    }
}
