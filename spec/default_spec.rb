require 'spec_helper'

property['nginx_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/nginx/conf.d') do
  it { should exist }
  it { should be_directory }
end

%w[modules-available modules-enabled].each do |name|
  describe file('/etc/nginx/' + name) do
    it { should exist }
    it { should be_directory }
  end
end

%w[sites-available sites-enabled].each do |name|
  describe file('/etc/nginx/' + name) do
    it { should exist }
    it { should be_directory }
  end
end

describe file('/etc/nginx/snippets') do
  it { should exist }
  it { should be_directory }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

listening_http = listening_https = false
property['nginx_vhosts'].each do |vhost|
  if vhost.key?('ssl')
    listening_https = true
  else
    listening_http = true
  end
end

if listening_http
  describe port('80') do
    it { should be_listening }
  end
end
if listening_https
  describe port('443') do
    it { should be_listening }
  end
end
