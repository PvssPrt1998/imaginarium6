//import SwiftUI
//
//struct VoteView: View {
//    
//    @ObservedObject var viewModel: VoteViewModel
//    
//    var body: some View {
//        ZStack {
//            Image(Images.Background.rawValue)
//                .resizable()
//                .ignoresSafeArea()
//            VStack(spacing: 0) {
//                Text("Who votes for this\npicture ?")
//                    .multilineTextAlignment(.center)
//                    .font(.largeTitle.weight(.bold))
//                    .foregroundColor(.white)
//                    .padding(.top, 13)
//                    .frame(maxHeight: .infinity, alignment: .top)
//                Image(viewModel.selectedImages[index])
//                    .resizable()
//                    .scaledToFit()
//                    .overlay(Text("\(index + 1)")
//                        .font(.largeTitle.weight(.bold))
//                        .foregroundColor(.white)
//                        .padding(8)
//                             ,alignment: .topLeading
//                    )
//                    .padding(.top, 13)
//                LazyVGrid(columns: [GridItem(.fixed(163)),GridItem(.fixed(163))], spacing: 10) {
//                    ForEach(0..<viewModel.votePlayers.count, id: \.self) { i in
//                        HStack(spacing: 10) {
//                            Image(viewModel.players[i].imageTitle)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 67, height: 63)
//                            Text(viewModel.players[i].name)
//                                .font(.callout)
//                                .foregroundColor(.c10547143)
//                        }
//                        .padding(10)
//                        .background(Color.cSecondary)
//                        .clipShape(.rect(cornerRadius: 15))
//                        .onTapGesture {
//                            viewModel.selectImageForPlayer(index, playerIndex: i)
//                        }
//                    }
//                }
//                .padding(.top, 18)
//                
//                Button {
//                    viewModel.voteNext()
//                } label: {
//                    HStack(spacing: 10) {
//                        Image(systemName: "hands.and.sparkles.fill")
//                            .font(.system(size: 24, weight: .heavy))
//                            .foregroundColor(.c10547143)
//                        Text("Next")
//                            .font(.custom("Rubik", size: 14).weight(.medium))
//                            .foregroundColor(.c10547143)
//                    }
//                    .padding(.vertical, 12)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                    .clipShape(.rect(cornerRadius: 10))
//                }
//                .frame(maxHeight: .infinity, alignment: .bottom)
//                .padding(.bottom, 8)
//            }
//        }
//    }
//}
//
//#Preview {
//    VoteView(viewModel: VoteViewModel(source: Source()))
//}
//
//final class VoteViewModel: ObservableObject {
//    
//    let source: Source
//    
//    var playersForSelected: Array<Player> = []
//    var 
//    
//    init(source: Source) {
//        self.source = source
//    }
//    
//    
//}
