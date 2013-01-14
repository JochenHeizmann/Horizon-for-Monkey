Private

Import "native/util.${TARGET}.${LANG}"

Public

Extern
    Class Util="util"
        #if TARGET="ios"
            Function NavigateToUrl:Void(path$)="util::NavigateToUrl"
            Function GetTimestamp%()="util::GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util::Alert"
            Function IsTabletDevice:Bool()="util::IsTabletDevice"
        #elseif TARGET="glfw"
            Function NavigateToUrl:Void(path$)="util::NavigateToUrl"
            Function GetTimestamp%()="util::GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util::Alert"
            Function IsTabletDevice:Bool()="util::IsTabletDevice"
            Function GetHostname$()="util::GetHostname"
        #elseif TARGET="android"
            Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
            Function GetTimestamp%()="util.GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
            Function IsTabletDevice:Bool()="util.IsTabletDevice"
            Function SaveInternalFile:Void(fileName$, data$)="util.SaveInternalFile"
            Function LoadInternalFile$(fileName$)="util.LoadInternalFile"
            Function GetHostname$()="util.GetHostname"
        #elseif TARGET="html5"
            Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
            Function GetTimestamp%()="util.GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
            Function IsTabletDevice:Bool()="util.IsTabletDevice"
            Function GetHostname$()="util.GetHostname"
        #else
            Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
            Function GetTimestamp%()="util.GetTimestamp"
            'Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
            Function IsTabletDevice:Bool()="util.IsTabletDevice"
            'Function GetHostname$()="util.GetHostname"
        #end
    End
Public