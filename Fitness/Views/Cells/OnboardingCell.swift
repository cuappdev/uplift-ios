//
//  OnboardingCell.swift
//  Fitness
//
//  Created by Yassin Mziya on 10/3/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class OnboardingCell: UICollectionViewCell {

    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // contentView.backgroundColor = .black
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // @yassin COOL TRICK! Take note
        // contentView.backgroundColor = .red
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(214)
        }
    }
}
