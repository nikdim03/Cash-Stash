//
//  StateManager.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/31/22.
//

import UIKit

protocol StateApplicable {
    associatedtype State
    func apply(state: State)
}

protocol ErrorPresentable: UIView {
    var errorText: String? { get set }
}

struct StateManager {
    enum State: Equatable {
        case noData
        case loading
        case loaded
        case error(String)
    }
    
    var state: State = .noData {
        willSet {
            self.apply(state: newValue)
        }
    }
    
    var rootView: UIView
    var emptyView: UIView
    var loadingView: UIView
    var loadedView: UIView
    var errorView: ErrorPresentable?
//    var errorView: ErrorPresentable
    
    init(
        rootView: UIView,
        emptyView: UIView = UIView(),
        loadingView: UIView = UIView(),
//        loadingView: UIView = LoadingView(),
        loadedView: UIView,
        errorView: UIView = UIView()
//        errorView: ErrorPresentable = ErrorView()
    ) {
        self.rootView = rootView
        self.emptyView = emptyView
        self.loadingView = loadingView
        self.loadedView = loadedView
//        self.errorView = errorView
        
        self.state = .noData
    }
    
    func hideAllViews() {
        emptyView.isHidden = true
        loadingView.isHidden = true
        loadedView.isHidden = true
        errorView!.isHidden = true
//        errorView.isHidden = true
    }
    
    func addViewAndBringToFront(_ view: UIView) {
        view.frame = rootView.bounds
        if !rootView.subviews.contains(view) {
            rootView.addSubview(view)
        }
        view.isHidden = false
    }
}

//MARK: - StateApplicable
extension StateManager: StateApplicable {
    func apply(state: State) {
        switch state {
        case .noData:
            hideAllViews()
            addViewAndBringToFront(emptyView)
        case .loading:
            guard self.state == .noData else { return }
            hideAllViews()
            addViewAndBringToFront(loadingView)
        case .loaded:
            hideAllViews()
            addViewAndBringToFront(loadedView)
        case .error(let error):
            hideAllViews()
            addViewAndBringToFront(errorView!)
            errorView!.errorText = error
//            addViewAndBringToFront(errorView)
//            errorView.errorText = error
        }
    }
}
