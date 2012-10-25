Import horizon.payment

Class UniversalProduct Extends PaymentProduct
    Field appleId$
    Field androidId$

    Method New(appleId$, androidId$ = "")
        Self.appleId = appleId
        Self.androidId = androidId
    End

    Method GetAppleId$()
        Return appleId
    End

    Method GetAndroidId$()
        Return androidId
    End

    #if TARGET="html5"
        Method IsProductPurchased?()
            Return True
        End
    #end
End