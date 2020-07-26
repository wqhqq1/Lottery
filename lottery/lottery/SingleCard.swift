//
//  SingleCard.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import SwiftUI

struct SingleCard: View {
    @State var prizetitle = "一等奖"
    @State var prizequota = 0
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6, height: 50)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 6) {
                Text(prizetitle)
                    .font(.title)
                    .fontWeight(.heavy)
                Text("名额：\(prizequota)")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "trash")
                .resizable(resizingMode: .stretch)
                .frame(width: 25, height: 25)
//            Spacer()
        }
        .frame(height: 50)
        .padding(.bottom)
        .background(Color.yellow)
        .cornerRadius(3)
    }
}

struct SingleCard_Previews: PreviewProvider {
    static var previews: some View {
        SingleCard()
    }
}
