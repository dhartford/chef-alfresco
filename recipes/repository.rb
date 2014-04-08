maven_repos               = node['alfresco']['maven']['repos']
root_dir                  = node['alfresco']['root_dir']
mysql_connector_version   = node['alfresco']['mysqlconnector']['version']

repo_warpath              = node['alfresco']['repository']['war_path']
repo_properties_path      = node['alfresco']['repository']['properties_path']
repo_groupId              = node['alfresco']['repository']['groupId']
repo_artifactId           = node['alfresco']['repository']['artifactId']
repo_version              = node['alfresco']['repository']['version']

tomcat_home               = node['tomcat']['home']
tomcat_base               = node['tomcat']['base']
tomcat_webapp_dir         = node['tomcat']['webapp_dir']
tomcat_user               = node['tomcat']['user']
tomcat_group              = tomcat_group

cache_path                = Chef::Config['file_cache_path']

require 'nokogiri'

directory "root-dir" do
  path        root_dir
  owner       tomcat_user
  group       tomcat_group
  mode        "0775"
  recursive   true
end

maven 'mysql-connector-java' do
  group_id    'mysql'
  version     mysql_connector_version
  dest        "#{tomcat_home}/lib/"
  user        tomcat_user
  subscribes  :install, "directory[root-dir]", :immediately
end

if !repo_properties_path.nil?
  # Deploy the war file as it is
  ruby_block "deploy-alfresco-global" do
    block do
      require 'fileutils'
      FileUtils.cp "#{repo_properties_path}","#{tomcat_base}/shared/classes/alfresco-global.properties"
    end
    subscribes  :create, "directory[root-dir]", :immediately
  end  
else
  template "alfresco-global" do
    path        "#{tomcat_base}/shared/classes/alfresco-global.properties"
    source      "alfresco-global.properties.erb"
    owner       tomcat_user
    group       tomcat_group
    mode        "0660"
    subscribes  :create, "directory[root-dir]", :immediately
  end
end

directory "classes-alfresco" do
  path        "#{tomcat_base}/shared/classes/alfresco"
  owner       tomcat_user
  group       tomcat_group
  mode        "0775"
  subscribes  :create, "template[deploy-alfresco-global]", :immediately
  subscribes  :create, "template[alfresco-global]", :immediately
end

directory "alfresco-extension" do
  path        "#{tomcat_base}/shared/classes/alfresco/extension"
  owner       tomcat_user
  group       tomcat_group
  mode        "0775"
  subscribes  :create, "directory[classes-alfresco]", :immediately
end
 
if !repo_warpath.nil?
  # Deploy the war file as it is
  ruby_block "deploy-repo-warpath" do
    block do
      require 'fileutils'
      FileUtils.cp "#{repo_warpath}","#{tomcat_webapp_dir}/"
    end
  end  
else
  template "repo-log4j.properties" do
    path        "#{tomcat_base}/shared/classes/alfresco/extension/repo-log4j.properties"
    source      "repo-log4j.properties.erb"
    owner       tomcat_user
    group       tomcat_group
    mode        "0664"
    subscribes  :create, "directory[alfresco-extension]", :immediately
  end
  
  maven "alfresco" do
    artifact_id   repo_artifactId
    group_id      repo_groupId
    version       repo_version
    action        :put
    dest          cache_path
    owner         tomcat_user
    packaging     'war'
    repositories  maven_repos
    subscribes    :put, "template[repo-log4j.properties]", :immediately
  end

  ark "alfresco" do
    url "file://#{cache_path}/alfresco.war"
    path              cache_path
    owner             tomcat_user
    action            :put
    strip_leading_dir false
    append_env_path   false
    subscribes        :put, "maven[alfresco]", :immediately
  end

  ruby_block "patch-repo-webxml" do
    block do
      file = File.open("#{cache_path}/alfresco/WEB-INF/web.xml", "r")
      content = file.read
      file.close
      node = Nokogiri::HTML::DocumentFragment.parse(content)
      node.search(".//web-app").attr('metadata-complete', 'true')
      node.search(".//security-constraint").remove
      content = node.to_html(:encoding => 'UTF-8', :indent => 2)
      file = File.open("#{cache_path}/alfresco/WEB-INF/web.xml", "w")
      file.write(content)
      file.close unless file == nil    
    end
    subscribes :create, "ark[alfresco]", :immediately
  end

  ruby_block "deploy-alfresco" do
    block do
      require 'fileutils'
      FileUtils.rm_rf "#{cache_path}/alfresco/alfresco"
      FileUtils.cp_r "#{cache_path}/alfresco","#{tomcat_webapp_dir}/alfresco"
    end
    subscribes  :create, "ruby-block[patch-repo-webxml]", :immediately
  end
end

service "tomcat7"  do
  action      :restart
  subscribes  :restart, "ruby-block[deploy-repo-warpath]",:immediately
  subscribes  :restart, "ruby-block[deploy-alfresco]",:immediately
end
