//
//  SearchTermCell.swift
//  UI
//
//  Created by Jmy on 2021/10/24.
//

import UIKit

final class SearchTermCell: BaseCollectionViewCell {
    // MARK: - Constants

    static let itemHeight: CGFloat = 44

    // MARK: - Views

    private lazy var rankTermLabel = UILabel.makeForSubtitle()

    // MARK: - Methods

    override func setupViews() {
        contentView.add(
            rankTermLabel,
            center: contentView
        )
    }

    func bind(rank: Int, term: String) {
        rankTermLabel.text = "\(rank). \(term)"
    }
}