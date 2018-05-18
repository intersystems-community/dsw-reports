'use strict';

var params = window
    .location
    .search
    .replace('?','')
    .split('&')
    .reduce(
        function(p,e){
            var a = e.split('=');
            p[ decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
            return p;
        },
        {}
    );

if (!params['ns']) params['ns'] = undefined;

var SERVER = "http://"+location.host;

var CONFIG = getConfiguration({
    server: SERVER,
    namespace: params['ns']
});

var NAMESPACE = CONFIG.NAMESPACE;


var app = angular.module('app', ['ngSanitize']);
function ReportCtrl($scope, $location, $document, $http) {
    $scope.model = {
        header: CONFIG.REPORT_NAME,
        blocks: CONFIG.BLOCKS
    };

    function getMDX(block, total) {
        if ($scope.model.blocks[block].totals[total].mdx === undefined ||
        $scope.model.blocks[block].totals[total].mdx == null) return;

        $http({
            method: "POST",
            url: SERVER + "/MDX2JSON/MDX?Namespace=" + NAMESPACE,
            data: {MDX: $scope.model.blocks[block].totals[total].mdx}
        }).then(function success(response) {

            if ($scope.model.blocks[block].totals[total].strings === undefined || $scope.model.blocks[block].totals[total].strings == null)
                return;

            for (var string in $scope.model.blocks[block].totals[total].strings) {
                var row = $scope.model.blocks[block].totals[total].strings[string].row;
                if (row === undefined || row == null) row = 0;

                if ($scope.model.blocks[block].totals[total].strings[string].value_append === undefined ||
                    $scope.model.blocks[block].totals[total].strings[string].value_append == null)
                    $scope.model.blocks[block].totals[total].strings[string].value_append = "";

                var mult = 1;
                if ($scope.model.blocks[block].totals[total].strings[string].value_append === "%")
                    mult = 100;

                $scope.model.blocks[block].totals[total].strings[string].value = Math.round(response.data.Data[row] * mult);
            }
        });
    }

    function init() {
        for (var block = 0; block < $scope.model.blocks.length; block++) {
            if ($scope.model.blocks[block].totals === undefined || $scope.model.blocks[block].totals == null)
                continue;

            for (var total = 0; total < $scope.model.blocks[block].totals.length; total++) {
                getMDX(block, total);
            }
        }
    }

    init();

}
app.controller('report', ['$scope', '$location', '$document', '$http', ReportCtrl]);
