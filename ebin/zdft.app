{application,zdft,
    [{description,"My Awesome Web Framework"},
     {vsn,"0.0.1"},
     {modules,
         [util,baidu,zdft_incoming_mail_controller,
          zdft_outgoing_mail_controller,zdft_view_lib_tags,
          zdft_custom_filters,zdft_custom_tags]},
     {registered,[]},
     {applications,[kernel,stdlib,crypto]},
     {env,
         [{test_modules,[]},
          {lib_modules,[util,baidu]},
          {websocket_modules,[]},
          {mail_modules,
              [zdft_incoming_mail_controller,zdft_outgoing_mail_controller]},
          {controller_modules,[]},
          {model_modules,[]},
          {view_lib_tags_modules,[zdft_view_lib_tags]},
          {view_lib_helper_modules,[zdft_custom_filters,zdft_custom_tags]},
          {view_modules,[]}]}]}.