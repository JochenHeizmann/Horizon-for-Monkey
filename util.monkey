Private

Import "native/util.${TARGET}.${LANG}"

Public

Extern
	Class Util="util"
		#if TARGET="ios" Or TARGET="glfw"
			Function NavigateToUrl:Void(path$)="util::NavigateToUrl"
			Function GetTimestamp%()="util::GetTimestamp"
			Function Alert:Void(title$, message$, buttoncaption$)="util::Alert"
            Function IsTabletDevice:Bool()="util::IsTabletDevice"
		#elseif TARGET="android"
            Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
            Function GetTimestamp%()="util.GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
            Function IsTabletDevice:Bool()="util.IsTabletDevice"
            Function SaveInternalFile:Void(fileName$, data$)="util.SaveInternalFile"
            Function LoadInternalFile$(fileName$)="util.LoadInternalFile"
        #else
			Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
			Function GetTimestamp%()="util.GetTimestamp"
            Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
            Function IsTabletDevice:Bool()="util.IsTabletDevice"
            Function GetHostname$()="util.GetHostname"
		#end
	End
Public