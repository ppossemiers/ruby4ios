#
# URI support for Ruby
#
# Author:: Akira Yamada <akira@ruby-lang.org>
# Documentation:: Akira Yamada <akira@ruby-lang.org>, Dmitry V. Sabanin <sdmitry@lrn.ru>
# License:: 
#  Copyright (c) 2001 akira yamada <akira@ruby-lang.org>
#  You can redistribute it and/or modify it under the same term as Ruby.
# Revision:: $Id: uri.rb 16038 2008-04-15 09:41:47Z kazu $
# 
# See URI for documentation
#

module URI
  # :stopdoc:
  VERSION_CODE = '000911'.freeze
  VERSION = VERSION_CODE.scan(/../).collect{|n| n.to_i}.join('.').freeze
  # :startdoc:

end

require 'uri_common'
require 'uri_generic'
require 'uri_ftp'
require 'uri_http'
require 'uri_https'
require 'uri_ldap'
require 'uri_ldaps'
# iOS MODIF
#require 'uri_mailto'
