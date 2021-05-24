const { expect } = require('chai');

const { expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const ZHAToken = artifacts.require('ZHAToken');

advanceTime = (time) => {
  return new Promise((resolve, reject) => {
    web3.currentProvider.send({
      jsonrpc: '2.0',
      method: 'evm_increaseTime',
      params: [time],
      id: new Date().getTime()
    }, (err, result) => {
      if (err) { return reject(err) }
      return resolve(result)
    })
  })
}

// Start test block
contract('ZHAToken', async function (accounts) {
  beforeEach(async function () {
    this.zha = await ZHAToken.new();
  });

  it('Mint should add tokens to the balance of the caller', async function () {
    await this.zha.mint(1, {from: accounts[0]});
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('1');

    await this.zha.mint(2, {from: accounts[1]});
    expect((await this.zha.balanceOf(accounts[1])).toString()).to.equal('2');
  });

  it('Mint should add to total supply', async function () {
    await this.zha.mint(1, {from: accounts[0]});
    expect((await this.zha.totalSupply()).toString()).to.equal('1');

    await this.zha.mint(2, {from: accounts[1]});
    expect((await this.zha.totalSupply()).toString()).to.equal('3');
  });

  it('Mint should work up to daily limit', async function () {
    await this.zha.mint(100000);
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('100000');
  });

  it('Minting above daily limit should revert', async function () {
    await expectRevert(
      this.zha.mint(100001),
      'Daily limit exceeded.'
    );
  });

  it('Minting daily limit should reset when new day', async function () {
    await this.zha.mint(100000);
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('100000');
    await expectRevert(
      this.zha.mint(1),
      'Daily limit exceeded.'
    );
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('100000');
    // Advance 1 day
    await advanceTime(86400);
    await this.zha.mint(1);
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('100001');
  });

  it('Minting above total limit should revert', async function () {
    for(let i = 0; i < 100; i++) {
      await this.zha.mint(100000);
      await advanceTime(86400);
    }
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('10000000');
    await advanceTime(86400);
    await expectRevert(
      this.zha.mint(1),
      'Global limit exceeded.'
    );
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('10000000');
  });

  it('Daily limit should be per account', async function () {
    await this.zha.mint(100000, {from: accounts[0]});
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('100000');
    await expectRevert(
      this.zha.mint(1, {from: accounts[0]}),
      'Daily limit exceeded.'
    );

    await this.zha.mint(100000, {from: accounts[1]});
    expect((await this.zha.balanceOf(accounts[1])).toString()).to.equal('100000');
  });

  it('Global limit should be per account', async function () {
    for(let i = 0; i < 100; i++) {
      await this.zha.mint(100000, {from: accounts[0]});
      await advanceTime(86400);
    }
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('10000000');
    await advanceTime(86400);
    await expectRevert(
      this.zha.mint(1),
      'Global limit exceeded.'
    );
    expect((await this.zha.balanceOf(accounts[0])).toString()).to.equal('10000000');

    await this.zha.mint(100000, {from: accounts[1]});
    expect((await this.zha.balanceOf(accounts[1])).toString()).to.equal('100000');
  });

});
