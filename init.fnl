(fn payload->conn-names [payload-content]
  (icollect [_ v (ipairs payload-content)]
    (?. v :UserDefinedName)))

(fn conn-names->menubar-items [conn-names]
  (icollect [_ conn-name (ipairs conn-names)]
    {:title (.. "Connect to " conn-name)}))

(fn load-vpn-menus []
  (let [vpn-config-file (hs.settings.get :vpn-config-file)]
    (when (not (= nil vpn-config-file))
      (with-open [config-file (io.open vpn-config-file)]
        (-> (config-file:read :*a)
            (string.match "(<plist.*</plist>)")
            (hs.plist.readString)
            (?. :PayloadContent)
            (payload->conn-names)
            (conn-names->menubar-items))))))

(fn set-mobileconfig-file [_keys _menuitem]
  (let [{:1 config-file} (hs.dialog.chooseFileOrFolder "Please select .mobileconfig file")]
    (print (.. "VPN config file " (hs.inspect config-file)))
    (hs.settings.set :vpn-config-file config-file)))

;; TODO: figure out a way to reload once config is set

(fn set-auth-token [_keys _menuitem]
  (let [(_ vpn-auth-token) (hs.dialog.textPrompt "Auth Token"
                                                 "Enter auth token to generate otp from")]
    (print (.. "Auth Token" (hs.inspect vpn-auth-token)))
    (hs.settings.set :vpn-auth-token vpn-auth-token)))

(fn init []
  (let [menubar (hs.menubar.new)
        static-menu [{:title "-"}
                     {:title "Edit Preferences"
                      :menu [{:title "Set .mobileconfig file"
                              :fn set-mobileconfig-file}
                             {:title "Set auth token" :fn set-auth-token}]}]]
    (menubar:setTitle :AutoVPN)
    (menubar:setMenu (-> (load-vpn-menus)
                         (hs.fnutils.concat static-menu)))))

{: init}
