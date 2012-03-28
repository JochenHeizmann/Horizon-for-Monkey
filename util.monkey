Private

Import "native/util.${TARGET}.${LANG}"

Public

Extern
	Class Util="util"
		#if TARGET="ios" Or TARGET="glfw"
			Function NavigateToUrl:Void(path$)="util::NavigateToUrl"
			Function GetTimestamp%()="util::GetTimestamp"
			Function Alert:Void(title$, message$, buttoncaption$)="util::Alert"
		#else
			Function NavigateToUrl:Void(path$)="util.NavigateToUrl"
			Function GetTimestamp%()="util.GetTimestamp"
			Function Alert:Void(title$, message$, buttoncaption$)="util.Alert"
		#end
	End
Public