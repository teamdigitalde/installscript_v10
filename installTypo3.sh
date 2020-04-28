#!/bin/bash

url="http://get.typo3.org/10"
target="t3latest.tar.gz"
workingdirectory=${PWD}
clear

echo "Getting the TYPO3 Sources from ${url}, writing to ${target}"
# get the sourcec
wget $url -O $target --no-check-certificate > /dev/null 2>&1
# untar the tar ball
tar -xzf $target > /dev/null
# remove tar ball
rm -f $target

# delete typo3
rm -rf typo3
# make typo3 directory
mkdir typo3
# rename sources directory
mv typo3_src-* typo3_src

#htpasswd
printf 'beta:$1$$.OPcLRctp0tpQ81Db9tKP/' >> .htpasswd

#change to typo3 directory
cd typo3/

#create fileadmin, user_upload and typo3conf
mkdir fileadmin
cd fileadmin
mkdir user_upload
cd user_upload
ln -s ../../typo3conf/ext/sitepackage/Resources/Public/Images/Grids/ Grids
cd ../
cd ../
mkdir typo3conf

#create symlinks
ln -s ../typo3_src/ typo3_src
ln -s typo3_src/typo3 typo3

#create a git repository
git init > /dev/null

#pull TYPO3 Skeleton from github
#git pull https://github.com/teamdigitalde/TYPO3_Skeleton.git > /dev/null 2>&1

#mkdir typo3conf
cd typo3conf
touch LocalConfiguration.php
db=datenbankname
du=datenbankuser
dh=Hostname
dp=datenbankpasswort
installPasswort='$P$CAMstFeZNWquvENdiz4fxuKMY21hVL0'
touch LocalConfiguration.php
read -p 'Datenbankname: ' db
read -p 'Datenbankuser: ' du
read -p 'Hostname: ' dh
read -p 'Datenbankpasswort: ' dp
printf "
<?php
return [
    'BE' => [
        'debug' => true,
        'explicitADmode' => 'explicitAllow',
        'installToolPassword' => '"$installPasswort"',
        'loginSecurityLevel' => 'rsa',
        'passwordHashing' => [
            'className' => 'TYPO3\\CMS\\Core\\Crypto\\PasswordHashing\\BcryptPasswordHash',
            'options' => [],
        ],
    ],
    'DB' => [
        'Connections' => [
            'Default' => [
                'charset' => 'utf8',
                'dbname' => '"$db"',
                'driver' => 'mysqli',
                'host' => '"$dh"',
                'password' => '"$dp"',
                'port' => 3306,
                'user' => '"$du"',
            ],
        ],
    ],
    'EXT' => [
        'extConf' => [
            'backend' => 'a:6:{s:9:"loginLogo";s:0:"";s:19:"loginHighlightColor";s:0:"";s:20:"loginBackgroundImage";s:0:"";s:13:"loginFootnote";s:0:"";s:11:"backendLogo";s:0:"";s:14:"backendFavicon";s:0:"";}',
            'extensionmanager' => 'a:2:{s:21:"automaticInstallation";s:1:"1";s:11:"offlineMode";s:1:"0";}',
            'flux' => 'a:3:{s:9:"debugMode";s:1:"0";s:7:"compact";s:1:"0";s:12:"handleErrors";s:1:"0";}',
            'rsaauth' => 'a:1:{s:18:"temporaryDirectory";s:0:"";}',
            'scheduler' => 'a:2:{s:11:"maxLifetime";s:4:"1440";s:15:"showSampleTasks";s:1:"1";}',
        ],
    ],
    'EXTCONF' => [
        'lang' => [
            'availableLanguages' => [
                'de',
            ],
        ],
    ],
    'EXTENSIONS' => [
        'backend' => [
            'backendFavicon' => '',
            'backendLogo' => '',
            'loginBackgroundImage' => '',
            'loginFootnote' => '',
            'loginHighlightColor' => '',
            'loginLogo' => '',
        ],
        'extensionmanager' => [
            'automaticInstallation' => '1',
            'offlineMode' => '0',
        ],
        'flux' => [
            'autoload' => '0',
            'debugMode' => '0',
            'doktypes' => '0,1,4',
            'handleErrors' => '0',
            'pagesLanguageConfigurationOverlay' => '0',
            'plugAndPlay' => '0',
            'plugAndPlayDirectory' => 'design',
        ],
        'rsaauth' => [
            'temporaryDirectory' => '',
        ],
        'scheduler' => [
            'maxLifetime' => '1440',
            'showSampleTasks' => '1',
        ],
    ],
    'FE' => [
        'debug' => true,
        'loginSecurityLevel' => 'rsa',
        'pageNotFound_handling' => 'USER_FUNCTION:typo3conf/ext/sitepackage/Resources/Private/Php/pageNotFound.php:user_pageNotFound->pageNotFound',
        'passwordHashing' => [
            'className' => 'TYPO3\\CMS\\Core\\Crypto\\PasswordHashing\\BcryptPasswordHash',
            'options' => [],
        ],
    ],
    'GFX' => [
        'jpg_quality' => '80',
        'processor' => 'GraphicsMagick',
        'processor_allowTemporaryMasksAsPng' => false,
        'processor_colorspace' => 'RGB',
        'processor_effects' => false,
        'processor_enabled' => true,
        'processor_path' => '/usr/bin/',
        'processor_path_lzw' => '/usr/bin/',
    ],
    'MAIL' => [
        'transport' => 'sendmail',
        'transport_sendmail_command' => '/usr/sbin/sendmail -t -i ',
        'transport_smtp_encrypt' => '',
        'transport_smtp_password' => '',
        'transport_smtp_server' => '',
        'transport_smtp_username' => '',
    ],
    'SYS' => [
        'caching' => [
            'cacheConfigurations' => [
                'extbase_object' => [
                    'backend' => 'TYPO3\\CMS\\Core\\Cache\\Backend\\Typo3DatabaseBackend',
                    'frontend' => 'TYPO3\\CMS\\Core\\Cache\\Frontend\\VariableFrontend',
                    'groups' => [
                        'system',
                    ],
                    'options' => [
                        'defaultLifetime' => 0,
                    ],
                ],
            ],
        ],
        'devIPmask' => '*',
        'displayErrors' => 1,
        'encryptionKey' => '5ad2b220f239fd6aeb5615444010fd3ce1d110f6de9c5df917cdbf1c8ca8349034fa2c06272ab77b755f006c88a23187',
        'exceptionalErrors' => 12290,
        'sitename' => 'New TYPO3 site',
        'systemLogLevel' => 0,
    ],
];
" >> LocalConfiguration.php

