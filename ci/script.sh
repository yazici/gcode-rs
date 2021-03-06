# This script takes care of testing your crate

set -ex

main() {
    cross build --target $TARGET
    cross build --target $TARGET --all-features
    cross build --target $TARGET --release --all-features

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    cross test --target $TARGET
    cross test --target $TARGET --all-features
    cross test --target $TARGET --release --all-features

    # Make sure our README example stays up-to-date. For some reason, we can't
    # use `cross rustdoc ...` so we need to recompile
    if [ "$TRAVIS_RUST_VERSION" = nightly ]; then
        cargo build --all-features
        rustdoc --test -L target/debug/deps --extern gcode=target/debug/libgcode.rlib README.md
    fi
}

# we don't run the "test phase" when doing deploys
if [ -z $TRAVIS_TAG ]; then
    main
fi
