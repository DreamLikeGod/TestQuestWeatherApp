//
//  HourlyWeatherView.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

import UIKit

private extension CGFloat {
    static let itemSpacing: CGFloat = 10
    static let itemWidth: CGFloat = 60
    static let itemHeight: CGFloat = 100
    static let collectionOffsets: CGFloat = 10
    static let cornerRadius: CGFloat = 12
}

class HourlyWeatherView: UIView {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: .itemWidth, height: .itemHeight)
        layout.minimumInteritemSpacing = .itemSpacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private var hoursWeather: [Hour] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureHourlyView(_ model: [Hour]) {
        self.hoursWeather = model
        self.collectionView.reloadData()
    }
}

private extension HourlyWeatherView {
    func setupView() {
        backgroundColor = .systemBlue
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: .collectionOffsets),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .collectionOffsets),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.collectionOffsets),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.collectionOffsets)
        ])
        layer.cornerRadius = .cornerRadius
        collectionView.layer.cornerRadius = .cornerRadius
    }
}

extension HourlyWeatherView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hoursWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: hoursWeather[indexPath.item])
        return cell
    }
}
