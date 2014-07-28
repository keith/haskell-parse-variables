Using Haskell, write a function to convert strings of the form `FOO=bar` into a
data type representing environment variables. Such a function would be useful in
library like [dotenv][].

[dotenv]: https://github.com/bkeepers/dotenv

### Prerequisites

You'll need recent versions of GHC and cabal-install (supporting sandboxing).
The easiest way to get these is probably to install the [Haskell Platform][hp]
which installs these and other tools. There are also packages available in most
package managers (including Homebrew).

[hp]: https://www.haskell.org/platform/

### Steps

Create a project sandbox:

```
$ cabal sandbox init
```

Install project dependencies:

```
$ cabal install --dependencies-only --enable-tests -j4
```

*Note:* the `-j4` argument should be the number of cores you wish to use for
compilation.

Run the specs:

```
$ cabal test
```

Make them pass!

```
$ $EDITOR src/ParseVariables.hs
```

### Extra Credit

The current set of tests should be passable using a list-based approach. Try
adding specs for the following forms:

- `FOO="bar with a \" that's escaped"`
- `FOO=bar\ with\ escaped\ spaces`
- `FOO="bar" # with trailing comment"

These may be complicated enough to require using a more powerful library like
[Parsec][]

[parsec]: https://hackage.haskell.org/package/parsec