touch PackageStates.php
printf "
<?php
# PackageStates.php

# This file is maintained by TYPO3's package management. Although you can edit it
# manually, you should rather use the extension manager for maintaining packages.
# This file will be regenerated automatically if it doesn't exist. Deleting this file
# should, however, never become necessary if you use the package commands.

return [
    'packages' => [
        'core' => [
            'packagePath' => 'typo3/sysext/core/',
        ],
        'scheduler' => [
            'packagePath' => 'typo3/sysext/scheduler/',
        ],
        'extbase' => [
            'packagePath' => 'typo3/sysext/extbase/',
        ],
        'fluid' => [
            'packagePath' => 'typo3/sysext/fluid/',
        ],
        'frontend' => [
            'packagePath' => 'typo3/sysext/frontend/',
        ],
        'fluid_styled_content' => [
            'packagePath' => 'typo3/sysext/fluid_styled_content/',
        ],
        'filelist' => [
            'packagePath' => 'typo3/sysext/filelist/',
        ],
        'impexp' => [
            'packagePath' => 'typo3/sysext/impexp/',
        ],
        'form' => [
            'packagePath' => 'typo3/sysext/form/',
        ],
        'install' => [
            'packagePath' => 'typo3/sysext/install/',
        ],
        'recordlist' => [
            'packagePath' => 'typo3/sysext/recordlist/',
        ],
        'backend' => [
            'packagePath' => 'typo3/sysext/backend/',
        ],
        'recycler' => [
            'packagePath' => 'typo3/sysext/recycler/',
        ],
        'reports' => [
            'packagePath' => 'typo3/sysext/reports/',
        ],
        'setup' => [
            'packagePath' => 'typo3/sysext/setup/',
        ],
        'rte_ckeditor' => [
            'packagePath' => 'typo3/sysext/rte_ckeditor/',
        ],
        'about' => [
            'packagePath' => 'typo3/sysext/about/',
        ],
        'belog' => [
            'packagePath' => 'typo3/sysext/belog/',
        ],
        'beuser' => [
            'packagePath' => 'typo3/sysext/beuser/',
        ],
        'extensionmanager' => [
            'packagePath' => 'typo3/sysext/extensionmanager/',
        ],
        'felogin' => [
            'packagePath' => 'typo3/sysext/felogin/',
        ],
        'filemetadata' => [
            'packagePath' => 'typo3/sysext/filemetadata/',
        ],
        'info' => [
            'packagePath' => 'typo3/sysext/info/',
        ],
        'lowlevel' => [
            'packagePath' => 'typo3/sysext/lowlevel/',
        ],
        'redirects' => [
            'packagePath' => 'typo3/sysext/redirects/',
        ],
        'rsaauth' => [
            'packagePath' => 'typo3/sysext/rsaauth/',
        ],
        'seo' => [
            'packagePath' => 'typo3/sysext/seo/',
        ],
        'sys_note' => [
            'packagePath' => 'typo3/sysext/sys_note/',
        ],
        't3editor' => [
            'packagePath' => 'typo3/sysext/t3editor/',
        ],
        'tstemplate' => [
            'packagePath' => 'typo3/sysext/tstemplate/',
        ],
        'viewpage' => [
            'packagePath' => 'typo3/sysext/viewpage/',
        ],
        'rte_ckeditor_image' => [
            'packagePath' => 'typo3conf/ext/rte_ckeditor_image/',
        ],
        'bootstrapslider' => [
            'packagePath' => 'typo3conf/ext/bootstrapslider/',
        ],
        'dce' => [
            'packagePath' => 'typo3conf/ext/dce/',
        ],
        'flux' => [
            'packagePath' => 'typo3conf/ext/flux/',
        ],
        'sitepackage' => [
            'packagePath' => 'typo3conf/ext/sitepackage/',
        ],
        'tdtemplate' => [
            'packagePath' => 'typo3conf/ext/tdtemplate/',
        ],
        'vhs' => [
            'packagePath' => 'typo3conf/ext/vhs/',
        ],
    ],
    'version' => 5,
];
" >> PackageStates.php

