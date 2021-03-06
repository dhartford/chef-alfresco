maintainer       "Maurizio Pillitu"
maintainer_email ""
license          "Apache 2.0"
description      "Installs Alfresco Community Edition."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

recipe "alfresco", "Installs Alfresco Repository, Share and Solr"

supports "ubuntu"

depends "imagemagick"
depends "java"
depends "mysql"
depends "database"
depends "openoffice"
depends "swftools"
depends "tomcat"
depends "maven"
depends "xml"
depends "apt"
depends "build-essential"
depends "openssl"
