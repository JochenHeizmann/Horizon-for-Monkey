Import iap.iap
Import service

Class PaymentProduct Abstract
	Field purchased?
	Field startBuy?
	Field service:PaymentService

    Field price$
    Field localizedName$

	Method New()
		purchased = False
		startBuy = False
	End

	Method SetService:Void(s:PaymentService)
		service = s
	End

	Method GetAppleId$() Abstract
	Method GetAndroidId$() Abstract

	Method Buy:Void()
		startBuy = True
		buyProduct(GetAppleId())
        #if TARGET="android"
            Print "Start purchase..."
		    service.androidPayment.Purchase(GetAndroidId())
        #end
    End

    Method UpdateLocalization()
        #if TARGET="ios"
            If (localizedName = "" Or price = "")
                For Local s:= Eachin getProductsDescription()
                    Local data$[] = s.Split(";")
                    If data[0] = GetAppleId() Then localizedName = data[1] ; price = data[2]
                Next
            End

            ' dirty utf8 hack
            For Local i% = 0 To localizedName.Length() - 1
                If localizedName[i] = -61 Then localizedName = localizedName[0..i] + "ü" + localizedName[i+1..]
            Next

            For Local i% = 0 To price.Length() - 1
                If price[i] = -96 Then price = price[0..i] + "€" + price[i+1..]
                If price[i] = -62 Then price = price[0..i] + " " + price[i+1..]
            Next            
        #end
    End

    Method GetLocalizedName$()
        UpdateLocalization()
        Return localizedName
    End

    Method GetPrice$()
        UpdateLocalization()
        Return price
    End
	

    Method IsConsumable?()
        #if TARGET="ios"
            Return canConsumeProduct(GetAppleId())
        #elseif TARGET="android"
            Return service.androidPayment.ProductQuantity(GetAndroidId()) > 0
        #end
        Return False
    End

    Method Consume:Bool(quantity% = 1)
        #if TARGET="ios"
            Return consumeProduct(GetAppleId(), quantity)
        #elseif TARGET="android"
            Return service.androidPayment.ConsumeProduct(GetAndroidId())
        #end
        Return False
    End

    Method GetQuantity%()
        #if TARGET="ios"
            Return productQuantity(GetAppleId())
        #elseif TARGET="android"
            Return service.androidPayment.ProductQuantity(GetAndroidId())
        #end
        Return 0
    End


	Method IsProductPurchased?()
#if TARGET="ios"
		If (purchased) Then Return True
		If (startBuy And Not IsPurchaseInProgress())
			UpdatePurchasedState()
		End
#elseif TARGET="android"
		purchased = service.androidPayment.IsBought(GetAndroidId())
#end
		Return purchased
	End

	Method UpdatePurchasedState:Void()
#if TARGET="ios"
		purchased = (isProductPurchased(GetAppleId()) > 0)
#elseif TARGET="android"
		purchased = service.androidPayment.IsBought(GetAndroidId())
#end

		'todo: implment for android
	End

	Method IsPurchaseInProgress?()
#if TARGET="ios"
		Return (isPurchaseInProgress() > 0)
#elseif TARGET="android"
		Return service.androidPayment.IsPurchaseInProgress()
#end
	End
End
