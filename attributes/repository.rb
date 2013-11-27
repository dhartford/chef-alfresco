#
# Cookbook Name:: alfresco
# attributes:: default
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright:: 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
### Platform Package Settings And Defaults
#
default['alfresco']['mysqlconnector']['version'] = "5.1.19"

default['alfresco']['db']['jdbc_url']  = "jdbc:mysql://#{node['alfresco']['db']['host']}/#{node['alfresco']['db']['database']}?useUnicode=yes&characterEncoding=UTF-8"

default['alfresco']['repository']['groupId'] = "org.alfresco"
default['alfresco']['repository']['artifactId'] = "alfresco"
default['alfresco']['repository']['version'] = "4.2.e"

default['alfresco']['img']['root'] = "/usr"
default['alfresco']['swf']['exe']  = "/usr/bin/pdf2swf"

default['alfresco']['ooo']['exe']      = "/usr/bin/soffice"
default['alfresco']['ooo']['enabled']  = "true"

default['alfresco']['jodconverter']['enabled']       = "true"
default['alfresco']['jodconverter']['office_home']   = "/usr/lib/libreoffice"
default['alfresco']['jodconverter']['port_numbers']  = "8100"

default['alfresco']['ftp']['enabled'] = false

### Mail Defaults

default['alfresco']['mail']['protocol']         = "smtp"
default['alfresco']['mail']['port']             = "25"
default['alfresco']['mail']['username']         = "anonymous"
default['alfresco']['mail']['encoding']         = "UTF-8"
default['alfresco']['mail']['from']['default']  = "alfresco@alfresco.org"

default['alfresco']['mail']['smtp']['auth']                 = "false"
default['alfresco']['mail']['smtps']['auth']                = "false"
default['alfresco']['mail']['smtps']['starttls']['enable']  = "false"

### IMAP Server Defaults

default['alfresco']['imap']['server']['enabled']  = "false"
default['alfresco']['imap']['server']['port']     = "1143"
default['alfresco']['imap']['server']['host']     = "0.0.0.0"

### Solr Defaults

default['alfresco']['solr']['solr_host'] = node['alfresco']['url']['solr']['host']
default['alfresco']['solr']['solr_port'] = node['alfresco']['url']['solr']['port']
default['alfresco']['solr']['solr_portssl'] = node['alfresco']['default_portssl']

### CIFS Server Defaults

default['alfresco']['cifs']['enabled']                      = "false"
default['alfresco']['cifs']['server_name']                  = "alfresco"
default['alfresco']['cifs']['ipv6']['enabled']              = "false"
default['alfresco']['cifs']['tcpip_smb']['port']            = "1445"
default['alfresco']['cifs']['netbios_smb']['name_port']     = "1137"
default['alfresco']['cifs']['netbios_smb']['datagram_port'] = "1138"
default['alfresco']['cifs']['netbios_smb']['session_port']  = "1139"