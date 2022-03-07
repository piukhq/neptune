//
//  AddPaymentCardSwiftUIView.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import SwiftUI

class AddPaymentAccountViewModel: ObservableObject {
    @Published var dataSource = FormDataSource(model: PaymentAccountCreateModel())
}


struct AddPaymentAccountSwiftUIView: View {
    @ObservedObject var viewModel: AddPaymentAccountViewModel
    @State var value: String = ""
    
    var body: some View {
        Form {
            ForEach(viewModel.dataSource.fields) { field in
                Text(field.title)
                TextField(field.placeholder, text: $value)
            }
        }
    }
}

//struct FormView: View {
//    enum FormViewConstants {
//        static let vStackInsets = EdgeInsets(top: 20, leading: 25, bottom: 150, trailing: 25)
//        static let vStackInsetsForKeyboard = EdgeInsets(top: 20, leading: 25, bottom: 350, trailing: 25)
//        static let vStackSpacing: CGFloat = 20
//        static let scrollViewOffsetBuffer: CGFloat = 20
//        static let inputToolbarHeight: CGFloat = 44
//        static let multipleChoicePickerHeight: CGFloat = 200
////        static let graphicalDatePickerHeight: CGFloat = UIDevice.current.isSmallSize ? 370 : 410
//        static let datePickerHeight: CGFloat = 230
//        static let expiryDatePickerHeight: CGFloat = 180
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .center, spacing: FormViewConstants.vStackSpacing) {
//                VStack(alignment: .leading, spacing: 5, content: {
//                    Text(viewModel.titleText ?? "")
////                        .font(.custom(UIFont.headline.fontName, size: UIFont.headline.pointSize))
//                        .fixedSize(horizontal: false, vertical: true)
//                        .foregroundColor(Color(Current.themeManager.color(for: .text)))
//
//                    Text(viewModel.descriptionText ?? "")
//                        .font(.custom(UIFont.bodyTextLarge.fontName, size: UIFont.bodyTextLarge.pointSize))
//                        .fixedSize(horizontal: false, vertical: true)
//                        .foregroundColor(Color(Current.themeManager.color(for: .text)))
//                })
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, 5)
//
//                ForEach(viewModel.datasource.visibleFields) { field in
//                    TextfieldView(field: field, viewModel: viewModel)
//                }
//
//                FormFooterView(datasource: viewModel.datasource)
//            }
//            .padding(FormViewConstants.vStackInsets)
//        }
//    }
//}



struct AddPaymentCardSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentAccountSwiftUIView(viewModel: AddPaymentAccountViewModel())
    }
}

class FormDataSource: ObservableObject {
    var fields: [FormField] = []
}

extension FormDataSource {
    convenience init(model: PaymentAccountCreateModel) {
        self.init()
         let cardNumberField = FormField(
            title: "Card Number",
            placeholder: "xxxx xxxx xxxx xxxx",
            validation: nil,
            fieldType: .paymentAccountNumber,
            forcedValue: model.fullPan,
            fieldCommonName: .pan)
        
        fields = [cardNumberField]
    }
}
