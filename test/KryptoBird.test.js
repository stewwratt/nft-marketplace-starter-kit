const assert = require('chai')

const kryptoBird = artifacts.require('./KryptoBird')

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()