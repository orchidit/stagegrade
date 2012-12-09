// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function layoutColumns() {
	tallest = 0;

	$(".column").each(function(i) {
		if ($(this).height() > tallest) {
			tallest = $(this).height();
		}
	});

	$(".column").each(function(i) {
		$(this).height(tallest + "px");
	});
}

function getQueryObject(defaults) {
	str = window.location.search.substring(1);
	arr = str.split("&");
	query = new Object();

	for (i in defaults) {
		query[i] = defaults[i];
	}

	for (i in arr) {
		kv = arr[i].split("=");
		query[kv[0]] = kv[1];
	}
	return query;
}

function layoutTabs(defaults) {
	if (defaults == null) {
		defaults = {};
	}
	if (defaults["show"] == null) {
		defaults["show"] = "all";
	}
	if (defaults["sort"] == null) {
		defaults["sort"] = "alpha";
	}
	if (defaults["id"] == null) {
		defaults["id"] = "menu";
	}

	$("#" + defaults["id"] + " ul").addClass('span-4');
	$("#" + defaults["id"] + " li").each(function() {
		// if (!$(this).hasClass("menu_item_first"))
			$(this).addClass("menu_item");
	})

	$("#" + defaults["id"] + " li").addClass("span-4");
	$("#" + defaults["id"] + " li.menu_title").removeClass("menu_item");

	query = getQueryObject(defaults);

	for (i in query) {
		$("#" + i + "-" + query[i]).addClass("selected");
	}
}

layoutSearch = function() {
	search = $("#search");
	search.css('top', ($("#header h1").height()-search.height()) / 2);
}

showList = function(list, speed) {
	$("#top_plays_list").children("div").each(function() { $(this).hide(speed) });
	$("#" + list).show(speed);
}

// From:
// http://github.com/alloy/complex-form-examples/blob/master/public/javascripts/application.js
replace_ids = function(s){
  var new_id = new Date().getTime();
  return s.replace(/NEW_RECORD/g, new_id);
}

