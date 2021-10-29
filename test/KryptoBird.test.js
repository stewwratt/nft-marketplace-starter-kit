const {assert} = require('chai')

const KryptoBird = artifacts.require('./KryptoBird')

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {
    let contract;
    //before tells our tests to run this first before anything else
    before( async () => {
        contract = await KryptoBird.deployed()
    })
    //testing container - describe

    /*
    function name() {

    }
    //arrow function
    let x = () => {
        'this' keyword is important with arrow functions
    }
    */


    describe('deployment', async () => {
        // test samples with writing it
        it('deploys successfully', async() => {
            const address = contract.address
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })
        //Write two tests CHALLANGE
        // 1. Test that the name matches on our contract
        // 2. Test that the symbol matches 
        it('name matches successfully', async() => {
            const name = await contract.name()
            assert.equal(name, 'KryptoBird')
        })
        it('symbol matches successfully', async() => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KBIRDZ')
        })
    })
    describe('minting', async () => {
        it('creates a new token', async () => {
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from the contract')
            assert.equal(event._to, accounts[0], 'to is msg.sender')

            await contract.mint('https...1').should.be.rejected
        })
    })
    describe('indexing', async () => {
        it('lists KryptoBirdz', async () => {
            //mint three new tokens
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()
            
            //loop through list and grab KryptoBirdz from list
            let result = []
            let KryptoBird
            for(i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i-1)
                result.push(KryptoBird)
            }

            //assert.equal(result, ['https...1', 'http...2', 'https...3', 'https...4'])
            let expected = ['https...1', 'https...2', 'https...3', 'https...4']
            assert.equal(result.join(','), expected.join(','))
        })

    })
})
