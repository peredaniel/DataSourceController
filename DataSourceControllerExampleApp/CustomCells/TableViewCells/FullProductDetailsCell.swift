//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import UIKit

class FullProductDetailsCell: UITableViewCell {
    @IBOutlet private var productImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var additionalInfoTextView: UITextView!

    static func register(in tableView: UITableView) {
        let nib = UINib(nibName: "FullProductDetailsCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "FullProductDetailsCell")
    }

    func configure(controller: FullProductDetailsCellDataController) {
        let image = UIImage(named: controller.imageName)
        productImage.image = image
        nameLabel.text = controller.productName
        priceLabel.isHidden = controller.productPrice == nil
        priceLabel.text = controller.productPrice
        additionalInfoTextView.attributedText = attributedText(
            overview: controller.productOverview,
            variants: controller.productVariants
        )
    }
}

private extension FullProductDetailsCell {
    func attributedText(
        overview: String,
        variants: [DisplayableVariant]
    ) -> NSAttributedString {
        let fontSize = additionalInfoTextView.font?.pointSize ?? 14.0
        let regularFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)

        let finalAttributedString = NSMutableAttributedString()

        let overviewAttributed = NSAttributedString(string: overview + "\n", attributes: [.font: regularFont])

        let variantsAttributed = NSMutableAttributedString()
        for variant in variants {
            let nameAttributed = NSAttributedString(string: variant.name + ": ", attributes: [.font: boldFont])
            let optionAttributed: NSAttributedString
            if let last = variants.last, variant != last {
                optionAttributed = NSAttributedString(string: variant.options + "\n", attributes: [.font: regularFont])
            } else {
                optionAttributed = NSAttributedString(string: variant.options, attributes: [.font: regularFont])
            }
            variantsAttributed.append(nameAttributed)
            variantsAttributed.append(optionAttributed)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 8.0

        finalAttributedString.append(overviewAttributed)
        finalAttributedString.append(variantsAttributed)
        finalAttributedString.addAttributes(
            [.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: finalAttributedString.length)
        )
        return finalAttributedString
    }
}
