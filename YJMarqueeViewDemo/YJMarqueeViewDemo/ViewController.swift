//
//  ViewController.swift
//  YJMarqueeViewDemo
//
//  Created by symbio on 2021/4/14.
//

import UIKit
import YJMarqueeView
import YJCycleCollectionView

class ViewController: UIViewController {

    lazy var controlView1: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    lazy var controlView2: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    lazy var controlView3: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    lazy var controlView4: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    lazy var controlView5: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.isAutoScroll = true
        view.delegate = self
        view.contentSpacing = 0
        view.register(nib: UINib(nibName: "YJMarqueeTestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YJMarqueeTestCollectionViewCell")
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    lazy var controlView6: YJMarqueeTextView = {
        let view = YJMarqueeTextView()
        view.backgroundColor = .orange
        view.didSelectItemBlock = { (index: Int) in
            print(index)
        }
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlView1.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 50)
        controlView2.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 50)
        controlView3.frame = CGRect(x: 0, y: 300, width: view.bounds.width, height: 50)
        controlView4.frame = CGRect(x: 0, y: 400, width: view.bounds.width, height: 50)
        controlView5.frame = CGRect(x: 0, y: 500, width: view.bounds.width, height: 50)
        controlView6.frame = CGRect(x: 0, y: 560, width: view.bounds.width, height: 50)
        
        let string = "我是跑马灯，我只能不停的滚动才能体现我的价值！请注意，前方高能；呃、其实啥也没有~~~"
        
        let attrStr = NSMutableAttributedString(string: string)
        attrStr.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 5, length: 9))
        attrStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 18, length: 8))
        attrStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 18, length: 8))
        attrStr.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: 30, length: 6))
        
        controlView1.textList = [string, string]
        controlView2.attributedTextList = [attrStr, attrStr]
        controlView3.attributedTextList = [attrStr, attrStr]
        controlView4.attributedTextList = [attrStr, attrStr]
        controlView6.attributedTextList = [attrStr, attrStr]
        
        controlView1.scrollDirection = .vertical
        controlView2.scrollDirection = .verticalPage
        controlView3.scrollDirection = .horizontal
        controlView4.scrollDirection = .horizontal
        controlView4.scrollSpeed = -60
        controlView5.scrollDirection = .horizontal
        controlView6.scrollDirection = .horizontalPage
    }
}

extension ViewController: YJCycleCollectionViewDelegate {
    func collectionView(_ collectionView: YJCycleCollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: YJCycleCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YJMarqueeTestCollectionViewCell", forIndexPath: indexPath) as! YJMarqueeTestCollectionViewCell
        cell.imageView.image = UIImage(named: "bannerLocalImage")
        cell.imageView.contentMode = .scaleToFill
        return cell
    }
}

