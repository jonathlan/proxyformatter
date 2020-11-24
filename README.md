# ProxyFormatter

This is a basic proxy for properly formatting dates from a target web service.

## Demo

If you want to see the demo of this project you can visit: [https://proxyformatter.herokuapp.com](https://proxyformatter.herokuapp.com/)


## Use

It is very simple to use, just type one of below routes in the browser and send the parameters, results will be displayed on screen.

| Route | Parameters | Example |
| ------ | ------ | ------ |
| /format/ | None, just insert the destination URL | /format/https://sampleapis.com/countries/ |

## Development

Contributions are very much welcome.

This proxy runs in Ruby and the source code is available at GitHub [ProxyFormatter](https://github.com/jonathlan/proxyformatter)

### Installation

You need to [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/) v2.7.2+ to run.

Once done, you have to install bundler:

```sh
$ gem install bundler
```

The GemFile in ProxyFormatter already contains all dependencies, so all you need to do is to let bundler work:

```sh
$ cd proxyformatter
$ bundle install
```

ProxyFormatter also uses Sinatra 2.1.0 and in order to start the server you need to type:

```sh
$ ruby myapp.rb
```

Sinatra will start the server and you're ready to go, the usual address is: `http://localhost:4567`

