
Class MarketingParser
    Field text$[]
    Field url$ = ""

    Method New(data$)
        SetData(data)
    End

    Method SetData(data$)
        Local splittedData := data.Split("~n")
        If (splittedData.Length > 0)
            text = splittedData
            If splittedData[0].StartsWith("URL=")
                url = splittedData[0].Replace("URL=", "")
                text = splittedData[1..splittedData.Length]
            End
        End
    End

End
