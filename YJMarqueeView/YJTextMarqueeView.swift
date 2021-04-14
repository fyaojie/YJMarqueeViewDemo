//
//  YJMarqueeTextView.swift
//  swiftTest
//
//  Created by love on 2020/9/9.
//  Copyright © 2020 symbio. All rights reserved.
//

import UIKit
import Masonry
import YJCycleCollectionView

/// 线性控制的方向
@objc public enum YJMarqueeScrollDirection : Int {
    /// 垂直
    case vertical = 0
    /// 水平
    case horizontal = 1
    /// 垂直分页
    case verticalPage = 2
    /// 水平分页
    case horizontalPage = 3
    /// 滚动方向
    func value() -> UICollectionView.ScrollDirection {
        switch self {
        case .vertical, .verticalPage:
            return .vertical
        default:
            return .horizontal
        }
    }
    
    /// 滚动模式，分页还是匀速
    func scrollType() -> YJCycleScrollType {
        switch self {
        case .verticalPage, .horizontalPage:
            return .page
        default:
            return .constantSpeed
        }
    }
}

/// 线性控制视图，跑马灯效果
public class YJMarqueeTextView: UIView {

    /// 内容间距
    @objc public var contentSpacing: CGFloat = 20 {
        didSet {
            collectionView.minimumLineSpacing = contentSpacing
        }
    }
    
    /// 滚动模式下生效，滚动速度,每秒所滚动的单位
    @objc public var scrollSpeed: CGFloat = 60 {
        didSet {
            collectionView.scrollSpeed = scrollSpeed
        }
    }
    
    /** 是否自动滚动 */
    @objc public var isAutoScroll: Bool = true {
        didSet {
            collectionView.isAutoScroll = isAutoScroll
        }
    }
    
    /// 监听点击
    @objc public var didSelectItemBlock: ((_ currentIndex: Int) -> (Void))? {
        didSet {
            collectionView.didSelectItemBlock = self.didSelectItemBlock
        }
    }
    
    /// 滑动方向
    @objc public var scrollDirection : YJMarqueeScrollDirection = .horizontal {
        didSet {
            collectionView.scrollDirection = scrollDirection.value()
            collectionView.scrollType = scrollDirection.scrollType()
            collectionView.isPagingEnabled = true
        }
    }
    
    /// 自定义cell设置
    @objc weak open var delegate: YJCycleCollectionViewDelegate? {
        didSet {
            collectionView.delegate = delegate
            collectionView.reloadData()
        }
    }
    
    @objc open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    @objc open func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib: nib, forCellWithReuseIdentifier: identifier)
    }

    /// 默认字体
    @objc public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 跑马灯文本数据源
    @objc public var textList: [String]? {
        didSet {
            if attributedTextList != nil { attributedTextList = nil }
            calculateItemSize()
            collectionView.reloadData()
        }
    }
    /// 跑马灯属性字符串数据源
    @objc public var attributedTextList: [NSAttributedString]? {
        didSet {
            if textList != nil { textList = nil }
            calculateItemSize()
            collectionView.reloadData()
        }
    }

    /// 记录item大小
    fileprivate var itemSizes: [String: CGSize] = [:]

    fileprivate lazy var collectionView: YJCycleCollectionView = {
        let collectionView = YJCycleCollectionView()
        collectionView.scrollType = scrollDirection.scrollType()
        collectionView.scrollDirection = scrollDirection.value()
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.minimumLineSpacing = contentSpacing
        collectionView.isAutoScroll = isAutoScroll
        collectionView.isEnabledPanGestureRecognizer = false
        collectionView.register(YJMarqueeTextCollectionViewCell.self, forCellWithReuseIdentifier: YJMarqueeTextCollectionViewCell.description())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension YJMarqueeTextView: YJCycleCollectionViewDelegate {
    public func collectionView(_ collectionView: YJCycleCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (textList?.count ?? 0) + (attributedTextList?.count ?? 0)
    }
    
    public func collectionView(_ collectionView: YJCycleCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YJMarqueeTextCollectionViewCell.description(), forIndexPath: indexPath) as! YJMarqueeTextCollectionViewCell
        cell.textLabel.font = font
        if let textList = textList {
            cell.textLabel.text = textList[indexPath.row]
        } else if let attributedTextList = attributedTextList {
            if attributedTextList.count > indexPath.row {
                cell.textLabel.attributedText = attributedTextList[indexPath.row];
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: YJCycleCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var key: String?
        if let textList = textList {
            key = textList[indexPath.row].key
        } else if let attributedTextList = attributedTextList {
            key = attributedTextList[indexPath.row].key
        }
        if let key = key, let value = itemSizes[key] {
            return fix(value)
        }
        return .zero
    }
}

extension YJMarqueeTextView {
    func setupUI() {
        addSubview(collectionView)
        collectionView.mas_makeConstraints {
            $0?.left.right()?.top()?.bottom()?.equalTo()
        }
    }
    
    /// 计算文字真实大小
    func calculate(_ value: NSAttributedString) -> CGSize {
        let label = UILabel()
        label.font = font
        label.attributedText = value
        label.sizeToFit()
        return label.bounds.size
    }
    
    func calculate(_ value: String) -> CGSize {
        let label = UILabel()
        label.font = font
        label.text = value
        label.sizeToFit()
        return label.bounds.size
    }
    

    /// 记录水平滚动时的item
    func calculateItemSize() {
        itemSizes.removeAll()
        
        if let textList = textList {
            for data in textList {
                itemSizes[data.key] = calculate(data)
            }
        } else if let attributedTextList = attributedTextList {
            for data in attributedTextList {
                itemSizes[data.key] = calculate(data)
            }
        }
    }
    
    /// 修正itemsize
    func fix(_ itemSize: CGSize) -> CGSize {
        if bounds.height <= 0 || bounds.width <= 0 { return itemSize }
        if scrollDirection == .horizontal || scrollDirection == .horizontalPage {
            var size = itemSize
            size.width = max(bounds.width, size.width)
            size.height = bounds.height
            return size
        }
        return bounds.size
    }
}

extension NSObject {
    var key: String { /*return String(format: "%p", self)*/ return self.description }
}

class YJMarqueeTextCollectionViewCell: UICollectionViewCell {

    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(textLabel)
        textLabel.mas_makeConstraints {
            $0?.left.right()?.top()?.bottom()?.equalTo()
        }
    }
}
