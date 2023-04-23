while inotifywait ../unparser/**/*.rb **/*.rb Gemfile Gemfile.shared mutant.gemspec; do
  bundle exec mutant environment test run --profile # \
##  && bundle exec mutant run --since main --fail-fast --zombie -- 'Mutant*' \
##  && bundle exec rubocop
done
