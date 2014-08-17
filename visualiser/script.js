angular.

module('smoothier', []).

run(function(){
  console.log('Initializing soundcloud')
  SC.initialize({
    client_id: "cd79697779afba967d0fb3965a71dbc9"
  });
}).

factory('Soundcloud', function(){

}).

service('Track', function(){

}).

controller('AppCtrl', function($scope, Tracks){
  console.log('in controller');


});

