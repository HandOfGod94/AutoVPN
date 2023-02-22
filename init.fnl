(fn set-mobileconfig-file [_keys _menuitem]
  (let [{:1 config-file} (hs.dialog.chooseFileOrFolder "Please select .mobileconfig file")]
    (print (.. "VPN config file" (hs.inspect config-file)))))

(fn set-auth-token [_keys _menuitem]
  (let [(_ vpn-token) (hs.dialog.textPrompt "Auth Token"
                                            "Enter auth token to generate otp from")]
    (print (.. "Auth Token" (hs.inspect vpn-token)))))

(fn init []
  (let [menubar (hs.menubar.new)]
    (menubar:setTitle :AutoVPN)
    (menubar:setMenu [{:title "Connect to VPN"}
                      {:title "-"}
                      {:title "Edit Preferences"
                       :menu [{:title "Set .mobileconfig file"
                               :fn set-mobileconfig-file}
                              {:title "Set auth token" :fn set-auth-token}]}])))

{: init}
