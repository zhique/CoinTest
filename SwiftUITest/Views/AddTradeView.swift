//
//  AddTradeView.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/15.
//

import SwiftUI

struct AddTradeView: View {
    @State var trade: Trade
    @Binding var showing: Bool

    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2023, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 10) {
                VStack (alignment: .leading) {
                    Text("Select trade type")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Picker("TradeType", selection: $trade.type) {
                        ForEach(Trade.TradeType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 60, alignment: .center)
                }
                
                Text("Unit price")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                NumericalField(numerical: $trade.univalence)
                
                Text("Quantity")
                    .font(.title3)
                    .foregroundColor(.secondary)
                NumericalField(numerical: $trade.number)
                //TextField("Enter Quantity", value: $trade.number, formatter: NumberFormatter())
                    .foregroundColor(.white)
                Text("Total Value")
                    .font(.title3)
                    .foregroundColor(.secondary)
                let totalValue = String(format: "%.02f", Double(trade.calculateTotalValue()))
                TextField("Value", text: .constant(totalValue))
                    .foregroundColor(.white)
                VStack {
                    DatePicker(
                        "Start Date",
                        selection: $trade.date,
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                VStack {
                    Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        print("tap button action")
                        trade.add()
                        self.showing = false
                    }) {
                        Text("Add it now!")
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: UIScreen.main.bounds.width - 20, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.green, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(5)
                }
                Spacer()
            }
            
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .navigationTitle("Add Trade")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct NumericalField: View {
    @Binding var numerical: Double
    
    var numericalProxy: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.numerical)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.numerical = value.doubleValue
                }
            }
        )
    }
    
    var body: some View {
        TextField("0.00", text: numericalProxy)
        .foregroundColor(.white)
    }
}

/*
public class DoubleFormatter: Formatter {

    override public func string(for obj: Any?) -> String? {
        var retVal: String?
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let dbl = obj as? Double {
            retVal = formatter.string(from: NSNumber(value: dbl))
        } else {
            retVal = nil
        }

        return retVal
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        var retVal = true

        if let dbl = Double(string), let objok = obj {
            objok.pointee = dbl as AnyObject?
            retVal = true
        } else {
            retVal = false
        }

        return retVal

    }
}*/
