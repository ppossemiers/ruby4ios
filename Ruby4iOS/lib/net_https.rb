=begin

= $RCSfile$ -- SSL/TLS enhancement for Net::HTTP.

== Info
  'OpenSSL for Ruby 2' project
  Copyright (C) 2001 GOTOU Yuuzou <gotoyuzo@notwork.org>
  All rights reserved.

== Licence
  This program is licenced under the same licence as Ruby.
  (See the file 'LICENCE'.)

== Requirements
  This program requires Net 1.2.0 or higher version.
  You can get it from RAA or Ruby's CVS repository.

== Version
  $Id: https.rb 16857 2008-06-06 08:05:24Z knu $
  
  2001-11-06: Contiributed to Ruby/OpenSSL project.
  2004-03-06: Some code is merged in to net/http.

== Example

Here is a simple HTTP client:

    require 'net/http'
    require 'uri'

    uri = URI.parse(ARGV[0] || 'http://localhost/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.start {
      http.request_get(uri.path) {|res|
        print res.body
      }
    }

It can be replaced by the following code:

    require 'net/https'
    require 'uri'

    uri = URI.parse(ARGV[0] || 'https://localhost/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.start {
      http.request_get(uri.path) {|res|
        print res.body
      }
    }

== class Net::HTTP

=== Instance Methods

: use_ssl?
    returns true if use SSL/TLS with HTTP.

: use_ssl=((|true_or_false|))
    sets use_ssl.

: peer_cert
    return the X.509 certificates the server presented.

: key, key=((|key|))
    Sets an OpenSSL::PKey::RSA or OpenSSL::PKey::DSA object.
    (This method is appeared in Michal Rokos's OpenSSL extension.)

: cert, cert=((|cert|))
    Sets an OpenSSL::X509::Certificate object as client certificate
    (This method is appeared in Michal Rokos's OpenSSL extension).

: ca_file, ca_file=((|path|))
    Sets path of a CA certification file in PEM format.
    The file can contrain several CA certificats.

: ca_path, ca_path=((|path|))
    Sets path of a CA certification directory containing certifications
    in PEM format.

: verify_mode, verify_mode=((|mode|))
    Sets the flags for server the certification verification at
    begining of SSL/TLS session.
    OpenSSL::SSL::VERIFY_NONE or OpenSSL::SSL::VERIFY_PEER is acceptable.

: verify_callback, verify_callback=((|proc|))
    Sets the verify callback for the server certification verification.

: verify_depth, verify_depth=((|num|))
    Sets the maximum depth for the certificate chain verification.

: cert_store, cert_store=((|store|))
    Sets the X509::Store to verify peer certificate.

: ssl_timeout, ssl_timeout=((|sec|))
    Sets the SSL timeout seconds.

=end

require 'net_http'
require 'openssl'

module Net

  class HTTP
    remove_method :use_ssl?
    def use_ssl?
      @use_ssl
    end

    # For backward compatibility.
    alias use_ssl use_ssl?

    # Turn on/off SSL.
    # This flag must be set before starting session.
    # If you change use_ssl value after session started,
    # a Net::HTTP object raises IOError.
    def use_ssl=(flag)
      flag = (flag ? true : false)
      raise IOError, "use_ssl value changed, but session already started" \
          if started? and @use_ssl != flag
      if flag and not @ssl_context
        @ssl_context = OpenSSL::SSL::SSLContext.new
      end
      @use_ssl = flag
    end

    def self.ssl_context_accessor(name)
      module_eval(<<-End, __FILE__, __LINE__ + 1)
        def #{name}
          return nil unless @ssl_context
          @ssl_context.#{name}
        end

        def #{name}=(val)
          @ssl_context ||= OpenSSL::SSL::SSLContext.new
          @ssl_context.#{name} = val
        end
      End
    end

    ssl_context_accessor :key
    ssl_context_accessor :cert
    ssl_context_accessor :ca_file
    ssl_context_accessor :ca_path
    ssl_context_accessor :verify_mode
    ssl_context_accessor :verify_callback
    ssl_context_accessor :verify_depth
    ssl_context_accessor :cert_store

    def ssl_timeout
      return nil unless @ssl_context
      @ssl_context.timeout
    end

    def ssl_timeout=(sec)
      raise ArgumentError, 'Net::HTTP#ssl_timeout= called but use_ssl=false' \
          unless use_ssl?
      @ssl_context ||= OpenSSL::SSL::SSLContext.new
      @ssl_context.timeout = sec
    end

    # For backward compatibility
    alias timeout= ssl_timeout=

    def peer_cert
      return nil if not use_ssl? or not @socket
      @socket.io.peer_cert
    end
  end

end
