# byoidsl

This repository is a companion to a live-coding project aimed at building your own interactive DSL.

You can check out the videos [here](https://www.youtube.com/playlist?list=PLfpFq_WLOW__7nB9z2CFUWZhzRM3oSBGM)

## Installation

Clone the project, then run `shards install` to install the dependencies.

You can now run the REPL with the following.
```
crystal byoidsl
```

## Usage

At this stage, the REPL can parse commands to
* show the current state of the grid
* evolve the grid
* assign a pattern to a variable
* set a pattern on the grid

Because we haven't implemented an interpreter yet, the commands will be parsed, but not executed.

Try running the following yourself!

```
(0,2) <- .****
show
evolve 2
n: ..*
(1,-2) <- n
```

## Contributing

1. Fork it (<https://github.com/lbarasti/byoidsl/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lbarasti](https://github.com/lbarasti) - creator and maintainer
