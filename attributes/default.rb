# Cookbook Name:: openldap
# Attributes:: openldap
#
# Copyright 2008-2009, Opscode, Inc.
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

default['openldap']['basedn'] = "dc=localdomain"
default['openldap']['server'] = "ldap.localdomain"
default['openldap']['tls_enabled'] = true
default['openldap']['pam_password'] = 'md5'

default['openldap']['passwd_ou'] = 'people'
default['openldap']['shadow_ou'] = 'people'
default['openldap']['group_ou'] = 'groups'
default['openldap']['automount_ou'] = 'automount'

default['openldap']['auth_basedn'] = node['openldap']['basedn']
default['openldap']['auth_host'] = node['openldap']['server']

unless node['domain'].nil? || node['domain'].split('.').count < 2
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(",dc=")}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['rootpw'] = nil
default['openldap']['rootdn'] = "cn=admin," + node['openldap']['basedn']

# File and directory locations for openldap.
case node['platform']
when "redhat","centos","amazon","scientific"
  default['openldap']['dir']        = "/etc/openldap"
  default['openldap']['run_dir']    = "/var/run/openldap"
  default['openldap']['module_dir'] = "/usr/lib64/openldap"
when "debian","ubuntu"
  default['openldap']['dir']        = "/etc/ldap"
  default['openldap']['run_dir']    = "/var/run/slapd"
  default['openldap']['module_dir'] = "/usr/lib/ldap"
else
  default['openldap']['dir']        = "/etc/ldap"
  default['openldap']['run_dir']    = "/var/run/slapd"
  default['openldap']['module_dir'] = "/usr/lib/ldap"
end
default['openldap']['datadir'] = "/var/lib/ldap"

default['openldap']['preseed_dir'] = "/var/cache/local/preseeding"
default['openldap']['tls_checkpeer'] = false
default['openldap']['pam_password'] = 'md5'

default['openldap']['manage_ssl'] = true
default['openldap']['ssl_dir'] = "#{openldap['dir']}/ssl"
default['openldap']['cafile']  = nil
default['openldap']['ssl_cert'] = "#{openldap['ssl_dir']}/#{openldap['server']}_cert.pem"
default['openldap']['ssl_key'] = "#{openldap['ssl_dir']}/#{openldap['server']}.pem"
default['openldap']['ssl_ciphers'] = nil

default['openldap']['slapd_type'] = nil

if node['openldap']['slapd_type'] == "slave" || node['openldap']['slapd_type'] == "mirror"
  default['openldap']['slapd_master'] = node['openldap']['server']
  default['openldap']['slapd_replpw'] = nil
  default['openldap']['slapd_rid']    = 102
end

Chef::Log.info("RID is #{node['openldap']['slapd_rid']}")

# Auth settings for Apache
if node['openldap']['basedn'] && node['openldap']['server']
  default['openldap']['auth_type']   = "openldap"
  default['openldap']['auth_binddn'] = "ou=people,#{openldap['basedn']}"
  default['openldap']['auth_bindpw'] = nil
  default['openldap']['auth_url']    = "ldap://#{openldap['server']}/#{openldap['auth_binddn']}?uid?sub?(objectClass=*)"
end

default['openldap']['size_limit'] = 500
default['openldap']['readonly'] = false
default['openldap']['repl_schemachecking'] = "off"
default['openldap']['repl_binddn'] = "cn=syncrole," + node['openldap']['basedn']
default['openldap']['repl_retry'] = nil
default['openldap']['serverid'] = nil