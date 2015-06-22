@.taigaContribPlugins = @.taigaContribPlugins or []

drBeatInfo = {
    slug: "drbeat"
    name: "Dr.Beat"
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

toUtcTime = (time) ->
    time_offset = Math.floor((new Date()).getTimezoneOffset() / 60)
    return parseInt(time) + time_offset

fromUtcTime = (time) ->
    time_offset = Math.floor((new Date()).getTimezoneOffset() / 60)
    return parseInt(time) - time_offset

decorateDrBeat = (drbeat, project) ->
    drbeat.hour = fromUtcTime(drbeat.hour)
    drbeat.priorities = project.priorities
    if drbeat.enabled_priorities
        drbeat_en_priorities = drbeat.enabled_priorities.split(',')
        for priority in drbeat.priorities
            if "" + priority.id in drbeat_en_priorities
                priority.enabled = true
            else
                priority.enabled = false

unDecorateDrBeat = (drbeat) ->
    drbeat.hour = toUtcTime(drbeat.hour)
    drbeat.enabled_priorities = ""
    for priority in drbeat.priorities
        if priority.enabled
            drbeat.enabled_priorities += priority.id + ","
    if drbeat.enabled_priorities.length > 0
        drbeat.enabled_priorities = drbeat.enabled_priorities.slice(
            0, drbeat.enabled_priorities.length - 1
        )

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
        @scope.sectionName = "Dr.Beat"
        @scope.sectionSlug = "drbeat"

        @scope.hours =
            [
                {label: '6:00-7:00', value: 6},
                {label: '7:00-8:00', value: 7},
                {label: '8:00-9:00', value: 8},
                {label: '9:00-10:00', value: 9},
                {label: '10:00-11:00', value: 10},
                {label: '11:00-12:00', value: 11},
                {label: '12:00-13:00', value: 12},
                {label: '13:00-14:00', value: 13},
                {label: '14:00-15:00', value: 14},
                {label: '15:00-16:00', value: 15},
                {label: '16:00-17:00', value: 16},
                {label: '17:00-18:00', value: 17},
                {label: '18:00-19:00', value: 18},
                {label: '19:00-20:00', value: 19},
            ];

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
                decorateDrBeat(@scope.drbeat, @scope.project);
                @appTitle.set("DrBeat - " + @scope.project.name)

            promise.then null, =>
                @confirm.notify("error")

    testHook: () ->
        promise = @http.post(@repo.resolveUrlForModel(@scope.drbeat) + '/test')
        promise.success (_data, _status) =>
            @confirm.notify("success")
        promise.error (data, status) =>
            @confirm.notify("error")


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
                unDecorateDrBeat($scope.drbeat)
                promise = $repo.save($scope.drbeat)
                promise.then (data) ->
                    data.hour = fromUtcTime(data.hour)
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