$(document).ready(function() {
	$.extend( {
		max: function(array) {
			max = null;
			$.each(array, function(a) {
				if (max == null || array[a] > max) {
					max = array[a];
				}
			});
			return max;
		}
	});
	$.fn.histogram = function(labels, values) {
		rightLabels = $.map(values, function(e) { return "" + e ; });

		max = $.max(values);
		values = $.map(values, function(e) { return e * 90 / max; });
		values.reverse();
		yAxis = $.gchart.axis('left');
		yAxis.labels(labels);

		rightAxis = $.gchart.axis('right');
		rightAxis.labels(rightLabels);

		chart = {
			width: 110, height: 105,
			type: 'barHoriz', barWidth: 14, barSpacing: 2, barZeroPoint: 0.0,
			axes: [yAxis, rightAxis],
		    series: [$.gchart.series('', values, 'gray')]
		};
		$(this).gchart(chart);
	}

	$(".add_nested_item").click(function() {
		elem = $(this);
		template = eval(elem.attr("href").replace(/.*#/, ''));
		$("#" + elem.attr("rel")).append(replace_ids(template));
	});

	$(".remove").live('click', function() {
		$(this).parents(".relationship").remove()
	});
	$(".remove_existing").click(function() {
		elem = $(this);
		target = elem.attr("href").replace(/.*#/, ".");
		elem.parents(target)[0].hide();
		if(hidden_input = elem.prev("input[type-hidden]")) hidden_input.val('1');
	})
});

/**
 * Functions to handle "On Stage Now" loading via AJAX.
 */
function queryStringToObject(query) {
	arr = query.split("&");
	obj = new Object();

	for (i in arr) {
		kv = arr[i].split("=");

		if (kv[0] != "") {
			obj[kv[0]] = (kv[1] == "" ? null : kv[1]);
		}
	}
	return obj;
}

function objectToQueryString(object) {
	arr = [];
	for (i in object) {
		if (object[i] != "" && object[i] != null) {
			arr.push(i + "=" + (object[i] == null ? "" : object[i]));
		}
	}
	return arr.join("&");
}


function Options() {
	this.toString = function() {
		arr = [];
		for (i in this) {
			if (!(this[i] instanceof Function)) {
				arr.push(i + "=" + (this[i] == null ? "" : this[i]));
			}
		}
		return arr.join("&");
	}
}

function ReviewOptions(obj) {
	this.show = (obj["show"] == null ? "critics" : obj["show"]);
}

function ReportFilterOptions(obj) {
	this.show = (obj["show"] == null ? "new" : obj["show"]);
}

ReviewOptions.prototype = new Options();
ReportFilterOptions.prototype = new Options();

function optionClicked(sender, controlsId, bodyId, URL, optionsClass) {
	obj = queryStringToObject(location.hash.substr(1));
	rel = "";

	if (sender != null) {
		rel = sender.attr("rel");
		sender.addClass("selected");
	}

	relArr = rel.split("=");
	obj[relArr[0]] = (relArr.length == 1 ? null : relArr[1]);

	queryString = objectToQueryString(obj);

	$("#" + bodyId).load(URL + "?" + queryString, function() {
		if (queryString != "") {
			location.hash = queryString;
			updateSelected(controlsId, optionsClass);
		} else {
			location.hash = "#";
		}
	});
}

function updateSelected(controlsId, optionsClass) {
	$("#" + controlsId + " a.selected").removeClass("selected");
	obj = new optionsClass(queryStringToObject(location.hash.substr(1)));
	rels = obj.toString().split("&");

	for (i in rels) {
		$("#" + controlsId + " a[rel='" + rels[i] + "']").addClass("selected");
	}
}

function addOptionsHook(controlsId, onclickFunction) {
	$("#" + controlsId + " a").live('click', function () {
		onclickFunction($(this));
		return false;
	});

	$(document).ready(function() { onclickFunction(null); });
}


function reviewSelectorClicked(sender) {
	optionClicked(sender, "review_selector", "reviews_content", window.location.pathname, ReviewOptions);
	optionClicked(sender, "review_selector", "reviews_pane", window.location.pathname, ReviewOptions);
}

function filterClicked(sender) {
	optionClicked(sender, "filter", "reports", window.location.pathname, ReportFilterOptions);
}

function productionsShowOnLoad() {
	addOptionsHook("review_selector", reviewSelectorClicked);
}

function adminReportsIndexOnLoad() {
	addOptionsHook("filter", filterClicked);
}

/** Popup buttons **/
$(document).ready(function() {
    $('.popup').live('click', openMenu);

    function openMenu(e) {
		var button = $(this).addClass('active');
		var menu = $('#' + button.attr('name'));
		var offset = button.offset();
		var adjustTop = parseInt(button.attr("data-top-adjust")) || 0;
		var adjustLeft = parseInt(button.attr("data-left-adjust")) || 0;

		menu.addClass('active').css({
			'top': adjustTop + offset.top, 'left': adjustLeft + offset.left + button.outerWidth()
        });
		menu.click(function(e) { e.stopPropagation(); });

		menu.show(1, function() {
			$(document).one('click', {button: button, menu: menu}, closeMenu);
		});
		return false;
    }

    function closeMenu(e) {
		e.data.menu.removeClass('active').hide(0, function() {
			e.data.button.removeClass('active');
		});
		// e.data.button.one('click', openMenu);
	}
});

/**
 * Voting Buttons
 */
var votingButtons = {
	opposite : function(direction) {
		return (direction == "up" ? "down" : "up");
	},
	loading : function(id, direction) {
		vb = $("#vote_buttons_" + id);
		vb.fadeOut('fast');
		if (vb.css("display") != "none") {
			$("#vote_" + this.opposite(direction) + "_" + id + " a.selected").click();
		}
	},
	complete : function(id) {
		setTimeout(function() { $("#vote_buttons_" + id).fadeIn('slow'); }, 200);
	}
};

/**
 * Sign Up Box
 */
var signUpBox = {
	loading : function(id) {
		$($("#" + id).children()[0]).html("<strong>Loading...</strong>");
	},
	complete : function(id) {
		$("#" + id).fadeIn('slow');
	}
}


$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
