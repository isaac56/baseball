//
//  MatchView.swift
//  BaseballApp
//
//  Created by Song on 2021/05/04.
//

import UIKit

class GroundView: UIView {
    enum Constants {
        enum InfieldSquare {
            static let lineWidth: CGFloat = 5.0
            static let padding: CGFloat = 50.0
        }
        enum HomePlate {
            static let topTriangleHeight: CGFloat = 15.0
            static let bottomSquareLength: CGFloat = 30.0
        }
        enum Base {
            static let lineWidth: CGFloat = 1.0
            static let diagonalLength: CGFloat = 30.0
        }
        enum Runner {
            static let lineWidth: CGFloat = 1.0
            static let diameter: CGFloat = 25.0
        }
    }
    
    private let infieldSquareLayer = CAShapeLayer()
    private let homePlateLayer = CAShapeLayer()
    private var firstBaseLayer = CAShapeLayer()
    private var secondBaseLayer = CAShapeLayer()
    private var thirdBaseLayer = CAShapeLayer()
    private let runnerLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        self.backgroundColor = .systemGray3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureInfieldSquareLayer()
        configureHomePlateLayer()
        configureLayerForBases()
        configureRunnerLayer()
    }
    
    private func configureInfieldSquareLayer() {
        infieldSquareLayer.frame = CGRect(x: bounds.minX + Constants.InfieldSquare.padding,
                                          y: bounds.minY + Constants.InfieldSquare.padding,
                                          width: bounds.width - (Constants.InfieldSquare.padding * 2),
                                          height: bounds.height - (Constants.InfieldSquare.padding * 2))
        layer.addSublayer(infieldSquareLayer)
        infieldSquareLayer.strokeColor = UIColor.systemGray.cgColor
        infieldSquareLayer.fillColor = UIColor.clear.cgColor
        infieldSquareLayer.lineWidth = Constants.InfieldSquare.lineWidth
        
        infieldSquareLayer.path = createRhombusPath(for: infieldSquareLayer)
    }
    
    private func configureHomePlateLayer() {
        homePlateLayer.frame = CGRect(x: bounds.midX - Constants.HomePlate.bottomSquareLength / 2,
                                      y: bounds.maxY - (Constants.InfieldSquare.padding / 2) - Constants.HomePlate.topTriangleHeight - Constants.HomePlate.bottomSquareLength,
                                      width: Constants.HomePlate.bottomSquareLength,
                                      height: Constants.HomePlate.topTriangleHeight + Constants.HomePlate.bottomSquareLength)
        layer.addSublayer(homePlateLayer)
        homePlateLayer.fillColor = UIColor.white.cgColor
        
        homePlateLayer.path = createPlatePath(for: homePlateLayer)
    }
    
    private func configureLayerForBases() {
        firstBaseLayer = createBaseLayer(origin: CGPoint(x: bounds.maxX - Constants.InfieldSquare.padding - Constants.Base.diagonalLength / 2,
                                                         y: bounds.midY - Constants.Base.diagonalLength / 2))
        secondBaseLayer = createBaseLayer(origin: CGPoint(x: bounds.midX - Constants.Base.diagonalLength / 2,
                                                          y: bounds.minY + Constants.InfieldSquare.padding - Constants.Base.diagonalLength / 2))
        thirdBaseLayer = createBaseLayer(origin: CGPoint(x: bounds.minX + Constants.InfieldSquare.padding - Constants.Base.diagonalLength / 2,
                                                         y: bounds.midY - Constants.Base.diagonalLength / 2))
        
        firstBaseLayer.path = createRhombusPath(for: firstBaseLayer)
        secondBaseLayer.path = createRhombusPath(for: secondBaseLayer)
        thirdBaseLayer.path = createRhombusPath(for: thirdBaseLayer)
    }
    
    private func configureRunnerLayer() {
        runnerLayer.frame = CGRect(x: bounds.midX - Constants.Runner.diameter / 2,
                                   y: bounds.maxY - Constants.InfieldSquare.padding - (Constants.Runner.diameter / 2),
                                   width: Constants.Runner.diameter,
                                   height: Constants.Runner.diameter)
        layer.addSublayer(runnerLayer)
        runnerLayer.strokeColor = UIColor.systemGray.cgColor
        runnerLayer.fillColor = UIColor.systemOrange.cgColor
        runnerLayer.lineWidth = Constants.Runner.lineWidth
        let circlePath = UIBezierPath(ovalIn: CGRect(x: runnerLayer.bounds.minX,
                                                     y: runnerLayer.bounds.minY,
                                                     width: runnerLayer.bounds.width,
                                                     height: runnerLayer.bounds.height))
        runnerLayer.path = circlePath.cgPath
    }
    
    private func createRhombusPath(for layer: CAShapeLayer) -> CGPath {
        let rhombusPath = UIBezierPath()
        rhombusPath.move(to: CGPoint(x: baseLayer.bounds.midX, y: baseLayer.bounds.maxY))
        rhombusPath.addLine(to: CGPoint(x: baseLayer.bounds.minX, y: baseLayer.bounds.midY))
        rhombusPath.addLine(to: CGPoint(x: baseLayer.bounds.midX, y: baseLayer.bounds.minY))
        rhombusPath.addLine(to: CGPoint(x: baseLayer.bounds.maxX, y: baseLayer.bounds.midY))
        rhombusPath.close()
        return rhombusPath.cgPath
    }
    
    private func createPlatePath(for baseLayer: CAShapeLayer) -> CGPath {
        let platePath = UIBezierPath()
        platePath.move(to: CGPoint(x: baseLayer.bounds.midX,
                                   y: baseLayer.bounds.minY))
        platePath.addLine(to: CGPoint(x: baseLayer.bounds.minX,
                                      y: baseLayer.bounds.minY + Constants.HomePlate.topTriangleHeight))
        platePath.addLine(to: CGPoint(x: baseLayer.bounds.minX,
                                      y: baseLayer.bounds.minY + Constants.HomePlate.topTriangleHeight + Constants.HomePlate.bottomSquareLength))
        platePath.addLine(to: CGPoint(x: baseLayer.bounds.midX + Constants.HomePlate.bottomSquareLength / 2,
                                      y: baseLayer.bounds.minY + Constants.HomePlate.topTriangleHeight + Constants.HomePlate.bottomSquareLength))
        platePath.addLine(to: CGPoint(x: baseLayer.bounds.midX + Constants.HomePlate.bottomSquareLength / 2,
                                      y: baseLayer.bounds.minY + Constants.HomePlate.topTriangleHeight))
        platePath.close()
        return platePath.cgPath
    }
    
    private func createBaseLayer(origin: CGPoint) -> CAShapeLayer {
        let baseLayer = CAShapeLayer()
        baseLayer.frame = CGRect(origin: origin,
                                 size: CGSize(width: Constants.Base.diagonalLength,
                                              height: Constants.Base.diagonalLength))
        layer.addSublayer(baseLayer)
        baseLayer.strokeColor = UIColor.systemGray.cgColor
        baseLayer.fillColor = UIColor.white.cgColor
        baseLayer.lineWidth = Constants.Base.lineWidth
        return baseLayer
    }
    
    @IBAction func pitchButtonPressed(_ sender: UIButton) {
        let homePlatePosition = CGPoint(x: bounds.midX, y: bounds.maxY - Constants.InfieldSquare.padding)
        let firstBasePosition = CGPoint(x: bounds.maxX - Constants.InfieldSquare.padding, y: bounds.midY)
        let secondBasePosition = CGPoint(x: bounds.midX, y: bounds.minY + Constants.InfieldSquare.padding)
        let thirdBasePosition = CGPoint(x: bounds.minX + Constants.InfieldSquare.padding, y: bounds.midY)
        
        let initialPosition: CGPoint = runnerLayer.position
        var finalPosition: CGPoint = CGPoint(x: 0.0, y: 0.0)
        
        switch runnerLayer.position {
        case homePlatePosition:
            finalPosition = firstBasePosition
        case firstBasePosition:
            finalPosition = secondBasePosition
        case secondBasePosition:
            finalPosition = thirdBasePosition
        case thirdBasePosition:
            finalPosition = homePlatePosition
        default:
            break
        }
        
        runnerLayer.position = finalPosition
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animation.fromValue = initialPosition
        animation.toValue = finalPosition
        runnerLayer.animation(forKey: "move")
    }
}
