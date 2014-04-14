# Tachi

## Overview
Opinionated personal URL shortener which runs on [Heroku][1] and uses [Redis to
go][2] as a backend. Shortening is done through the fabulous [Guillotine][3]
engine and its Redis adapter.

All methods except shortened URL lookup `GETs` require JWT authentication.

## Usage
You can use it exactly as any other guillotine app:

    curl -X GET http://fragd-url-shortener.herokuapp.com/shorten -i -d"token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjVMWnUyR2czVzhOVHFKYk05SEhaTlNnZCI.no5LH7TYkss-jp7mqjTcLuEZef5-r9JkzA2lVBbMijY" -d"url=http://somedomain.com/blah" -d"code=abcdef"


## Features
- Authentication updated to use JWT authentication token 
- Custom GET endpoint

## Setup

    git clone git://github.com/FragD/tachi.git
    cd tachi
    heroku create
    heroku addons:add redistogo
    heroku domains:add fra.gd
    git push heroku master
    # for authentication
    heroku config:add JWT_ID="jbjadasdasdasd12321eas"
    heroku config:add JWT_SECRET="908ADD8989adfvasdasdasdadad9897897987DAsASas"
    # selected custom domain
    heroku config:add SHORT_DOMAIN="fra.gd" 



### API
There is a JSONP wrapped custom endpoint, you can add URLs with a `GET` to

    https://fragd-url-shortener.herokuapp.com/shorten/?
    token=eyJ0eXAiOiJKV1QiLC6sbd0iOiJIUzI1NiJ9.IjVMWnUyR2czVzhOVHFKYk05SEhaTlNnZCI.no5LH7TYkss-jp7mqj9IywjZef5-r9JkzA2lVBbMijY
    &url=http://www.somelongdomain/1231231231
    &callback=JSON_CALLBACK

Keep in mind that this endpoint is authenticated, JWT generated authentication token is required.

## Thanks
[@technoweenie][4] for the awesome guillotine and [@mrtazz][8] for his katana development.

[1]: http://heroku.com
[2]: http://redistogo.com
[3]: https://github.com/technoweenie/guillotine
[4]: https://twitter.com/technoweenie
[5]: https://twitter.com/roidrage
[6]: https://github.com/mattmatt/s3itch
[7]: http://tapbots.com/software/tweetbot/
[8]: http://github.com/mrtazz/
