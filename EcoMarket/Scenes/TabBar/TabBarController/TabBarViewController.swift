//
//  TabBarViewController.swift
//  EcoMarket
//
//  Created by Ahmed Yamany on 11/01/2024.
//

import UIKit
import MakeConstraints
import Combine

enum TabBarType: String, CaseIterable, Hashable {
    case home, cart, notification, profile
    
    var viewController: UIViewController {
       UIViewController()
    }
    
    var icon: UIImage? {
        switch self {
            case .home: UIImage(named: "tabbar-home")?.withRenderingMode(.alwaysOriginal)
            case .cart: UIImage(named: "tabbar-cart")?.withRenderingMode(.alwaysOriginal)
            default: nil
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
            case .home: UIImage(named: "tabbar-home-selected")?.withRenderingMode(.alwaysOriginal)
            case .cart: UIImage(named: "tabbar-cart-selected")?.withRenderingMode(.alwaysOriginal)
            default: nil
        }
    }
}

class TabBarViewModel: ObservableObject {
    static let shared = TabBarViewModel()
    @Published var selectedTab: TabBarType = .home
}

class TabBarViewController: UITabBarController {
    let customTabBar = CustomTabBar()
    
    let viewModel = TabBarViewModel.shared
    
    var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabBarType.allCases.map { $0.viewController }
        tabBar.isHidden = true
        view.addSubview(customTabBar)
        customTabBar.fillXSuperView()
        customTabBar.makeConstraints(bottomAnchor: view.bottomAnchor)
        
        viewModel.$selectedTab.sink { type in
            for item in self.customTabBar.items {
                if item.type == type {
                    item.select()
                } else {
                    item.unSelect()
                }
            }
        }
        .store(in: &cancellableSet)
        
    }
}

class CustomTabBar: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    var items: [CustomTabBarItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        heightConstraints(46 + (UIApplication.shared.mainWindow?.safeAreaInsets.bottom ?? 20))
        layer.cornerRadius = 12
        addTabsToStackView()
    }
    
    private func addTabsToStackView() {
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 0,
                                                      left: 24,
                                                      bottom: (UIApplication.shared.mainWindow?.safeAreaInsets.bottom ?? 0) / 2,
                                                      right: 24))
        for type in TabBarType.allCases {
            let tab = CustomTabBarItem(type: type)
            stackView.addArrangedSubview(tab)
            items.append(tab)
        }

    }
    
}

class CustomTabBarItem: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    let label = UILabel()
    let iconView = UIView()
    let iconImage = UIImageView()
    
    private var widthConstraint: NSLayoutConstraint?
    private let _height: CGFloat = 30
    private let _width: CGFloat = 76
    
    let type: TabBarType
    init(type: TabBarType) {
        self.type = type
        super.init(frame: .zero)
        setup()
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        heightConstraints(_height)
        widthConstraint = widthConstraints(_width)
        iconImage.contentMode = .scaleToFill
        backgroundColor = .white
        layer.cornerRadius = _height / 2
        //
        addSubview(stackView)
        stackView.fillSuperview()
        addIcon()
        addLabel()
    }
    
    private func addIcon() {
        iconView.backgroundColor = .black
        stackView.addArrangedSubview(iconView)
        iconView.equalSizeConstraints(_height)
        iconView.layer.cornerRadius = _width - (_height * 2)
        iconView.addSubview(iconImage)
        iconImage.centerInSuperview(size: .init(width: 14, height: 14))
        
    }
    
    private func addLabel() {
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = type.rawValue
        stackView.addArrangedSubview(label)
        label.textAlignment = .center
    }
    
    public func select() {
        widthConstraint?.constant = _width
        iconView.tintColor = .white
        iconView.backgroundColor = .black
        iconImage.image = type.selectedIcon
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    public func unSelect() {
        widthConstraint?.constant = _height
        iconView.tintColor = .black
        iconView.backgroundColor = .white
        iconImage.image = type.icon
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }
}
