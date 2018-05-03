using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class AppsFlyerTrackerCallbacks : MonoBehaviour {

	public Text callbacks;

	// Use this for initialization
	void Start () {
		print ("AppsFlyerTrackerCallbacks on Start");
		
	}
	
	
	public void didReceiveConversionData(string conversionData) {
		print("AppsFlyerTrackerCallbacks:: got conversion data = " + conversionData);
	}
	
	public void didReceiveConversionDataWithError(string error) {
		print ("AppsFlyerTrackerCallbacks:: got conversion data error = " + error);
	}
	
	public void didFinishValidateReceipt(string validateResult) {
		print ("AppsFlyerTrackerCallbacks:: got didFinishValidateReceipt  = " + validateResult);
		
	}
	
	public void didFinishValidateReceiptWithError (string error) {
		print ("AppsFlyerTrackerCallbacks:: got idFinishValidateReceiptWithError error = " + error);
		
	}
	
	public void onAppOpenAttribution(string validateResult) {
		print ("AppsFlyerTrackerCallbacks:: got onAppOpenAttribution  = " + validateResult);
		
	}
	
	public void onAppOpenAttributionFailure (string error) {
		print ("AppsFlyerTrackerCallbacks:: got onAppOpenAttributionFailure error = " + error);
		
	}
	
	public void onInAppBillingSuccess () {
		print ("AppsFlyerTrackerCallbacks:: got onInAppBillingSuccess succcess");
		
	}
	public void onInAppBillingFailure (string error) {
		print ("AppsFlyerTrackerCallbacks:: got onInAppBillingFailure error = " + error);
		
	}

	void printCallback(string str) {
		callbacks.text += str + "\n";
	}
}
