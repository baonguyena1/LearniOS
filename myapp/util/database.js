const database = {
    connect: (mongoose, config) => {
        var path = 'mongodb://' + config.username + ':';
        path += config.password + '@';
        path += config.host + (config.port !== '' ? ':' : '');
        path += config.port + '/';
        path += config.database;
        console.log('path: ', path);
        return mongoose.connect(path);
    }
}

module.exports = database;