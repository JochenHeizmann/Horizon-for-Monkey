Import iap.iap
Import product

Class PaymentService
	Field products:List<PaymentProduct> = New List<PaymentProduct>
	Field bundleId$

	Method StartService:Void()
		Local prodIds:List<String> = New List<String>
		For Local p:PaymentProduct = EachIn products
			prodIds.AddLast(p.GetId())
		Next

		InitInAppPurchases(bundleId, prodIds.ToArray());
	End

	Method SetBundleId:Void(bundleId$)
		Self.bundleId = bundleId
	End

	Method AddProduct:Void(p:PaymentProduct)
		products.AddLast(p)
	End

	Method IsPurchaseInProgress?()
		Return (isPurchaseInProgress() > 0)
	End
End