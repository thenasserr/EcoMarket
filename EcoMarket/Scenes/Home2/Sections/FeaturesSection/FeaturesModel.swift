//
//  FeaturesModel.swift
//  EcoMarket
//
//  Created by Ibrahim Nasser Ibrahim on 17/02/2024.
//

import Foundation

struct FeaturesModel {
    let image: String
    let brandName: String
    let productName: String
    let productPrice: String
}

extension FeaturesModel {
    static let mockData: [FeaturesModel] = [
        .init(image: "shoes", brandName: "Axel Arigato", productName: "Clean 90 Triple Sneakers", productPrice: "$245.00")
    ]
}