touch ENABLE_INSTALL_TOOL
mkdir ext
cd ext

mkdir sitepackage
cd sitepackage
git init > /dev/null
git pull https://github.com/teamdigitalde/sitepackage-v10 > /dev/null 2>&1

#copy .htaccess
#cp typo3_src/_.htaccess typo3/.htaccess

#basic access-restriction (beta/seite;)
printf "
# basic access-restriction (beta/seite;)
AuthName 'Geschützter Bereich'
AuthType Basic
AuthUserFile ${workingdirectory}/.htpasswd
require valid-user" >> .htaccess

mv .htaccess ../../..
mv index.php ../../..
mv autoload ../..

mysql -u $du -p$dp --default_character_set utf8 -h $dh $db < kickstart.sql
rm -rf kickstart.sql

cd ../
mkdir bootstrapslider
cd bootstrapslider
git init > /dev/null
git pull https://github.com/teamdigitalde/bootstrapslider > /dev/null 2>&1

cd ../
mkdir tdtemplate
cd tdtemplate
git init > /dev/null
git pull https://github.com/teamdigitalde/tdtemplate > /dev/null 2>&1

cd ../
git clone -b master https://github.com/FluidTYPO3/flux.git

mkdir vhs
cd vhs
git init > /dev/null
git pull https://github.com/FluidTYPO3/vhs > /dev/null 2>&1

cd ../
mkdir dce
cd dce
git init > /dev/null
git pull https://bitbucket.org/ArminVieweg/dce/src > /dev/null 2>&1

cd ../
mkdir rte_ckeditor_image
cd rte_ckeditor_image
git init > /dev/null
git pull https://github.com/netresearch/t3x-rte_ckeditor_image > /dev/null 2>&1

echo " "
echo "Done. Feel free to buy me a Beer :-)"
echo " "
echo "Now you can call the InstallTool and continue Installing TYPO3"
