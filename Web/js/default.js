$(document).ready(function() {

	
// -------------------------------------- AJAX -------------------------------------- //

	$.fn.ajax = function(method) {

		// Control variables
		var contentTag = "#mainContent", fileType = ".html";
		var loadingHtml = '<img src="images/128-loading.gif" class="loadingBike" alt="Carregando..." />';
		var $mainContent = $(contentTag), $loadingContent = $(loadingHtml);

		var methods = {

			/**
			 * Set the hash based on the given attributes
			 * @return {null	}
			 */
			hashConfigureSource: function(href) {

				// Force the hash to load
				if (href && window.location.hash == href) {
					$(this).ajax("hashStartLoad");
				// Or load a new one
				} else if (href) {
					window.location.hash = href.replace(fileType, "");
				// Or use the current document to set the path
				} else if (window.location.hash == "") {
					var index = window.location.pathname.lastIndexOf('/'); 
					var hash = window.location.pathname.substring(index+1).replace(fileType, "");

					if (hash == "") {
					    hash = "index";
					}

					$(this).ajax("hashDidLoad", hash);
				}
			},
	
			/**
			 * Load the new document on the screen
			 * @return {null	}
			 */
			hashStartLoad: function() {

			    var hash = window.location.hash.substring(1);
			    
			    if (hash) {
			        $mainContent.fadeOut(300, function() {
			        	$mainContent.after($loadingContent);
			            $mainContent.empty().load(hash + fileType + " " + contentTag, function() {
			                $loadingContent.remove();
			                $mainContent.children().unwrap().fadeIn(300).ajax("hashDidLoad", hash);
			            });
			        });
			    }
			},

			/**
			 * Hash has already been loaded and we cannot set up the additional components
			 * @return {null}
			 */
			hashDidLoad: function(newHash) {
				// Custom code that may need to be executed onload
			}
		};


		// Method calling logic
	    if ( methods[method] ) {
	      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	    } else if ( typeof method === 'object' || ! method ) {
	      return methods.init.apply( this, arguments );
	    } else {
	      $.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
	    }

	};
	
	/**
	 * Make sure that the hash is set
	 */
	$(window).ajax("hashConfigureSource", window.location.hash);

// ------------------------------------- AJAX ------------------------------------- //

	/**
	 * Always load content dinamically with few expections
	 */
	$(window).delegate("a", "click", function() {

		if ($(this).attr("target") == "_blank") {
			return true;
		}
		
		if ($(this).attr("href") != undefined) {

			if ($(this).attr("href").substr(0, 7) == "http://") {
				return true;
			}
			
			if ($(this).attr("href").substr(0, 8) == "https://") {
				return true;
			}
			
			if ($(this).attr("href").substr(0, 7) == "mailto:") {
				return true;
			}
			
			if ($(this).attr("href") == "logout.php") {
				return true;
			}
		}

		$(this).ajax("hashConfigureSource", $(this).attr("href"));
		
	    return false;
	});

	/**
	 * Load the new hash
	 */
	$(window).bind('hashchange', function(event, href) {
		$(this).ajax("hashStartLoad");
	});

// ---------------------------------------------------------------------------- //

// -------------------------------------- DEMO -------------------------------- //


	setInterval(function() {
		var $next = $(".selectedDemo").removeClass("selectedDemo").next();

		if ($next.length != 0) {
			$next.addClass("selectedDemo");
		} else {
			$(".demoStand li:first-child").addClass("selectedDemo");
		}
	}, 3500);

	$(".voteImage").live("click", function () {

		var $image = $(this);
		$image.attr("src", "images/32-Heart-Dark.png").addClass("voted");
	
		$.post('ajax.php',
		{	
			voteUp: 1,
		}, // And we print it on the screen
		function(data) {

			try {
				var json = JSON.parse(data);
			} catch (Exception) {
				console.log("Couldn't parse JSON");
				return 0;
			}

			if (json.response == "true") {
				$(".about p").text("Obrigado! Compartilhe e propague essa ideia ;)");
			} else {
				$(".about p").text("Obrigado, mas só precisa votar uma vez :)");
			}

			// Update the vote count
			$(".voteCount").text(json.votes);

		}, 'html' );
	
	});

	$('#content .rightContent li').bind('mousewheel', function(event){

		if ($(this).hasClass("selectedDemo")) {
			var $selectedDemo = $(this);    
		} else {
			var $selectedDemo = $(this).siblings(".selectedDemo");
		}

		var delta = parseInt($selectedDemo.css("top")) + event.originalEvent.wheelDelta;
		if (delta < 0 && delta > -$selectedDemo.height()) {
			$selectedDemo.css("top", delta + "px");
		}
	});
	
// ------------------------------------------------------------------------------------ //

});