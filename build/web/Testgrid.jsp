
<!DOCTYPE html>
<html><head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <meta name="robots" content="noindex, nofollow">
  <meta name="googlebot" content="noindex, nofollow">
<script type="text/javascript" src="demo%20Ang%20js_files/dummy.js"></script>
  <link rel="stylesheet" type="text/css" href="demo%20Ang%20js_files/result-light.css">
      <script type="text/javascript" src="js/angular.js"></script><style type="text/css">@charset "UTF-8";[ng\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak{display:none !important;}ng\:form{display:block;}</style>
      <script type="text/javascript" src="js/xeditable.js"></script>
      <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
      <link rel="stylesheet" type="text/css" href="css/xeditable.css">
      <script type="text/javascript" src="js/angular-mocks.js"></script>
  <style type="text/css">
    div[ng-app] { margin: 10px; }
.table {width: 100% }
form[editable-form] > div {margin: 10px 0;}
  </style>

  <title></title>

  
</head>

<body>
  <h4>Angular-xeditable Editable row (Bootstrap 3)</h4>
<div class="ng-scope" ng-app="app" ng-controller="Ctrl">
   <table class="table table-bordered table-hover table-condensed">
    <tbody><tr style="font-weight: bold">
      <td style="width:35%">Name</td>
      <td style="width:20%">Status</td>
      <td style="width:20%">Group</td>
      <td style="width:25%">Edit</td>
    </tr>
    <!-- ngRepeat: user in users --><tr class="ng-scope" ng-repeat="user in users">
      <td>
        <!-- editable username (text with validation) -->
        <span class="ng-scope ng-binding editable" editable-text="user.name" e-name="name" e-form="rowform" onbeforesave="checkName($data, user.id)" e-required="">
          awesome user1
        </span>
      </td>
      <td>
        <!-- editable status (select-local) -->
        <span class="ng-scope ng-binding editable" editable-select="user.status" e-name="status" e-form="rowform" e-ng-options="s.value as s.text for s in statuses">
          status2
        </span>
      </td>
      <td>
        <!-- editable group (select-remote) -->
        <span class="ng-scope ng-binding editable" editable-select="user.group" e-name="group" onshow="loadGroups()" e-form="rowform" e-ng-options="g.id as g.text for g in groups">
          admin
        </span>
      </td>
      <td style="white-space: nowrap">
        <!-- form -->
        <form style="display: none;" editable-form="" name="rowform" onbeforesave="saveUser($data, user.id)" ng-show="rowform.$visible" class="form-buttons form-inline ng-pristine ng-valid" shown="inserted == user">
          <button type="submit" ng-disabled="rowform.$waiting" class="btn btn-primary">
            save
          </button>
          <button type="button" ng-disabled="rowform.$waiting" ng-click="rowform.$cancel()" class="btn btn-default">
            cancel
          </button>
        </form>
        <div class="buttons" ng-show="!rowform.$visible">
          <button class="btn btn-primary" ng-click="rowform.$show()">edit</button>
          <button class="btn btn-danger" ng-click="removeUser($index)">del</button>
        </div>  
      </td>
    </tr><tr class="ng-scope" ng-repeat="user in users">
      <td>
        <!-- editable username (text with validation) -->
        <span class="ng-scope ng-binding editable" editable-text="user.name" e-name="name" e-form="rowform" onbeforesave="checkName($data, user.id)" e-required="">
          awesome user2
        </span>
      </td>
      <td>
        <!-- editable status (select-local) -->
        <span class="ng-scope ng-binding editable editable-empty" editable-select="user.status" e-name="status" e-form="rowform" e-ng-options="s.value as s.text for s in statuses">
          Not set
        </span>
      </td>
      <td>
        <!-- editable group (select-remote) -->
        <span class="ng-scope ng-binding editable" editable-select="user.group" e-name="group" onshow="loadGroups()" e-form="rowform" e-ng-options="g.id as g.text for g in groups">
          vip
        </span>
      </td>
      <td style="white-space: nowrap">
        <!-- form -->
        <form style="display: none;" editable-form="" name="rowform" onbeforesave="saveUser($data, user.id)" ng-show="rowform.$visible" class="form-buttons form-inline ng-pristine ng-valid" shown="inserted == user">
          <button type="submit" ng-disabled="rowform.$waiting" class="btn btn-primary">
            save
          </button>
          <button type="button" ng-disabled="rowform.$waiting" ng-click="rowform.$cancel()" class="btn btn-default">
            cancel
          </button>
        </form>
        <div class="buttons" ng-show="!rowform.$visible">
          <button class="btn btn-primary" ng-click="rowform.$show()">edit</button>
          <button class="btn btn-danger" ng-click="removeUser($index)">del</button>
        </div>  
      </td>
    </tr><tr class="ng-scope" ng-repeat="user in users">
      <td>
        <!-- editable username (text with validation) -->
        <span class="ng-scope ng-binding editable" editable-text="user.name" e-name="name" e-form="rowform" onbeforesave="checkName($data, user.id)" e-required="">
          awesome user3
        </span>
      </td>
      <td>
        <!-- editable status (select-local) -->
        <span class="ng-scope ng-binding editable" editable-select="user.status" e-name="status" e-form="rowform" e-ng-options="s.value as s.text for s in statuses">
          status2
        </span>
      </td>
      <td>
        <!-- editable group (select-remote) -->
        <span class="ng-scope ng-binding editable editable-empty" editable-select="user.group" e-name="group" onshow="loadGroups()" e-form="rowform" e-ng-options="g.id as g.text for g in groups">
          Not set
        </span>
      </td>
      <td style="white-space: nowrap">
        <!-- form -->
        <form style="display: none;" editable-form="" name="rowform" onbeforesave="saveUser($data, user.id)" ng-show="rowform.$visible" class="form-buttons form-inline ng-pristine ng-valid" shown="inserted == user">
          <button type="submit" ng-disabled="rowform.$waiting" class="btn btn-primary">
            save
          </button>
          <button type="button" ng-disabled="rowform.$waiting" ng-click="rowform.$cancel()" class="btn btn-default">
            cancel
          </button>
        </form>
        <div class="buttons" ng-show="!rowform.$visible">
          <button class="btn btn-primary" ng-click="rowform.$show()">edit</button>
          <button class="btn btn-danger" ng-click="removeUser($index)">del</button>
        </div>  
      </td>
    </tr>
  </tbody></table>

  <button class="btn btn-default" ng-click="addUser()">Add row</button>
</div>

  




<script type="text/javascript">//<![CDATA[

var app = angular.module("app", ["xeditable", "ngMockE2E"]);

app.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});

