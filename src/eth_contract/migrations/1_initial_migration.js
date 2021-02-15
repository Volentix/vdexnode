const Migrations = artifacts.require('Migrations');

module.exports = function (deployer) {
	console.log("STARTING MIGRATION");
	deployer.deploy(Migrations);
	console.log("MIGRATION OVER");
};
