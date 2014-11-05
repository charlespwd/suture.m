# Suture Geometries package
## Getting started
Hi there.

You're reading this because you decided to jump into this code.
Lucky you. I'm trying to make it easy for you (and me).

As I am writing this, I have three different ways to create planar
curves in the plane with Fourier Series.

  1. `SUTURE(Aphi, Ah, t)`  create a suture curve with the method
presented in [1].
  2. `FDPCURVE(FD, t)`  this one creates a planar curve with
polar Fourier **Descriptors** (it's a technical term) [2].
  3. `FTPCURVE(FT, t)`  same method as above, but instead of
using the polar terms, don't do the transformation and reconstruct a
curve with simple rectangular Fourier terms. [2]

Try `help suture.xxxxx` for more details.

 [1]  Gildner, Raymond. "A Fourier Method to Describe And Compare
      Suture Patterns", *Paleontologia Electronica*, 2003.

 [2]  Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

## Tests
### Running the tests
Option 1. Simply run `alltests` in your MATLAB command line.

Option 2. Run `run(suture.tests.xxxxxTest)` in your MATLAB command line to run a
specific suite of tests.

### Writing tests
Search for `unittest` in the MATLAB docs. The docs are decent enough
to get you started writing your own. Or take a look at any `xxxxxTest`
files in `+suture/+tests/`.


## License
MIT.
