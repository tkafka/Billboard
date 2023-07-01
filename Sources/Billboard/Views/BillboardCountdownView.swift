//
//  BillboardCountdownView.swift
//
//
//  Created by Hidde van der Ploeg on 01/07/2023.
//

import SwiftUI

struct BillboardCountdownView : View {
    
    let advert : BillboardAd
    let totalDuration : TimeInterval
    @Binding var canDismiss : Bool
    
    
    @State private var seconds : Int = 15
    @State private var counterLabel : Int = 15
    @State private var timerProgress : CGFloat = 0.0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(advert.tint.opacity(0.2), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            Circle()
                .trim(from: 0, to: timerProgress)
                .stroke(advert.tint, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            Text("\(counterLabel)")
                .font(.system(.caption, design: .rounded).monospacedDigit().weight(.bold))
                .rotationEffect(.degrees(90))
        }
        .foregroundColor(advert.tint)
        .rotationEffect(.degrees(-90))
        .frame(width: 32, height: 32)
        .onAppear {
            seconds = Int(totalDuration)
            withAnimation(.linear(duration: totalDuration)) {
                timerProgress = 1.0
            }
        }
        .onReceive(timer) { _ in
            if seconds > 0 {
                seconds -= 1
            }
        }
        .onChange(of: seconds) { _ in
            if seconds < 1 {
                canDismiss = true
            } else {
                counterLabel = seconds
            }
        }
        .onTapGesture {
            #if DEBUG
            canDismiss = true
            #endif
        }
    }
}


struct BillboardCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        BillboardCountdownView(advert: BillboardSamples.sampleDefaultAd, totalDuration: 15.0, canDismiss: .constant(false))
    }
}