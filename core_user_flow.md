flowchart TD
    %% Main entry points and flows
    Start([App Launch]) --> Auth{Authenticated?}
    Auth -->|No| Onboarding
    Auth -->|Yes| Dashboard
    
    %% Onboarding flow
    Onboarding --> PhoneEntry[Phone Number Entry]
    PhoneEntry --> OTPVerify[OTP Verification]
    OTPVerify --> PINCreation[Create PIN]
    PINCreation --> KYCBasic[Basic KYC]
    KYCBasic --> Dashboard[Dashboard Home]
    
    %% Dashboard branches
    Dashboard --> WalletSection[Wallet & Money]
    Dashboard --> MarketSection[Marketplace]
    Dashboard --> PaySection[Pay & Bills]
    Dashboard --> TransportSection[Transportation]
    Dashboard --> ProfileSection[Profile & Settings]
    
    %% Wallet flow
    WalletSection --> WalletHome[Wallet Home]
    WalletHome --> SendMoney[Send Money]
    WalletHome --> RequestMoney[Request Money]
    WalletHome --> AddMoney[Add Money]
    WalletHome --> Withdraw[Withdraw]
    WalletHome --> History[Transaction History]
    
    SendMoney --> SelectRecipient[Select Recipient]
    SelectRecipient --> EnterAmount[Enter Amount]
    EnterAmount --> ConfirmTransfer[Confirm Transfer]
    ConfirmTransfer --> VerifyPIN[Verify PIN]
    VerifyPIN --> TransferSuccess[Success]
    
    AddMoney --> SelectSource[Select Funding Source]
    SelectSource --> EnterAddAmount[Enter Amount]
    EnterAddAmount --> ProcessDeposit[Process Deposit]
    ProcessDeposit --> DepositSuccess[Success]
    
    %% Pay & Bills flow
    PaySection --> ScanQR[Scan QR]
    PaySection --> PayBills[Pay Bills]
    PaySection --> BuyAirtime[Buy Airtime]
    PaySection --> PayServices[Pay for Services]
    
    ScanQR --> ScanProcess[Process QR Code]
    ScanProcess --> MerchantPay[Merchant Payment]
    MerchantPay --> ConfirmPurchase[Confirm Purchase]
    ConfirmPurchase --> VerifyPINPay[Verify PIN]
    VerifyPINPay --> PaymentSuccess[Success]
    
    PayBills --> SelectProvider[Select Utility Provider]
    SelectProvider --> EnterAccountDetails[Enter Account Details]
    EnterAccountDetails --> EnterBillAmount[Enter Amount]
    EnterBillAmount --> ConfirmBill[Confirm Payment]
    ConfirmBill --> VerifyPINBill[Verify PIN]
    VerifyPINBill --> BillSuccess[Success]
    
    %% Marketplace flow
    MarketSection --> BrowseCategories[Browse Categories]
    MarketSection --> SearchProducts[Search Products]
    MarketSection --> ViewMerchants[View Merchants]
    
    BrowseCategories --> ProductListing[Product Listing]
    SearchProducts --> ProductListing
    ViewMerchants --> MerchantProfile[Merchant Profile]
    MerchantProfile --> ProductListing
    
    ProductListing --> ProductDetails[Product Details]
    ProductDetails --> AddToCart[Add to Cart]
    AddToCart --> ViewCart[View Cart]
    ViewCart --> Checkout[Checkout]
    Checkout --> DeliveryDetails[Delivery Details]
    DeliveryDetails --> PaymentConfirm[Payment Confirmation]
    PaymentConfirm --> VerifyPINMarket[Verify PIN]
    VerifyPINMarket --> OrderSuccess[Order Success]
    
    %% Transportation flow
    TransportSection --> BookRide[Book Ride]
    TransportSection --> BuyBusTicket[Buy Bus Ticket]
    TransportSection --> TrackDelivery[Track Delivery]
    
    BookRide --> SetPickupLocation[Set Pickup Location]
    SetPickupLocation --> SetDestination[Set Destination]
    SetDestination --> ChooseRideType[Choose Ride Type]
    ChooseRideType --> ConfirmRide[Confirm Ride]
    ConfirmRide --> RideMatching[Driver Matching]
    RideMatching --> RideTracking[Ride Tracking]
    RideTracking --> RideComplete[Ride Complete]
    RideComplete --> RateDriver[Rate Driver]
    
    %% Profile & Settings flow
    ProfileSection --> ViewProfile[View Profile]
    ProfileSection --> EditProfile[Edit Profile]
    ProfileSection --> Security[Security Settings]
    ProfileSection --> Preferences[App Preferences]
    ProfileSection --> Support[Help & Support]
    
    Security --> ChangePIN[Change PIN]
    Security --> SetupBiometrics[Setup Biometrics]
    Security --> ManageDevices[Manage Devices]
    
    %% Additional flows based on user needs
    Dashboard --> Notifications[Notifications]
    Dashboard --> QuickActions[Quick Actions]
    
    %% Offline mode handling
    subgraph OfflineMode [Offline Mode Handling]
        OfflineDetection[Detect Offline]
        QueueTransaction[Queue Transaction]
        LocalStorage[Store Locally]
        SyncWhenOnline[Sync When Online]
        OfflineDetection --> QueueTransaction
        QueueTransaction --> LocalStorage
        LocalStorage --> SyncWhenOnline
    end
    
    %% Error handling paths
    VerifyPIN -->|Incorrect PIN| RetryPIN[Retry PIN]
    RetryPIN -->|3 failures| AccountLock[Temporary Lock]
    RetryPIN -->|Success| TransferSuccess
    
    %% Style definitions for different sections
    classDef authSection fill:#e3f2fd,stroke:#2196f3,stroke-width:2px;
    classDef walletSection fill:#e8f5e9,stroke:#4caf50,stroke-width:2px;
    classDef paySection fill:#fff3e0,stroke:#ff9800,stroke-width:2px;
    classDef marketSection fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    classDef transportSection fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    classDef profileSection fill:#f5f5f5,stroke:#9e9e9e,stroke-width:2px;
    classDef successState fill:#c8e6c9,stroke:#4caf50,stroke-width:2px;
    classDef errorState fill:#ffcdd2,stroke:#f44336,stroke-width:2px;
    
    %% Apply styles to nodes
    class Start,Auth,Onboarding,PhoneEntry,OTPVerify,PINCreation,KYCBasic authSection;
    class WalletSection,WalletHome,SendMoney,RequestMoney,AddMoney,Withdraw,History,SelectRecipient,EnterAmount,ConfirmTransfer,VerifyPIN,SelectSource,EnterAddAmount,ProcessDeposit walletSection;
    class PaySection,ScanQR,PayBills,BuyAirtime,PayServices,ScanProcess,MerchantPay,ConfirmPurchase,VerifyPINPay,SelectProvider,EnterAccountDetails,EnterBillAmount,ConfirmBill,VerifyPINBill paySection;
    class MarketSection,BrowseCategories,SearchProducts,ViewMerchants,ProductListing,ProductDetails,AddToCart,ViewCart,Checkout,DeliveryDetails,PaymentConfirm,VerifyPINMarket marketSection;
    class TransportSection,BookRide,BuyBusTicket,TrackDelivery,SetPickupLocation,SetDestination,ChooseRideType,ConfirmRide,RideMatching,RideTracking transportSection;
    class ProfileSection,ViewProfile,EditProfile,Security,Preferences,Support,ChangePIN,SetupBiometrics,ManageDevices profileSection;
    class TransferSuccess,DepositSuccess,PaymentSuccess,BillSuccess,OrderSuccess,RideComplete successState;
    class RetryPIN,AccountLock errorState;