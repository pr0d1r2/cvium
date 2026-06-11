# list all recipes
default:
    @just --list

# compile cv.typ to cv.pdf
build:
    bash scripts/build.sh

# format cv.typ with typstyle
format:
    bash scripts/format.sh

# check cv.typ formatting
lint:
    bash scripts/lint.sh

# fetch and optimize CV photo from a url (e.g. https://github.com/user)
photo url:
    bash scripts/photo.sh {{url}}

# run bats tests
test:
    bats tests/

# generate plain text export cv.txt
text:
    bash scripts/text.sh

# watch cv.typ for changes and recompile
watch:
    bash scripts/watch.sh
