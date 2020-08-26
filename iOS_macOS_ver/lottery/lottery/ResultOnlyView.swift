//
//  ResultOnlyView.swift
//  lottery
//
//  Created by wqhqq on 2020/8/26.
//

import SwiftUI

struct ResultOnlyView: View {
    @ObservedObject var PrizeData = Prizes(data: dataLoader())
    var body: some View {
        resultReplay().environmentObject(self.PrizeData)
    }
}

struct ResultOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        ResultOnlyView()
    }
}
