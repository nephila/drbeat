@.taigaContribPlugins = @.taigaContribPlugins or []

drBeatInfo = {
    slug: "drbeat"
    name: "DrBeat"
    type: "admin"
    module: 'taigaContrib.drbeat'
}

@.taigaContribPlugins.push(drBeatInfo)

module = angular.module('taigaContrib.drbeat', [])

debounce = (wait, func) ->
    return _.debounce(func, wait, {leading: true, trailing: false})

initDrBeatPlugin = ($tgUrls) ->
    $tgUrls.update({
        "drbeat": "/drbeat"
    })

class DrBeatAdmin
    @.$inject = [
        "$rootScope",
        "$scope",
        "$tgRepo",
        "$appTitle",
        "$tgConfirm",
        "$tgHttp",
    ]

    constructor: (@rootScope, @scope, @repo, @appTitle, @confirm, @http) ->
        @scope.sectionName = "DrBeat"
        @scope.sectionSlug = "drbeat"

        @scope.$on "project:loaded", =>
            promise = @repo.queryMany("drbeat", {project: @scope.projectId})

            promise.then (drbeats) =>
                @scope.drbeat = {
                    project: @scope.projectId,
                    email: '',
                    enabled: true
                }
                if drbeats.length > 0
                    @scope.drbeat = drbeats[0]
                @decorateDrBeat(@scope.drbeat);
                @appTitle.set("DrBeat - " + @scope.project.name)

            promise.then null, =>
                @confirm.notify("error")

    testHook: () ->
        promise = @http.post(@repo.resolveUrlForModel(@scope.drbeat) + '/test')
        promise.success (_data, _status) =>
            @confirm.notify("success")
        promise.error (data, status) =>
            @confirm.notify("error")

    decorateDrBeat: (drbeat) ->
        drbeat.priorities = @scope.project.priorities
        drbeat_en_priorities = drbeat.enabled_priorities.split(',')
        for priority in drbeat.priorities
            if "" + priority.id in drbeat_en_priorities
                priority.enabled = true
            else
                priority.enabled = false


module.controller("ContribDrBeatAdminController", DrBeatAdmin)

DrBeatDirective = ($repo, $confirm, $loading) ->
    link = ($scope, $el, $attrs) ->
        form = $el.find("form").checksley({"onlyOneErrorElement": true})
        submit = debounce 2000, (event) =>
            event.preventDefault()

            return if not form.validate()

            $loading.start(submitButton)

            if not $scope.drbeat.id
                promise = $repo.create("drbeat", $scope.drbeat)
                promise.then (data) ->
                    $scope.drbeat = data
            else if $scope.drbeat.email
                promise = $repo.save($scope.drbeat)
                promise.then (data) ->
                    $scope.drbeat = data
            else
                promise = $repo.remove($scope.drbeat)
                promise.then (data) ->
                    $scope.drbeat = {
                        project: $scope.projectId,
                        email: '',
                        enabled: true
                    }

            promise.then (data)->
                $loading.finish(submitButton)
                $confirm.notify("success")

            promise.then null, (data) ->
                $loading.finish(submitButton)
                form.setErrors(data)
                if data._error_message
                    $confirm.notify("error", data._error_message)

        submitButton = $el.find(".submit-button")

        $el.on "submit", "form", submit
        $el.on "click", ".submit-button", submit

    return {link:link}

module.directive("contribDrbeatWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", DrBeatDirective])

module.run(["$tgUrls", initDrBeatPlugin])
