# Run unit tests.
echo "Running pwd for testing"
pwd

test ! -f phpunit.xml \
|| test ! -x $BIN/phpunit \
|| $BIN/phpunit \
		--fail-on-warning \
		--disallow-test-output \
		--report-useless-tests

# Require the coding standards, if they are not explicitly defined.
test -d $VENDOR/mediact/coding-standard \
|| composer require mediact/coding-standard \
		--dev \
		--prefer-dist \
		--no-scripts \
		--ignore-platform-reqs \
		--no-progress \
		--optimize-autoloader \
		--no-interaction

# Run static code analysis.
test ! -d src   || test -f phpcs.xml && $BIN/phpcs src
test ! -d src   || test -f phpmd.xml && $BIN/phpmd src xml phpmd.xml
test ! -d src   || $BIN/phpstan analyse src --level 4 --no-progress

test ! -d tests || test -f phpcs.xml && $BIN/phpcs tests
test ! -d tests || test -f phpmd.xml && $BIN/phpmd tests xml phpmd.xml
test ! -d tests || $BIN/phpstan analyse tests --level 4 --no-progress
