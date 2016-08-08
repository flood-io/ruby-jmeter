module RubyJmeter
  class ExtendedDSL < DSL
    alias auth http_authorization_manager
    alias soap soapxmlrpc_request
    alias ldap ldap_request
    alias ldap_ext ldap_extended_request
    alias ldap_extended ldap_extended_request
    alias If if_controller
    alias Switch switch_controller
    alias While while_controller
    alias Interleave random_controller
    alias Random_order random_order_controller
    alias Simple simple_controller
    alias Once once_only_controller
    alias view_results view_results_tree
    alias log simple_data_writer
    alias response_graph response_time_graph
    alias bsh_pre beanshell_preprocessor
    alias bsh_post beanshell_postprocessor
  end
end
