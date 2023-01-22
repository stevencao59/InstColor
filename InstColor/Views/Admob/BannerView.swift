//
//  BannerView.swift
//  InstColor
//
//  Created by Lei Cao on 12/19/22.
//

import SwiftUI
import GoogleMobileAds

class BannerAdVC: UIViewController {
    let adUnitId: String
    weak var delegate: BannerViewControllerDelegate?
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView()
    
    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        
        // Add our BannerView to the VC
        view.addSubview(bannerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    
    //Allows the banner to resize when transition from portrait to landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true // So banner doesn't disappear in middle of animation
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }
    
    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width
        
        //Updates the BannerView size relative to the current safe area of device (This creates the adaptive banner)
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        bannerView.load(GADRequest())
    }
    
}

protocol BannerViewControllerDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerAdVC)
}

struct BannerAd: UIViewControllerRepresentable {
    var adUnitId: String
    @Binding var isSuccesful: Bool
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        let bannerView = BannerAdVC(adUnitId: adUnitId)
        bannerView.delegate = context.coordinator
        bannerView.bannerView.isHidden = true
        bannerView.bannerView.delegate = context.coordinator
        
        return bannerView
    }
    
    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $isSuccesful)
    }
    
    class Coordinator: NSObject, BannerViewControllerDelegate, GADBannerViewDelegate
    {
        let parent: BannerAd
        @Binding var isSuccessful: Bool
        
        init(_ parent: BannerAd, _ isSuccessful: Binding<Bool>) {
            self.parent = parent
            self._isSuccessful = isSuccessful
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        
        func bannerViewController(
            _ bannerViewController: BannerAdVC
        ) {
            
        }
        
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            isSuccessful = true
            bannerView.isHidden = false
            print("DID RECEIVE AD")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            isSuccessful = false
            bannerView.isHidden = true
            print("DID NOT RECEIVE AD: \(error.localizedDescription)")
        }
    }
}

struct BannerContentView: View {
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)
    @State var isSuccesful = false
    
    @State var adSize: GADAdSize = GADAdSize()
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
    public var body: some View {
        VStack {
            BannerAd(adUnitId: adUnitId, isSuccesful: $isSuccesful)
                .frame(width: viewSize.width, height: viewSize.height)
                .onAppear {
                    setFrame()
                }
                .opacity(isSuccesful ? 1 : 0)
                .animation(.default, value: isSuccesful)
                
        }
        .onChange(of: isSuccesful) { success in
            viewSize = success ? CGSize(width: adSize.size.width, height: adSize.size.height) : CGSize(width: 0, height: 0)
        }
    }
    
    func setFrame() {
        //Get the frame of the safe area
        let safeAreaInsets = keyWindow?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        //Use the frame to determine the size of the ad
        adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width - 25)

        viewSize.width = adSize.size.width
    }
}

struct BannerContentView_Previews: PreviewProvider {
  static var previews: some View {
      ZStack {
          BannerContentView(adUnitId: adUnitTestID)
      }
  }
}

