const Casino = artifacts.require("Casino");

module.exports = function (deployer) {
  deployer.deploy(Casino).then(function (instance) {
    console.log("Success");
  }).catch(function (err) {
    console.log("Deploy failed " + err);
  });
};
