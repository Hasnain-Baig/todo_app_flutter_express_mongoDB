const express = require('express')
const router = express.Router()

// getRoot
router.get('/', (req, res) => {
    res.send('Server Apis Route!')
})


module.exports = router;