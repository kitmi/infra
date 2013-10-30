module.exports = {

    mongoConnection: 'mongodb://kitmidbo:passwd4kmimg@172.16.250.131:7000/kitmi',

    sessionSecret: 'AU1234567890KITMI',

    sessionStoreOptions: {
        url: 'mongodb://kitmidbo:passwd4kmimg@172.16.250.131:7000/kitmi'
    },

    const: {
        keywords: 'kit, kitmi, mobile internet, social media, marketing, CRM, offshore, software development',
        description: 'KIT Mobile Internet Pty Ltd, is a social media marketing and offshore software development company.'
    },

    _environment: {
        production: {
            mongoConnection: 'mongodb://127.0.0.1:7000/kitmi'
        }
    }
};