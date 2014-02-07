# Peregrine
1. _adjective: foreign; alien; wandering, traveling, or migrating._
2. _noun: a kick-ass falcon._

## Summary
Peregrine is a highly adaptive, extensible Entity-Component framework written for the Ruby programming language. Peregrine is platform and dependency agnostic, requiring _no_ additional dependencies for use as a library -- and works just as well with JRuby or Rubinius as it does with MRI Ruby.

## Installation
Peregrine is still a 'pre-release' version at present, so the best way to install it is to clone [its GitHub repository](https://github.com/solucet/peregrine).

```sh
$ git clone git@github.com:solucet/peregrine.git
```

Want to help with development (or hack at the source)? Just use Bundler and you're good to go.

```sh
$ gem install bundler
$ cd peregrine/ && bundle
```

## Documentation
The framework has been heavily documented with (decent-ish) information and should serve you well. If you installed Peregrine from the GitHub repository and installed the development dependencies, you can generate a local copy of its RDoc documentation by running `rake rdoc`.

## Thanks
Special thanks go to Chris Powell, as the Peregrine framework was conceptually inspired by his [Ruby Entity-Component Framework](https://github.com/cpowell/ruby-entity-component-framework) and its related tutorials (which are definitely recommended reading).

## License
Peregrine is made available under the terms of the MIT License. See the included LICENSE file for more information.
