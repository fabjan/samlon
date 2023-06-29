# Samlon

Samlon is a work-in-progress implementation of the Lox programming language,
loosely following along with the Crafting Interpreters book
(https://craftinginterpreters.com/).

## Building

You need a compiler for Standard ML, the build script works with [Poly/ML] or
[MLton].

Poly/ML compiles faster so it's a good bet for testing things out.

Run the build script:
```
./build.sh
```

[Poly/ML]: https://www.polyml.org
[MLton]: http://www.mlton.org

## Running

The compiler output ends up in the `_build` directory.

To start the repl:
```
./_build/samlon
```

To run a script:
```
./_build/samlon path/to/the/script.lox
```

## Testing

There is a hacky test script included you can run
```
./test.sh
```

It'll interpret example programs and check the output.
