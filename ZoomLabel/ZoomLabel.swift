//
//  ZoomLabel.swift
//  ZoomLabel
//
//  Created by Syed Muhammad Muzzamil on 16/09/2022.
//

import UIKit

final class ZoomLabel {
    var config = Config()
    private var zoomLabelView: ZoomLabelView?
    deinit {
        print("ZoomLabel deinit")
    }
}

extension ZoomLabel {
    func create(inView parentView: UIView, withText text: String) {
        if zoomLabelView != nil {return}
        zoomLabelView = Create.zoomLabelView(text: text, config: config)
        add(parentView: parentView)
        Origin.set(zoomLabelView!, center: parentView.center)
    }
    func update(inView parentView: UIView, withText text: String) {
        defer {
            removeFromSuperview()
            create(inView: parentView, withText: text)
        }
        guard zoomLabelView != nil else {return}
        config.zoomScale = View.scaleOf(zoomLabelView!)
    }
}

private extension ZoomLabel {
    private func add(parentView: UIView) {
        guard zoomLabelView != nil else {return}
        Add.view(zoomLabelView!, parentView: parentView)
    }
    private func removeFromSuperview() {
        zoomLabelView?.removeFromSuperview()
        zoomLabelView = nil
    }
}

extension ZoomLabel {
    struct Config {
        var textFont = UIFont.systemFont(ofSize: 50)
        var textColor = UIColor.white
        var textBackgroundColor = UIColor.clear
        var constrainedWidth: Double = 100
        var zoomScale: CGFloat = 1
    }
}

fileprivate struct Create {
    static fileprivate func zoomLabelView(text: String, config: ZoomLabel.Config = ZoomLabel.Config())-> ZoomLabelView {
        return ZoomLabelView(text: text, config: config)
    }
    static fileprivate func view(size: CGSize) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: size.width + CGFloat(1), height: size.height + CGFloat(1)))
    }
    static fileprivate func label(size: CGSize) -> UILabel {
        return UILabel(frame: CGRect(x: 0, y: 0, width: size.width + CGFloat(1), height: size.height + CGFloat(1)))
    }
}

fileprivate struct Add {
    static fileprivate func view(_ view: UIView, parentView: UIView) {
        parentView.addSubview(view)
    }
}

fileprivate struct Origin {
    static fileprivate func set(_ view: UIView, center: CGPoint) {
        view.center = center
    }
}

fileprivate protocol ZoomLabelProtocol {
    init(text: String, config: ZoomLabel.Config)
}

extension ZoomLabelView: ZoomLabelProtocol{}

fileprivate struct Setup {
    static fileprivate func label(_ label: UILabel, config: ZoomLabel.Config) {
        label.font = config.textFont
        label.textColor = config.textColor
        label.backgroundColor = config.textBackgroundColor
        label.textAlignment = .center
        label.numberOfLines = 0
    }
}

fileprivate struct GestureRecognizer {
    static fileprivate func add(target: ZoomLabelView) {
        let pinchGesture = UIPinchGestureRecognizer(target: target, action: #selector(target.pinchGesture))
        target.addGestureRecognizer(pinchGesture)
    }
}

@objc fileprivate protocol GestureRecognizerProtocol {
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer)
}

extension ZoomLabelView: GestureRecognizerProtocol {
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if !(View.scaleOf(self) > 3 && sender.scale >= 1) {
            setZoom(scale: sender.scale)
        }
        sender.scale = 1
    }
}

fileprivate struct TextSize {
    static fileprivate func of(_ text: String, config: ZoomLabel.Config) -> CGSize {
        return NSString(string: text).boundingRect(with: CGSize(width: config.constrainedWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: config.textFont], context: nil).size
    }
}

fileprivate struct View {
    static fileprivate func transform(_ view: UIView, scale: CGFloat) {
        view.transform = view.transform.scaledBy(x: scale, y: scale)
    }
    static fileprivate func scaleOf(_ view: UIView) -> CGFloat {
        let transform = view.transform
        return (transform.a + transform.d) / 2
    }
}

fileprivate struct Label {
    static fileprivate func scale(_ label: UILabel, scale: CGFloat) {
        label.layer.contentsScale = scale * 10
        label.layer.setNeedsDisplay()
    }
}

final fileprivate class ZoomLabelView: UIView {
    deinit {
        print("ZoomLabelView deinit")
    }
    private var view: UIView!
    private var label: UILabel!
    private var text: String?
    private var config: ZoomLabel.Config!
    required init(text: String, config: ZoomLabel.Config){
        self.text = text
        self.config = config
        let size = TextSize.of(text, config: config)
        super.init(frame: CGRect(origin: .zero,size: size))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let size = rect.size
        draw(size: size)
    }
}

private extension ZoomLabelView {
    private func setZoom(scale: CGFloat){
        View.transform(self, scale: scale)
        Label.scale(label, scale: scale)
    }
    private func createView(size: CGSize){
        view = Create.view(size: size)
        Add.view(view, parentView: self)
    }
    private func createLabel(size: CGSize){
        label = Create.label(size: size)
        Setup.label(label, config: config)
        Add.view(label, parentView: view)
    }
    private func setText(){
        guard label != nil else {return}
        label.text = text
    }
    private func draw(size: CGSize){
        createView(size: size)
        createLabel(size: size)
        GestureRecognizer.add(target: self)
        setZoom(scale: config.zoomScale)
        setText()
    }
}
