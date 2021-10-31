import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
import {MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn} from 'mdb-react-ui-kit';
import './App.css';

class App extends Component {
    
    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }
    //first up is to detect ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider()
        
        //modern browsers
        // if there is a provider then lets console.log that its working and access 
        // the window from the doc to set Web3 to the provider
        if (provider) {
            console.log('Ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            console.log('No Ethereum wallet detected')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts()
        this.setState({account: accounts[0]})
        console.log(this.state.account)
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]
        if(networkData) {
            const kryptoBirdAbi = KryptoBird.abi
            const address = networkData.address
            const contract = new web3.eth.Contract(kryptoBirdAbi, address)
            this.setState({contract})
            console.log(this.state.contract)
            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({totalSupply})
            console.log(this.state.totalSupply)

            for(let i = 1; i <= totalSupply; i++){
                const KryptoBird = await contract.methods.kryptoBirdz(i-1).call()
                this.setState({
                    kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
                })
            }
        } else {
            window.alert('Smart contract not deployed')
        }
    }

    //with minting we are sending information and we need to specify the account
    mint = (kryptoBird) => {
        this.state.contract.methods.mint(kryptoBird).send({from: this.state.account})
        .once('receipt', (receipt) => {
            this.setState({
                kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
            })
        })
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []
        }
    }

    render() {
        return (
            <div className = 'container-filled'>
                {console.log(this.state.kryptoBirdz)}
                <nav className = 'navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className = 'navbar-brand col-sm-3 col-md-3 mr-0'
                        style ={{color: 'white'}}>
                        Krypto Birdz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className = 'navbar-nav px-3'>
                        <li className = 'nav-item text-nowrap'>
                            <small className = 'text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className = 'container-fluid mt-1'>
                    <div className = 'row'>
                        <main role = 'main' className = 'col-lg-12 d-flex text-center'>
                            <div className = 'content mr-auto ml-auto' style = {{opacity: '0.8'}}>
                                <h1 style = {{color: 'black'}}>
                                    KryptoBirdz - NFT Marketplace
                                </h1>
                                <form onSubmit = {(event) => {
                                    event.preventDefault()
                                    const kryptoBird = this.kryptoBird.value
                                    this.mint(kryptoBird)
                                }}>
                                    <input
                                        type = 'text'
                                        placeholder = 'Add file location...'
                                        className = 'form-control mb-1'
                                        ref = {(input) => this.kryptoBird = input}
                                    />
                                    <input 
                                        style = {{margin: '6px'}}
                                        type = 'submit'
                                        className = 'btn btn-primary btn-black'
                                        value = 'MINT'>
                                    </input>
                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>
                    <div className = 'row text-center'>
                        {this.state.kryptoBirdz.map((kryptoBird, key)=>{
                            return(
                                <div>
                                    <div>
                                        <MDBCard className = 'token img' style = {{maxWidth: '22rem'}}>
                                            <MDBCardImage src = {kryptoBird} position = 'top' style = {{marginRight: '4px'}} />
                                            <MDBCardBody>
                                                <MDBCardTitle> KryptoBirdz </MDBCardTitle>
                                                <MDBCardText> The KryptoBirdz are 20 uniquely generated by clarian01 that I am using (w/ permission) as placeholder images for this NFT Marketplace test project. </MDBCardText>
                                                <MDBBtn href = {kryptoBird}> Download </MDBBtn>
                                            </MDBCardBody>
                                        </MDBCard>
                                    </div>
                                </div>
                            )
                        })}
                    </div>
                </div>
            </div>
        )
    }
}

export default App;