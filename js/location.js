function showError(error) {
    var err_text;
    var err_status = 'failed';

    switch (error.code) {
      case error.PERMISSION_DENIED:
        err_text = 'User denied the request for Geolocation';
        break;
      case error.POSITION_UNAVAILABLE:
        err_text = 'Location information is unavailable';
        break;
      case error.TIMEOUT:
        err_text = 'The request to get user location timed out';
        alert('Please set your location mode on high accuracy...');
        break;
      case error.UNKNOWN_ERROR:
        err_text = 'An unknown error occurred';
        break;
    }

    $.ajax({
      type: 'POST',
      url: '../error_handler.php',
      data: { Status: err_status, Error: err_text },
      success: 'none',
      mimeType: 'text'
    });
}

function showPosition(position) {
	 var lat = position.coords.latitude;
	 if (lat) {
     	lat = lat;
     }else {
     	lat = 'Not Available';
     }

     var lon = position.coords.longitude;
     if (lon) {
     	lon = lon;
     }else {
     	lon = 'Not Available';
     }

  	$.ajax({
  		type: 'POST',
  		url: 'result_handler.php',
  		data: 
      	{
      		Lat: lat, 
      		Lon: lon
      	}
	});
}

function locate() {
	if (navigator.geolocation) {
	    var optn = { 
	    			enableHighAccuracy: true, 
	    			timeout: 30000, 
	    			maximumage: 0 
	    		   };
	    navigator.geolocation.getCurrentPosition(
	    											showPosition, 
	    											showError, 
	    											optn
	    										);
	}
}
