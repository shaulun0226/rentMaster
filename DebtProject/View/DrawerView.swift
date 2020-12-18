//
//  DrawerView.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/11.
//

import SwiftUI
import SwiftDrawer

struct DrawerView : View {
    @EnvironmentObject public var control: DrawerControl
    var body: some View {
        NavigationView {
            VStack {
                Image("user").padding(.top, 10)
                Divider()
                Text("millman")
                Text("mm@gmail.com")
                Spacer()
            }
            .navigationBarItems(leading: Image("menu").onTapGesture {
                self.control.show(type: .leftRear, isShow: true)
            }, trailing: Text("right").onTapGesture {
                self.control.show(type: .rightFront, isShow: true)
            })
            .navigationBarTitle(Text("Account"), displayMode: .inline)
        }
        .foregroundColor(Color.red)
    }
}

#if DEBUG
struct DrawerView_Previews : PreviewProvider {
    static var previews: some View {
        DrawerView()
    }
}
#endif

