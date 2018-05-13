

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Purchasing;
using System.Text.RegularExpressions;
public class AppsFlyerObject : MonoBehaviour, IStoreListener
{

    private static IStoreController m_StoreController;
    private static IExtensionProvider m_StoreExtensionProvider;
    public static string kProductIDConsumable = "com.appsflyer.inapppurchase.cons";


    void Start()
    {

        appsFlyerInit();

        if (m_StoreController == null)
        {
            InitializePurchasing();
        }
    }

    public void InitializePurchasing()
    {
        if (IsInitialized())
        {
            return;
        }

        var builder = ConfigurationBuilder.Instance(StandardPurchasingModule.Instance());
        builder.AddProduct(kProductIDConsumable, ProductType.Consumable);


        UnityPurchasing.Initialize(this, builder);
    }


    private bool IsInitialized()
    {
        return m_StoreController != null && m_StoreExtensionProvider != null;
    }


    public void BuyConsumable()
    {
        print("BuyConsumable");
        BuyProductID(kProductIDConsumable);
    }

    void BuyProductID(string productId)
    {
        if (IsInitialized())
        {
            Product product = m_StoreController.products.WithID(productId);

            if (product != null && product.availableToPurchase)
            {
                Debug.Log(string.Format("Purchasing product asychronously: '{0}'", product.definition.id));
                m_StoreController.InitiatePurchase(product);
            }

            else
            {
                Debug.Log("BuyProductID: FAIL. Not purchasing product, either is not found or is not available for purchase");
            }
        }
        else
        {
            Debug.Log("BuyProductID FAIL. Not initialized.");
        }
    }


    public void OnInitialized(IStoreController controller, IExtensionProvider extensions)
    {
        Debug.Log("OnInitialized: PASS");
        m_StoreController = controller;
        m_StoreExtensionProvider = extensions;
    }

    void ConsTaskOnClick()
    {
        Debug.Log("Buying Consumable Item");
        BuyConsumable();
    }

    public void OnInitializeFailed(InitializationFailureReason error)
    {
        Debug.Log("OnInitializeFailed InitializationFailureReason:" + error);
    }


    public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs args)
    {


        string prodID = args.purchasedProduct.definition.id;
        string price = args.purchasedProduct.metadata.localizedPriceString;
        string regPrice = Regex.Replace(price, "[^0-9 /.]", "");
        string currency = args.purchasedProduct.metadata.isoCurrencyCode;

        Dictionary<string, string> myDict = new Dictionary<string, string>();

        string receipt = args.purchasedProduct.receipt;
        var recptToJSON = (Dictionary<string, object>)MiniJson.JsonDecode(args.purchasedProduct.receipt);
        var transactionID = (string)recptToJSON["TransactionID"];

        if (String.Equals(args.purchasedProduct.definition.id, kProductIDConsumable, StringComparison.Ordinal))
        {
            Debug.Log(string.Format("ProcessPurchase: PASS. Product: '{0}'", args.purchasedProduct.definition.id));

            afiosValidate(prodID, regPrice, currency, transactionID, myDict);
        }
        else
        {
            Debug.Log(string.Format("ProcessPurchase: FAIL. Unrecognized product: '{0}'", args.purchasedProduct.definition.id));
        }


        return PurchaseProcessingResult.Complete;
    }


    /* Note this is for iOS only. Recipt validation on Android has a different API */
    void afiosValidate(string prodID, string price, string currency, string transactionID, Dictionary<string, string> extraParams)
    {
        Debug.Log("AFVALIDATE called! \n ProductID is: " + prodID + "\n TransactionID is: " + transactionID + "\n Price is: " + price + "\n Currency is: " + currency);

        AppsFlyer.setIsSandbox(true);
        AppsFlyer.validateReceipt(prodID,
                                  price,
                                  currency,
                                  transactionID,
                                  extraParams);


    }


    public void OnPurchaseFailed(Product product, PurchaseFailureReason failureReason)
    {
        Debug.Log(string.Format("OnPurchaseFailed: FAIL. Product: '{0}', PurchaseFailureReason: {1}", product.definition.storeSpecificId, failureReason));
    }

    void appsFlyerInit()
    {
        AppsFlyer.setAppsFlyerKey("<DEV_KEY>");
        AppsFlyer.setIsDebug(true);
        AppsFlyer.setAppID("<APP_ID>");
        AppsFlyer.setIsSandbox(true);
        AppsFlyer.getConversionData();
        AppsFlyer.trackAppLaunch();
    }
}

