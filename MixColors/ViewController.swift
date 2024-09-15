//
//  ViewController.swift
//  MixColors
//
//  Created by Alexander Bokhulenkov on 10.09.2024.
//

import UIKit


final class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let nameApp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let leftColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let blendColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let vStackLeft: UIStackView = {
        let stack = UIStackView()
         stack.axis = .vertical
         stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
         return stack
    }()
    
    private let vStackRight: UIStackView = {
        let stack = UIStackView()
         stack.axis = .vertical
         stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
         return stack
    }()
    
    // MARK: - Private Storeg Properties
    
    private var selecteView: UIView!
    private var leftColor: UIColor { leftColorView.backgroundColor ?? .yellow }
    private var rightColor: UIColor { rightColorView.backgroundColor ?? .red }
    private var mixColor: UIColor!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        leftLabel.text = leftColor.accessibilityName
        rightLabel.text = rightColor.accessibilityName
       resultLabel.text = blendColorView.backgroundColor?.accessibilityName
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        setView()
        setConstraints()
        
        let tapGRLeft = UITapGestureRecognizer(target: self, action: #selector(selectedLeft))
        let tapGRRight = UITapGestureRecognizer(target: self, action: #selector(selectedRight))
        leftColorView.addGestureRecognizer(tapGRLeft)
        rightColorView.addGestureRecognizer(tapGRRight)
    }
    
    private func setView() {
        view.backgroundColor = .white
        nameApp.text = "MixColor"
        
        view.addSubview(nameApp)
        view.addSubview(hStack)
        view.addSubview(resultLabel)
        view.addSubview(blendColorView)
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        [
            rightLabel,
            rightColorView
        ].forEach { vStackLeft.addArrangedSubview($0) }
        
        [
            leftLabel,
            leftColorView
        ].forEach { vStackRight.addArrangedSubview($0) }
        
        
        leftColorView.backgroundColor = leftColor
        rightColorView.backgroundColor = rightColor

        blendColorView.backgroundColor = blendedColor(rightColor, with: leftColor)
        
    }
    
    private func openColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Select color"
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        self.present(colorPicker, animated: true)
    }
    
    private func blendedColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        // складываем цвет и проверяем чтобы сумма была не больше макс значения 1
        return UIColor(red: min(r1 + r2, 1.0), green: min(g1 + g2, 1.0), blue: min(b1 + b2, 1.0), alpha: (a1 + a2) / 2)
    }
    
    private func changeColor(select view: UIView!, to color: UIColor) {
        
        leftColorView.id = "left"
        rightColorView.id = "right"
        
        if view.view(withId: "left") != nil {
            leftColorView.backgroundColor = color
            leftLabel.text = color.accessibilityName
        } else if view.view(withId: "right") != nil {
            rightColorView.backgroundColor = color
            rightLabel.text = color.accessibilityName
        }
        
        mixColor = blendedColor(leftColor, with: rightColor)
        blendColorView.backgroundColor = mixColor
        resultLabel.text = mixColor.accessibilityName
    }
    
    // MARK: - Actions
    
    @objc private func selectedLeft() {
        selecteView = leftColorView
        openColorPicker()
    }
    
    @objc private func selectedRight() {
        selecteView = rightColorView
        openColorPicker()
    }
}

// MARK: - Extensions Settings Constraints

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            nameApp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameApp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hStack.topAnchor.constraint(equalTo: nameApp.bottomAnchor, constant: 40),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            leftColorView.heightAnchor.constraint(equalToConstant: 150),
            rightColorView.heightAnchor.constraint(equalToConstant: 150),
            
            resultLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blendColorView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10),
            blendColorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            blendColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blendColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
    }
}

// MARK: - Extensions ColorPicker Delegate

extension ViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        changeColor(select: selecteView, to: color)
    }
}


