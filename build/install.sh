#!/usr/bin/env bash
set -e

path=$(dirname "$0")
base=$PWD/$path/..

# Pass all arguments to drush. Ripped from https://github.com/craychee/drupal-adonis/blob/master/build/drush-build.sh
# kudos!
drush_flags='-y'
while [ $# -gt 0 ]; do
  drush_flags="$drush_flags $1"
  shift
done

drush="$base/bin/drush.php $drush_flags"

pushd $base/www
$drush si standard --site-name="Scylla" --account-pass=admin -y
$drush dis -y overlay shortcuts comments toolbar
$drush en -y admin_menu module_filter features strongarm