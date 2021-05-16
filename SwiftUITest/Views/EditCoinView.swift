//
//  EditCoinView.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/5/16.
//

import SwiftUI
import Combine

struct EditCoinView: View {
    @State var coin: Coin
    @Binding var showing: Bool
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 10) {
                Text("Coin ID")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                TextField.init("Coin ID", text: $coin.id)
                    .disabled(true)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                // TODO: separate tags
                Text("Tags")
                    .font(.title3)
                    .foregroundColor(.secondary)
                let tagPH = coin.tags.isEmpty ? "Enter tags" : coin.tags
//                var tags = coin.tags
                TextField(tagPH, text: $coin.tags)
                    .foregroundColor(.white)
                
                Text("Comments")
                    .font(.title3)
                    .foregroundColor(.secondary)
                let commentsPH = coin.comments.isEmpty ? "Enter tags" : coin.comments
                TextField(commentsPH, text: $coin.comments)
                    .foregroundColor(.white)
                Spacer().frame(width: 300, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        print("tap button action, coinId:\(coin.id), coinTags:\(coin.tags), coinComments:\(coin.comments)")
                        coin.add()
                        self.showing = false
                    }) {
                        Text("Confirm")
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }.disabled(false)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.green, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(5)
                }
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .navigationTitle("Update \(coin.id)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .background(Color.blue) // delete
        }
    }
}
