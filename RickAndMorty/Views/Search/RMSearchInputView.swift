//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Chingiz on 13.02.24.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

/// View for top part of search screen with search bar
final class RMSearchInputView: UIView{
    
    weak var delegate: RMSearchInputViewDelegate?
    
    private var stackView: UIStackView?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet{
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionsSelectionViews(options: options)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraints()
        
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    public func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    private func createOptionsSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]){
        let stackView = createOptionStackView()
        self.stackView = stackView
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
           
            stackView.addArrangedSubview(button)
        }
        
        
    }

    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: option.rawValue,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.label
            ]
        ),for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.tag = tag
        return button
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {return}
        
        let tag = sender.tag
        let selectedd = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selectedd)
    }
    
    private func createOptionStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        return stackView
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String){
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else {return}
        
        buttons[index].setAttributedTitle(NSAttributedString(
            string: value.uppercased(),
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.link
            ]
        ),for: .normal)
    }
}

extension RMSearchInputView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
}
