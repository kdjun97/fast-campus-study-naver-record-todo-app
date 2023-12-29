//
 //  OnboardingView.swift
 //  RecordingTodoApp
 //
 //  Created by 김동준 on 12/29/23
 //

import Foundation
import SwiftUI

struct OnboardingView: View {
    @StateObject private var onBoardingViewModel = OnboardingViewModel()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(Array(onBoardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                    
                    OnboardingCellView(onboardingContents: onboardingContent).tag(index)
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
            .background(selectedIndex % 2 == 0 ? .customBGSky : .customBGGreen)
            Spacer()
        }.edgesIgnoringSafeArea(.top)
    }
}

fileprivate struct OnboardingCellView: View {
    private var onboardingContents: OnboardingContent
    
    init(onboardingContents: OnboardingContent) {
        self.onboardingContents = onboardingContents
    }
    
    fileprivate var body: some View {
        ZStack {
            Image(onboardingContents.imageFileName)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 2/3, height: UIScreen.main.bounds.height * 2/3)
                .scaledToFit()
        }.frame(height: UIScreen.main.bounds.height)
        .overlay(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 46)
                Text(onboardingContents.title)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                    .frame(height: 5)
                Text(onboardingContents.subTitle)
                    .font(.system(size: 16))
                StartButton()
                    .padding(.top, 50)
                Spacer()
            }.frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height * 1/3
            ).background(.customWH)
            .shadow(radius: 10)
                
        }
    }
}

private struct StartButton: View {
    var body: some View {
        Button {
            print("go")
        } label: {
            HStack(spacing: 0) {
                Text("시작하기")
                    .font(.system(size: 16))
                    .foregroundColor(.customGreen)
                Image("nextArrow")
                    .renderingMode(.template)
                    .foregroundColor(.customGreen)
            }
        }.padding(.bottom, 50)
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
