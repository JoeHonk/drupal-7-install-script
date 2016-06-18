echo "▓█████▄  ██▀███   █    ██  ██▓███   ▄▄▄       ██▓    "
echo "▒██▀ ██▌▓██ ▒ ██▒ ██  ▓██▒▓██░  ██▒▒████▄    ▓██▒    "
echo "░██   █▌▓██ ░▄█ ▒▓██  ▒██░▓██░ ██▓▒▒██  ▀█▄  ▒██░    "
echo "░▓█▄   ▌▒██▀▀█▄  ▓▓█  ░██░▒██▄█▓▒ ▒░██▄▄▄▄██ ▒██░    "
echo "░▒████▓ ░██▓ ▒██▒▒▒█████▓ ▒██▒ ░  ░ ▓█   ▓██▒░██████▒"
echo " ▒▒▓  ▒ ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ▒░▓  ░"
echo " ░ ▒  ▒   ░▒ ░ ▒░░░▒░ ░ ░ ░▒ ░       ▒   ▒▒ ░░ ░ ▒  ░"
echo " ░ ░  ░   ░░   ░  ░░░ ░ ░ ░░         ░   ▒     ░ ░   "
echo "   ░       ░        ░                    ░  ░    ░  ░"
echo " ░                                                   "
read -p "Site Name?: " sn
read -p "Admin User Name?: " au
read -p "Admin Pass?: " ap
read -p "DB Name: " dn
read -p "DB User Name?: " du
read -p "DB Pass?: " dp

drush dl drupal --drupal-project-rename=drupaltemp
mv drupaltemp/{*,.ht*,.git*} .
rm -r drupaltemp
mkdir sites/all/libraries

drush site-install -y standard --db-url=mysql://$du:$dp@localhost/$dn  --site-name=$sn --account-name=$au --account-pass=$ap
drush pm-disable -y overlay


drush en -y pathauto
drush en -y views
drush en -y jquery_update
drush en -y fontyourface
drush en -y libraries
drush en -y webform
drush en -y devel
drush dl bootstrap
drush dl zen

drush dl ckeditor
drush en -y ckeditor
wget http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.4.2/ckeditor_4.4.2_full.zip
unzip ckeditor*.zip
mv ckeditor sites/all/libraries/
cp -R sites/all/themes/bootstrap/bootstrap_subtheme sites/all/themes/
mv sites/all/themes/bootstrap_subtheme/bootstrap_subtheme.info.starterkit sites/all/themes/bootstrap_subtheme/bootstrap_subtheme.info

sed -i 's/FollowSymLinks/SymLinksIfOwnerMatch/' .htaccess
chown -R $du .
