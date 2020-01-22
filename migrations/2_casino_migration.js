const Lobby = artifacts.require("Lobby");

module.exports = function(deployer) {
  deployer.deploy(Lobby).then(function(instance){
    console.log("Success");
  }).catch(function(err){
    console.log("Deploy failed " + err);
  });
};
