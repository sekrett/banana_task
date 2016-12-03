// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require angular
//= require_tree .

$(document).on('ready', function () {
    $('[data-toggle="tooltip"]').tooltip();
});

var bananaApp = angular.module('bananaApp', []);

bananaApp.controller('CommentsController', function($scope, $http) {
    $scope.init = function(post_id) {
        $http.get("/api/v1/posts/" + post_id + "/comments.json")
            .then(function(response) {
                $scope.comments = response.data;
            });
    };

    $scope.submit = function(post_id) {
        $http.post("/api/v1/posts/" + post_id + "/comments.json", { comment: { content: this.comment.content } })
            .then(function(response) {
                $scope.comments.unshift(response.data);
            });
        this.comment = {};
    };

    $scope.destroy = function(comment) {
        $http.delete("/api/v1/posts/" + comment.post_id + "/comments/" + comment.id + ".json");
        $('tr#' + comment.id).hide("puff", function() {
            // TODO: It does not clear original array
            if ($scope.comments.length == 1) {
                $scope.comments.length = 0;
            }
            $(this).remove();
        });
    }
});

// http://stackoverflow.com/questions/18313576/confirmation-dialog-on-ng-click-angularjs
bananaApp.directive('ngConfirmClick', [
    function() {
        return {
            priority: -1,
            restrict: 'A',
            link: function(scope, element, attrs) {
                element.on('click', function(e) {
                    var message = attrs.ngConfirmClick;
                    if (message && !confirm(message)) {
                        e.stopImmediatePropagation();
                        e.preventDefault();
                    }
                });
            }
        }
    }
]);
