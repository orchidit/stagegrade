window.logger = function(r) { console.log(r); };

$(function() {
  getLoginStatusOrDoLogin = function(callback) {
    FB.getLoginStatus(function(resp) {
      if (resp.authResponse) {
        callback(resp);
      } else {
        FB.login(callback, { scope: "email, publish_stream, publish_actions" });
      }
    });
  };

  getMe = function(url) {
    FB.api("/me", function(meResponse) {
      params = { access_token: FB.getAccessToken(), me: meResponse };
      $.post(url, params, function(data) {
        if (data.status == "ok") {
          if (data.url == "_reload" || data.url == null || data.url == undefined) {
            window.location.reload();
          } else {
            window.location = data.url;
          }
        } else if (data.status == "error") {
          alert(data.message);
        }
      });
    });
  };

  navigateToDataURL = function(data, alertOnError) {
    if (alertOnError == undefined) {
      alertOnError = true;
    }

    if (data.status == "ok") {
      if (data.url) {
        window.location = data.url;
      } else if (data.url == undefined) {
        window.location.reload();
      }
    } else if (alertOnError && data.status == "error") {
      alert(data.message);
    }
  };

  $(".fb_sign_in").click(function(e) {
    getLoginStatusOrDoLogin(function(response) {
      if (response.authResponse) {
        params = { user_id: response.authResponse.userID, access_token: response.authResponse.accessToken };

        // Log the user in with their user ID, or redirect to a sign up page.
        $.post("/facebook/create_session", params, navigateToDataURL);
      } else {
        console.log('User cancelled login or did not fully authorize.');
      }
    });
    e.preventDefault();
    return false;
  });

  $(".fb_sign_up").click(function(e) {
    getLoginStatusOrDoLogin(function() { $.post("/facebook/create_user", {}, navigateToDataURL) });
    e.preventDefault();
  });

  $(".fb_link_user").click(function(e) {
    getLoginStatusOrDoLogin(function(response) {
      if (response.authResponse) {
        $.post("/facebook/link_user", {}, function(data) {
          if (data.status == "ok") {
            window.location.reload();
          } else if (data.status == "error") {
            alert(data.message);
          }
        });
      }
    });
    e.preventDefault();
    return false;
  });

  $(".fb_unlink_user").click(function(e) {
    $.post("/facebook/unlink_user", {}, function() { window.location.reload(); });
    e.preventDefault();
    return false;
  });

  $(".fb_logout").click(function(e) {
    FB.logout(function() {
      $.post("/user_session", { _method: "delete" }, function() { window.location = "/"; });
    });
  })
});
