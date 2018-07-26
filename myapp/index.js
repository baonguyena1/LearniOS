'use strict'

const path = require('path');
const body_parser = require('body-parser');
const express = require('express');
var mongoose = require('mongoose');

const database_config = require('./config/database');
const database = require('./util/database');

const userController = require('./controller/userController');

const PORT = process.env.PORT || 8888;
const app =  express();

app.use(body_parser.json());
app.use(express.static(path.join(__dirname, 'assets')));
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Cache-Control, Pragma, Origin, Authorization, Content-Type, X-Requested-With, access_token");
    res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE');
    res.header("Access-Control-Allow-Credentials", "true");
    return next();
});

mongoose = database.connect(mongoose, database_config.mongodb);

app.get('/', (req, res) => {
    const response = {
        status: 200,
        message: 'Successfully',
        result: {}
    };
    res.status(200).send(response);
})

app.use('/user/', userController);

app.listen(PORT, () => {
    console.log('App started at port', PORT);
})