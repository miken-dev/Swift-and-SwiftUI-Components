//
//  ParticleEffectsView.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 5/30/20.
//


import SwiftUI

struct EmitterView: View {
	private struct ParticleView: View {
		@State private var isActive = false
		
		let image: Image
		let position: ParticleState<CGPoint>
		let opacity: ParticleState<Double>
		let rotation: ParticleState<Angle>
		let scale: ParticleState<CGFloat>
		
		var body: some View {
			image
				.opacity(isActive ? opacity.end : opacity.start)
				.scaleEffect(isActive ? scale.end : scale.start)
				.rotationEffect(isActive ? rotation.start : rotation.end)
				.position(isActive ? position.end : position.start)
				.onAppear { self.isActive = true}
		}
	}
	
	private struct ParticleState<T> {
		var start: T
		var end: T
		
		init(_ start: T, _ end: T) {
			self.start = start
			self.end = end
		}
	}
	
	var images: [String]
	
	var particleCount: Int
	
	var creationPoint = UnitPoint.center
	var creationRange = CGSize.zero
	
	var colors = [Color.white]
	var blendMode = BlendMode.normal
	
	var angle = Angle.zero
	var angleRange = Angle.zero
	
	var opacity = 1.0
	var opacityRange = 0.0
	var opacitySpeed = 0.0
	
	var rotation = Angle.zero
	var rotationRange = Angle.zero
	var rotationSpeed = Angle.zero
	
	var scale: CGFloat = 1
	var scaleRange: CGFloat = 0
	var scaleSpeed: CGFloat = 0
	
	var speed = 50.0
	var speedRange = 0.0
	
	var animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
	var animationDelayThreshold = 0.0
	
	
	
	var body: some View {
		GeometryReader { proxy in
			ZStack {
				ForEach(0..<self.particleCount, id: \.self) { _ in
					ParticleView(
						image: Image(self.images.randomElement()!),
						position: self.position(in: proxy),
						opacity: self.makeOpacity(),
						rotation: self.makeRotation(),
						scale: self.makeScale()
					)
					.animation(self.animation.delay(Double.random(in: 0...self.animationDelayThreshold)))
					.colorMultiply(self.colors.randomElement() ?? .white)
					.blendMode(self.blendMode)
				}
			}
		}
	}
	
	private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
		let halfCreationRangeWidth = creationRange.width / 2
		let halfCreationRangeHeight = creationRange.height / 2
		
		let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
		let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeHeight)
		
		let startX = Double(proxy.size.width * (creationPoint.x + creationOffsetX))
		let startY = Double(proxy.size.height * (creationPoint.y + creationOffsetY))
		let start = CGPoint(x: startX, y: startY)
		
		let halfSpeedRange = speedRange / 2
		let actualSpeed = speed + Double.random(in: -halfSpeedRange...halfSpeedRange)
		
		let halfAngleRange = angleRange.radians / 2
		let actualDirection = angle.radians + Double.random(in: -halfAngleRange...halfAngleRange)
		
		// - .pi / 2 to turn the result 90˚ to normalize x/y
		let finalX = cos(actualDirection - .pi / 2) * actualSpeed
		let finalY = sin(actualDirection - .pi / 2) * actualSpeed
		let end = CGPoint(x: startX + finalX, y: startY + finalY)
		
		return ParticleState(start, end)
		
	}
	
	private func makeOpacity() -> ParticleState<Double> {
		let halfOpacityRange = opacityRange / 2
		let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
		return ParticleState(opacity + randomOpacity, opacity + opacitySpeed + randomOpacity)
	}
	
	private func makeScale() -> ParticleState<CGFloat> {
		let halfScaleRange = scaleRange / 2
		let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
		return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
	}
	
	private func makeRotation() -> ParticleState<Angle> {
		let halfRotationRange = (rotationRange / 2).radians
		let randomRotation = Double.random(in: -halfRotationRange...halfRotationRange)
		let randomRotationAngle = Angle(radians: randomRotation)
		return ParticleState(rotation + randomRotationAngle, rotation + rotationSpeed + randomRotationAngle)
	}
}

// Example
struct ParticleEffectsView: View {
	var body: some View {
		ZStack {
			EmitterView(images: ["spark"], particleCount: 200, colors: [.red], blendMode: .screen, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.4, scaleRange: 0.1, scaleSpeed: 0.4, speedRange: 80, animation: .easeOut(duration: 1).repeatForever(autoreverses: false)).id("spark") // use id when swapping between views to avoid confusing swiftUI
			

		}
		.background(Color.black)
		.ignoresSafeArea()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


#Preview {
    ParticleEffectsView()
}
