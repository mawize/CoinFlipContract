const Casino = artifacts.require("Casino");
const CoinFlip = artifacts.require("CoinFlip");
const truffleAssert = require("truffle-assertions");

contract("Casino", async function (accounts) {

    let instance;

    before(async function () {
        instance = await Casino.deployed()
    });

    it("should reset balance to 0 after withdrawal", async function () {
        let instance = await Casino.new();
        await instance.createFlipCoinBet(
            { from: accounts[2], value: web3.utils.toWei("1", "ether") }
        );

        const bet = await instance.games(0);
        const coinflip = await CoinFlip.at(bet);
        console.log(coinflip);

        /*.returnValues[0];
        let coinflip = await CoinFlip.deployed(addr);

        let balance = await coinflip.balance();
        let floatBalance = parseFloat(balance);

        let realBalance = await web3.eth.getBalance(instance.address);

        assert(floatBalance == realBalance, "Contract balance was not 0 after withdrawal or did not match")
*/
    })
});