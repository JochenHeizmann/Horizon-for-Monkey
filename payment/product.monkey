Import iap.iap

Class PaymentProduct Abstract
	Field purchased?
	Field startBuy?

	Method New()
		purchased = False
		startBuy = False
	End

	Method GetId$() Abstract

	Method Buy:Void()
		startBuy = True
		buyProduct(GetId())
	End

	Method IsProductPurchased?()
		If (startBuy And Not IsPurchaseInProgress())
			UpdatePurchasedState()
		End

		Return purchased		
	End

	Method UpdatePurchasedState:Void()
		purchased = (isProductPurchased(GetId()) > 0)
	End

	Method IsPurchaseInProgress?()
		Return (isPurchaseInProgress() > 0)
	End
End