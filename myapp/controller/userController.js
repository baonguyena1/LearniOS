'use strict'

const express = require('express');
const router = express.Router();
const Q = require('q');
const body_parser = require('body-parser');
const crypto = require('crypto');
const _ = require('underscore')
const User = require('../model/user');

router.post('/signin', async (req, res) => {

    try {
        const user = await User.findOne({'username': req.body.username});
        if (user) throw new Error('User is existed');
        createNewUser(req.body)
        .then(user => {
            delete user.password;
            const successfullyResponse = {
            'status': true,
            'result': user,
            'server_time': new Date().toISOString()
            };
            console.log(successfullyResponse);
            res.status(200).send(successfullyResponse);
        })
        .fail(error => {
            throw error;
        })
    } catch (error) {
        const errorResponse = {
            'status': false,
            'message': error.message,
            'result': {},
            'server_time': new Date().toISOString()
        };
        res.status(400).send(errorResponse);
    }

    function createNewUser(data) {
        const deferred = Q.defer();
        const password_hash = crypto.createHash('sha1').update(data.password).digest('hex');
        const email = data.email;
        const userData = {
            'username': data.username,
            'password': password_hash
        };
        if (!_.isEmpty(email)) {
            userData['email'] = email;
        }
        const user = new User(userData);
        user.save((error, userInfo) => {
            if (error) {
                deferred.reject(error);
            } else {
                deferred.resolve(userInfo);
            }
        })
        return deferred.promise;
    }

});

router.get('/', (req, res) => {
    User.find()
    .select('-password')
    .exec((error, users) => {
        if (error) {
            const errorResponse = {
                'status': false,
                'message': error.message,
                'result': {},
                'server_time': new Date().toISOString()
            };
            res.status(400).send(errorResponse);
        } else {
            const successfullyResponse = {
                'status': true,
                'message': '',
                'result': users,
                'server_time': new Date().toISOString()
            };
            res.send(successfullyResponse);
        }
    })
})

module.exports = router;