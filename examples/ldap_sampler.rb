$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    ldap_ext name: 'ldap_ext sample',
      test:        'sbind',
      user_dn:     'user_dn',
      user_pw:     'user_password',
      servername:  'your_ldap_server',
      secure:      true,
      port:        636

  end
  view_results name: 'debug'
end.run(path: '/usr/share/jmeter/bin/', gui: true)
