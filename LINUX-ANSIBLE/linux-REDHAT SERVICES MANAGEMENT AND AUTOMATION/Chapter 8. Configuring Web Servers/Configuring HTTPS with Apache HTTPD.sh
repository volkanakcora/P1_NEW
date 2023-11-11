'Configuring HTTPS with Apache HTTPD'


'Describing the TLS Protocol'

Transport Layer Security (TLS) is the protocol used by HTTPS to protect web traffic from attacks on its authenticity, confidentiality, 
and integrity.

TLS uses public key cryptography to set up a secure TLS session. What one key can encrypt, only its matching key can decrypt.

Each server must be installed with a TLS certificate. This certificate contains information about which server the certificate belongs 
to, when it expires, and one half of a key pair; the public key. It is also digitally signed by a certificate authority (CA), and this 
signature can be used to verify the authenticity of the servers certificate. The server must also be installed with the private key 
that matches the certificates public key.


When a client connects to a server and requests a TLS session, they perform an initial handshake to agree on a set of encryption ciphers 
that both can support. The server provides the client with its certificate, which the client validates using the information in the 
certificate and the CAs signature. Then the client uses the public key to communicate securely with the server and to work with it 
to set up a faster session key that can be used to quickly encrypt and decrypt data, which is then used for the actual secure session.


'Obtaining a Server Certificate'


To get a new server certificate, you normally need to create an unsigned certificate signing request (CSR) and matching private key. 
You then need to provide that CSR to a CA that your users trust, validate to their satisfaction that you control that server, and 
arrange with them to sign the CSR, converting it into a valid certificate. Many commercial CAs exist that charge money for this service. 
Web browsers are normally preconfigured to trust signatures from commercial CAs.


'Creating a Certificate Signing Request'

'You can use Ansible to generate a private key and either a matching CSR or a matching self-signed certificate. You can also use tools 
from the openssl package to inspect these files, and as an alternative way to generate them.'

The openssl_privatekey Ansible module is used to create new TLS private keys. Private keys typically use one of two algorithms: RSA or 
ECDSA. RSA is more broadly supported by requires larger keys and is older. ECDSA supports smaller keys and provides similar security, 
but might not be supported by older web browsers.


The following example tasks create a 2048-bit RSA private key and a 256-bit ECDSA using the standard secp256r1 curve for similar 
security.

'- name: Make sure a RSA private key was generated
  openssl_privatekey:
    path: /etc/pki/tls/private/ansible.rsa.key

- name: Make sure an ECDSA private key was generated
  openssl_privatekey:
    path: /etc/pki/tls/private/ansible.ecdsa.key
    type: ECC
    curve: secp256r1'


After you have generated a key, whether it is RSA-based or ECDSA-based, you can use the openssl_csr Ansible module to create a 
certificate signing request.

'- name: CSR exists and is correct
  openssl_csr:
    path: /root/ansible.csr
    privatekey_path: /etc/pki/tls/private/ansible.key
    subject_alt_name: "DNS:demo.example.com,DNS:www.example.com"
    common_name: demo.example.com
    C: US
    ST: North Carolina
    L: Raleigh
    O: Example, Inc.
    backup: yes'


The 'subject_alt_name' key should be a comma-separated list of your TLS-enabled virtual hosts 
ServerName and all of its ServerAlias names, so that all of the virtual hosts names properly validate

A number of other fields indicate the subject of the certificate; the entity that owns it. The subject is your server and 
organization. The 'C', 'ST', 'L', and 'O' keys represent your country (in two-character ISO 3166 format), state or province, locality (city), 
and organization. The common_name is usually the name of the server the certificate belongs to. Which of these fields need to be filled 
in might depend on the policies of your CA.

You can inspect the contents of the CSR with the following command:

[root@host ~]# openssl req -in ansible.csr -noout -text

'When you generate a CSR, and you submit it to a CA for signing, you should not give them a copy of your private key. After the CA has 
signed your CSR, they will give you a finished server certificate, which you can install on your web server.'

'You can also use the openssl_certificate Ansible module to create a self-signed certificate for testing.
'
- name: Make sure self-signed certificate is correct
  openssl_certificate:
    path: /etc/pki/tls/certs/ansible.crt
    privatekey_path: /etc/pki/tls/private/ansible.key
    csr_path: /root/ansible.csr
    provider: selfsigned
    selfsigned_not_after: +90d


'The selfsigned_not_after: +90d variable and value indicate that when signed, this 
certificate will be valid for the next 90 days.'

You can inspect this TLS certificate with the following command:

[root@host ~]# openssl x509 -in ansible.crt -noout -text





                                        'Configuring a TLS-based Virtual Host'


'Apache HTTP Server needs to have an extension module installed in order to activate TLS support. On Red Hat Enterprise Linux 8, 
you can install this module using the mod_ssl package.'

[root@host ~]# yum install mod_ssl

This package automatically enables httpd with a default virtual host listening on port 443/TCP. This default virtual host is 
configured in /etc/httpd/conf.d/ssl.conf.


'Virtual hosts with TLS are configured in the same way as regular virtual hosts, with some additional parameters.'

The following is an example of a name-based TLS-enabled virtual host:

'<VirtualHost *:443>
  ServerName demo.example.com
  SSLEngine on1
  SSLCertificateFile /etc/pki/tls/certs/demo.example.com.crt2
  SSLCertificateKeyFile /etc/pki/tls/private/demo.example.com.key3
</VirtualHost>'


A number of settings are available that can be used to fine tune the behavior of your TLS-enabled virtual host. 
These might control the versions of the TLS protocol and what session encryption protocols are supported. A more detailed virtual 
host block is shown below:

'<VirtualHost _default_:443>
  ErrorLog logs/ssl_error_log
  TransferLog logs/ssl_access_log
  LogLevel warn
  SSLEngine on
  SSLProtocol all -SSLv2 -SSLv3    #1
  SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5   #2
  SSLHonorCipherOrder on   #3
  SSLCertificateFile /etc/pki/tls/certs/localhost.crt
  SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
  CustomLog logs/ssl_request_log \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
</VirtualHost>'
1

Specifies the list of protocols that httpd can use to communicate with clients. You should disable at least SSLv2 and SSLv3, which have known security issues.

2

Lists which encryption ciphers httpd can use when communicating with clients. The selection of ciphers can severely impact both performance and security.

3

Ensures that your server will prefer ciphers that appear earlier in the SSLCipherSuite list. Therefore, the most secure ciphers should be listed first.


