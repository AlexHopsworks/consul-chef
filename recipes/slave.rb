include_recipe "consul::default"
include_recipe "consul::security"

if node['consul']['retry_join']['provider'].empty?
    masters = "192.168.1.26"
elsif not node['consul']['retry_join']['provider'].empty? and node['consul']['retry_join']['tag_key'].nil?
    masters = "192.168.1.26"
else
    masters = "192.168.1.26"
end

crypto_dir = x509_helper.get_crypto_dir(node['consul']['user'])
hops_ca = "#{crypto_dir}/#{x509_helper.get_hops_ca_bundle_name()}"
certificate = "#{crypto_dir}/#{x509_helper.get_certificate_bundle_name(node['consul']['user'])}"
key = "#{crypto_dir}/#{x509_helper.get_private_key_pkcs8_name(node['consul']['user'])}"
template "#{node['consul']['conf_dir']}/consul.hcl" do
    source "config/slave.hcl.erb"
    owner node['consul']['user']
    group node['consul']['group']
    mode 0750
    variables({
        :masters => masters,
        :hops_ca => hops_ca,
        :certificate => certificate,
        :key => key
    })
end

include_recipe "consul::start"
