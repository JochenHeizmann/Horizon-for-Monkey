#If TARGET<>"glfw" And TARGET<>"android" And TARGET<>"ios"
    #Error "c++ or java Mojo target required"
#End

Import mojo
Import brl.asynctcpstream

'
' Implment the following Interface to retrevie the data (when everything is completed)
'

Interface HTTPListener
    Method OnHTTPPageComplete:Void(data$)
End

Class HTTPGetter Implements IOnConnectComplete, IOnReadComplete, IOnWriteComplete

    Field host$
    Field port%    
    Field listener:HTTPListener
    
    Field stream:AsyncTcpStream
    Field strqueue := New StringList
    Field rbuf := New DataBuffer(1024)
    Field wbuf := New DataBuffer(256)

    Field page$ = ""
    Field text$ = ""
    Field dataflag? = False
    
    Method GetPage:Void(host$, page$, port%, listener:HTTPListener)
        Self.host = host
        Self.port = port
        Self.listener = listener
        Self.page = page
        Self.text = ""
        Self.dataflag = False ' marker for start of web page data
        Self.stream = New AsyncTcpStream
        Self.stream.Connect(host, port, Self)        
    End
    
    Method Update?()
        If stream Return stream.Update()
        Return False
    End
    
    Private    
    
    Method Finish:Void()
        listener.OnHTTPPageComplete(text)
        strqueue.Clear
        stream.Close
        stream=Null
    
    End
    
    Method ReadMore:Void()
        stream.ReadAll(rbuf, 0, rbuf.Length, Self)
    End

    Method WriteMore:Void()
        If strqueue.IsEmpty() Return
        Local str := strqueue.RemoveFirst()
        wbuf.PokeString(0, str)
        stream.WriteAll(wbuf, 0, str.Length, Self)
    End
    
    Method WriteString:Void(str$)
        strqueue.AddLast(str)
    End

    Method OnConnectComplete:Void(connected?, source:IAsyncEventSource)   
        If Not connected
            Finish()
            Return
        End

        WriteString("GET " + page + " HTTP/1.0~r~n")
        WriteString("Host: " + host + "~r~n")
        WriteString("~r~n")
            
        WriteMore()
        ReadMore()
    End

    Method OnReadComplete:Void(buf:DataBuffer, offset%,count%, source:IAsyncEventSource)
        If Not count 'EOF!
            Finish()
            Return
        End
        OnHTTPDataReceived(buf,offset,count)
        ReadMore()
    End
    
    Method OnWriteComplete:Void(buf:DataBuffer, offset%,count%, source:IAsyncEventSource )
        WriteMore()
    End   

    Method OnHTTPDataReceived:Void(data:DataBuffer, offset%, count% )
        
        Local str:= data.PeekString(offset, count)
        For Local line:=Eachin str.Split( "~n" )
            ' have we already gone past the start of data marker ?
            If dataflag Then
                text = text + line + "~n"
            Else
                ' we at the data marker for data?  (i.e. first blank line)
                If line = "~r" Then
                    dataflag = True  ' from here on in comes data !
                End
            End
        Next
    End
End