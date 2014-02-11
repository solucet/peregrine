# Peregrine
1. _adjective: foreign; alien; wandering, traveling, or migrating._
2. _noun: a kick-ass falcon._

## Summary
Peregrine is a highly adaptive, extensible Entity-Component framework written for the Ruby programming language. Peregrine is platform and dependency agnostic, requiring _no_ additional dependencies for use as a library -- and works just as well with JRuby or Rubinius as it does with MRI Ruby.

## Installation
Peregrine is available as a library in the usual way -- just use RubyGems.

```sh
$ gem install peregrine
```

Want to help with development (or hack at the source)? Just clone [the GitHub repository][peregrine],  use Bundler, and you're good to go.

```sh
$ git clone git@github.com:solucet/peregrine.git
$ gem install bundler
$ cd peregrine/ && bundle
```

## Documentation
The framework has been heavily documented with information and should serve you well. If you installed Peregrine from the GitHub repository and installed the development dependencies, you can generate a local copy of its RDoc documentation by running `rake rdoc`.

If you are unfamiliar with Entity-Component design, it is highly recommended that you read about it in addition to reading the documentation for the Peregrine framework. Chris Powell wrote a [great series of tutorials][recf-tutorial] on using EC design in JRuby on his blog which also includes links to further reading on the subject.

## Thanks
Special thanks go to Chris Powell, as the Peregrine framework was conceptually inspired by his [Ruby Entity-Component Framework][recf] and its related tutorials (which are definitely recommended reading).

## License
Peregrine is made available under the terms of the MIT License. See the included LICENSE file for more information.

[peregrine]:     https://github.com/solucet/peregrine
[recf]:          https://github.com/cpowell/ruby-entity-component-framework
[recf-tutorial]: http://cbpowell.wordpress.com/2012/10/30/