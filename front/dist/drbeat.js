// Generated by CoffeeScript 1.9.1
(function() {
  var DrBeatAdmin, DrBeatDirective, debounce, decorateDrBeat, drBeatInfo, initDrBeatPlugin, module, unDecorateDrBeat,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.taigaContribPlugins = this.taigaContribPlugins || [];

  drBeatInfo = {
    slug: "drbeat",
    name: "Dr.Beat",
    type: "admin",
    module: 'taigaContrib.drbeat'
  };

  this.taigaContribPlugins.push(drBeatInfo);

  module = angular.module('taigaContrib.drbeat', []);

  debounce = function(wait, func) {
    return _.debounce(func, wait, {
      leading: true,
      trailing: false
    });
  };

  initDrBeatPlugin = function($tgUrls) {
    return $tgUrls.update({
      "drbeat": "/drbeat"
    });
  };

  decorateDrBeat = function(drbeat, project) {
    var drbeat_en_priorities, i, len, priority, ref, ref1, results;
    drbeat.priorities = project.priorities;
    drbeat_en_priorities = drbeat.enabled_priorities.split(',');
    ref = drbeat.priorities;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      priority = ref[i];
      if (ref1 = "" + priority.id, indexOf.call(drbeat_en_priorities, ref1) >= 0) {
        results.push(priority.enabled = true);
      } else {
        results.push(priority.enabled = false);
      }
    }
    return results;
  };

  unDecorateDrBeat = function(drbeat) {
    var i, len, priority, ref;
    drbeat.enabled_priorities = "";
    ref = drbeat.priorities;
    for (i = 0, len = ref.length; i < len; i++) {
      priority = ref[i];
      if (priority.enabled) {
        drbeat.enabled_priorities += priority.id + ",";
      }
    }
    if (drbeat.enabled_priorities.length > 0) {
      return drbeat.enabled_priorities = drbeat.enabled_priorities.slice(0, drbeat.enabled_priorities.length - 1);
    }
  };

  DrBeatAdmin = (function() {
    DrBeatAdmin.$inject = ["$rootScope", "$scope", "$tgRepo", "$appTitle", "$tgConfirm", "$tgHttp"];

    function DrBeatAdmin(rootScope, scope, repo, appTitle, confirm, http) {
      this.rootScope = rootScope;
      this.scope = scope;
      this.repo = repo;
      this.appTitle = appTitle;
      this.confirm = confirm;
      this.http = http;
      this.scope.sectionName = "Dr.Beat";
      this.scope.sectionSlug = "drbeat";
      this.scope.$on("project:loaded", (function(_this) {
        return function() {
          var promise;
          promise = _this.repo.queryMany("drbeat", {
            project: _this.scope.projectId
          });
          promise.then(function(drbeats) {
            _this.scope.drbeat = {
              project: _this.scope.projectId,
              email: '',
              enabled: true
            };
            if (drbeats.length > 0) {
              _this.scope.drbeat = drbeats[0];
            }
            decorateDrBeat(_this.scope.drbeat, _this.scope.project);
            return _this.appTitle.set("DrBeat - " + _this.scope.project.name);
          });
          return promise.then(null, function() {
            return _this.confirm.notify("error");
          });
        };
      })(this));
    }

    DrBeatAdmin.prototype.testHook = function() {
      var promise;
      promise = this.http.post(this.repo.resolveUrlForModel(this.scope.drbeat) + '/test');
      promise.success((function(_this) {
        return function(_data, _status) {
          return _this.confirm.notify("success");
        };
      })(this));
      return promise.error((function(_this) {
        return function(data, status) {
          return _this.confirm.notify("error");
        };
      })(this));
    };

    return DrBeatAdmin;

  })();

  module.controller("ContribDrBeatAdminController", DrBeatAdmin);

  DrBeatDirective = function($repo, $confirm, $loading) {
    var link;
    link = function($scope, $el, $attrs) {
      var form, submit, submitButton;
      form = $el.find("form").checksley({
        "onlyOneErrorElement": true
      });
      submit = debounce(2000, (function(_this) {
        return function(event) {
          var promise;
          event.preventDefault();
          if (!form.validate()) {
            return;
          }
          $loading.start(submitButton);
          if (!$scope.drbeat.id) {
            promise = $repo.create("drbeat", $scope.drbeat);
            promise.then(function(data) {
              return $scope.drbeat = data;
            });
          } else if ($scope.drbeat.email) {
            unDecorateDrBeat($scope.drbeat);
            promise = $repo.save($scope.drbeat);
            promise.then(function(data) {
              return $scope.drbeat = data;
            });
          } else {
            promise = $repo.remove($scope.drbeat);
            promise.then(function(data) {
              return $scope.drbeat = {
                project: $scope.projectId,
                email: '',
                enabled: true
              };
            });
          }
          promise.then(function(data) {
            $loading.finish(submitButton);
            return $confirm.notify("success");
          });
          return promise.then(null, function(data) {
            $loading.finish(submitButton);
            form.setErrors(data);
            if (data._error_message) {
              return $confirm.notify("error", data._error_message);
            }
          });
        };
      })(this));
      submitButton = $el.find(".submit-button");
      $el.on("submit", "form", submit);
      return $el.on("click", ".submit-button", submit);
    };
    return {
      link: link
    };
  };

  module.directive("contribDrbeatWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", DrBeatDirective]);

  module.run(["$tgUrls", initDrBeatPlugin]);

  module.run([
    '$templateCache', function($templateCache) {
      return $templateCache.put('contrib/drbeat', '<div contrib-drbeat-webhooks="contrib-drbeat-webhooks" ng-controller="ContribDrBeatAdminController as ctrl"><header><h1><span class="project-name">{{::project.name}}</span><span class="green">{{::sectionName}}</span></h1></header><form><label for="email">Notification mail</label><div class="contrib-form-wrapper"><fieldset><input type="text" name="email" ng-model="drbeat.email" placeholder="Insert your mail" id="mail" data-type="email"/><div class="check-item"><span>Enable Dr.Beat</span><div class="check"><input type="checkbox" name="notification" ng-model="drbeat.enabled"/><div></div><span translate="COMMON.YES" class="check-text check-yes"></span><span translate="COMMON.NO" class="check-text check-no"></span></div></div><div ng-repeat="priority in drbeat.priorities | orderBy:\'-order\'" class="check-item"><span>{{priority.name}}</span><div class="check"><input type="checkbox" name="notification" ng-model="priority.enabled"/><div></div><span translate="COMMON.YES" class="check-text check-yes"></span><span translate="COMMON.NO" class="check-text check-no"></span></div></div></fieldset></div><button type="submit" class="hidden"></button><a href="" title="Save" ng-click="ctrl.updateOrCreateHook(drbeat)" class="button-green submit-button"><span>Save</span></a></form><a href="https://nephila.it" target="_blank" class="help-button"><span class="icon icon-help"></span><span>Do you need help? Check out our support page!</span></a></div>');
    }
  ]);

}).call(this);