app.controller('Ctrl', function($scope, $filter, $http) {
 $scope.users = [
    {id: 1, name: 'awesome user1', status: 2, group: 4, groupName: 'admin'},
    {id: 2, name: 'awesome user2', status: undefined, group: 3, groupName: 'vip'},
    {id: 3, name: 'awesome user3', status: 2, group: null}
  ]; 

  $scope.statuses = [
    {value: 1, text: 'status1'},
    {value: 2, text: 'status2'},
    {value: 3, text: 'status3'},
    {value: 4, text: 'status4'}
  ]; 

  $scope.groups = [];
  $scope.loadGroups = function() {
    return $scope.groups.length ? null : $http.get('/groups').success(function(data) {
      $scope.groups = data;
    });
  };

  $scope.showGroup = function(user) {
    if(user.group && $scope.groups.length) {
      var selected = $filter('filter')($scope.groups, {id: user.group});
      return selected.length ? selected[0].text : 'Not set';
    } else {
      return user.groupName || 'Not set';
    }
  };

  $scope.showStatus = function(user) {
    var selected = [];
    if(user.status) {
      selected = $filter('filter')($scope.statuses, {value: user.status});
    }
    return selected.length ? selected[0].text : 'Not set';
  };

  $scope.checkName = function(data, id) {
    if (id === 2 && data !== 'awesome') {
      return "Username 2 should be `awesome`";
    }
  };

  $scope.saveUser = function(data, id) {
    //$scope.user not updated yet
    angular.extend(data, {id: id});
    return $http.post('/saveUser', data);
  };

  // remove user
  $scope.removeUser = function(index) {
    $scope.users.splice(index, 1);
  };

  // add user
  $scope.addUser = function() {
    $scope.inserted = {
      id: $scope.users.length+1,
      name: '',
      status: null,
      group: null 
    };
    $scope.users.push($scope.inserted);
  };
});

// --------------- mock $http requests ----------------------
app.run(function($httpBackend) {
  $httpBackend.whenGET('/groups').respond([
    {id: 1, text: 'user'},
    {id: 2, text: 'customer'},
    {id: 3, text: 'vip'},
    {id: 4, text: 'admin'}
  ]);
    
  $httpBackend.whenPOST(/\/saveUser/).respond(function(method, url, data) {
    data = angular.fromJson(data);
    return [200, {status: 'ok'}];
  });
});
//]]> 

</script>
</body></html>