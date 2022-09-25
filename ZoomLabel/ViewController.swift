//
//  ViewController.swift
//  ZoomLabel
//
//  Created by Syed Muhammad Muzzamil on 19/09/2022.
//

import UIKit

let sampleText =
"""
Pakistan officially the Islamic Republic of Pakistan is a country in South Asia. It is the world's fifth-most populous country, with a population of almost 242 million, and has the world's second-largest Muslim population. Pakistan is the 33rd-largest country by area, spanning 881,913 square kilometres (340,509 square miles). It has a 1,046-kilometre (650-mile) coastline along the Arabian Sea and Gulf of Oman in the south, and is bordered by India to the east, Afghanistan to the west, Iran to the southwest, and China to the northeast. It is separated narrowly from Tajikistan by Afghanistan's Wakhan Corridor in the north, and also shares a maritime border with Oman. Pakistan is a regional and middle power nation and has the world's sixth-largest standing armed forces.
""".split(separator: ".")

class ViewController: UIViewController {

    @IBOutlet weak var zoomLabelView: UIView!
    var zoomLabel: ZoomLabel!
    var index: Int = 0
    
    deinit {
        print("ViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let text = String(sampleText[0]+".")
        create(text: text)
    }
    
    
    func create(text: String){
        if zoomLabel != nil {return}
        zoomLabel = ZoomLabel()
        var config = ZoomLabel.Config()
        config.textFont = UIFont.systemFont(ofSize: 25)
        config.constrainedWidth = self.zoomLabelView.bounds.width
        zoomLabel.config = config
        zoomLabel.create(inView: self.zoomLabelView, withText: text)
    }
    
    func update(){
        if !sampleText.indices.contains(self.index) {return}
        let text = sampleText[...self.index].joined(separator: ".") + "."
        self.zoomLabel.update(inView: self.zoomLabelView, withText: text)
    }

    @IBAction func removeButtonTapped(_ sender: Any) {
        if self.index == 0 {return}
        self.index -= 1
        self.update()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if self.index == (sampleText.count - 1) {return}
        self.index += 1
        self.update()
    }
    
}
