import UIKit

final class MerchantNestedView: UIView {
    private let messageLabel = UILabel()
    private let button = UIButton(type: .system)

    override var intrinsicContentSize: CGSize {
        let contentWidth = bounds.width > 32 ? bounds.width - 32 : 280
        let labelHeight = messageLabel.sizeThatFits(
            CGSize(width: contentWidth, height: .greatestFiniteMagnitude)
        ).height
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: 32 + labelHeight + 12 + max(44, button.intrinsicContentSize.height)
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        messageLabel.text = "This is a custom merchant view."
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        button.setTitle("Tap me", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [messageLabel, button])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    @objc private func didTapButton() {
        messageLabel.text = "Merchant button tapped."
        invalidateIntrinsicContentSize()
    }
}
