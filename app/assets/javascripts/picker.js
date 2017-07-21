	 var developerKey = devkey
     var clientid = clid
     var scope = ["https://www.googleapis.com/auth/photos"]
     var oauthToken;
     
  function onApiLoad() {        
        gapi.load('auth', {'callback': onAuthApiLoad});
        gapi.load('picker');
    };
      
  function onAuthApiLoad() {
        window.gapi.auth.authorize(
            { 'client_id':  clientid,  'scope':  scope
            },  handleAuthResult);
      };

    // Function called after onAuthApiLoad, to handle authoriaztion
     function handleAuthResult(authResult) {
       // If user clicks Accept button, save the accesstoken for that user to oauthToken
        if (authResult && !authResult.error) {
          oauthToken = authResult.access_token;
	  // Function to create picker view on our application
          createPicker();
          showForm();
        };
      };
            
      // Create and render a Picker object for picking user Photos.
      function createPicker() {
        var picker = new google.picker.PickerBuilder().
			addViewGroup(
            	new google.picker.ViewGroup(google.picker.ViewId.PHOTOS).
                	addView(new google.picker.PhotosView().
                    	setType(google.picker.PhotosView.Type.UPLOADED))).
        	addView(google.picker.ViewId.RECENTLY_PICKED).
        	setOAuthToken(oauthToken).
        	setDeveloperKey(developerKey).
			setCallback(pickerCallback).
			build();
        	picker.setVisible(true);
      };
      
      
      function pickerCallback(data) {
        var url = 'nothing';
	// Make sure user clicked select button
	// data object holds the selected file details
        if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
          var doc = data[google.picker.Response.DOCUMENTS][0];
          url = doc[google.picker.Document.THUMBNAILS][3]["url"];
          rname = doc[google.picker.Document.NAME]
        };
        document.getElementById('picker').setAttribute('value', url);
        document.getElementById('rname').setAttribute('value', rname);
      };

      function showForm() {
          var x = document.getElementById('pickerform');
          if (x.style.display === 'none') {
              x.style.display = 'block';
          } else if (x.style.display === 'block') {
              x.style.display = 'none';
          } else {
              x.style.display = 'block';
          }
      };