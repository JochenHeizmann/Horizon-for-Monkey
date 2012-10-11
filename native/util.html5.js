function util() {
}

util.NavigateToUrl = function(url) {
	document.location.href = url;
};

util.GetTimestamp = function() {
	var ts = Math.round((new Date()).getTime() / 1000);
	return ts;
}

util.Alert = function(title, message, buttonCaption) {
	alert(message);
}

util.IsTabletDevice = function() {
    return false;
}

